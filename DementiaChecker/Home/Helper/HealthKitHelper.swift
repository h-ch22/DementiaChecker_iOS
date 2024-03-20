//
//  HealthKitHelper.swift
//  DementiaChecker
//
//  Created by Changjin Ha on 2/2/24.
//

import Foundation
import HealthKit

class HealthKitHelper: ObservableObject{
    private let healthStore = HKHealthStore()
    private let read = Set([
        HKObjectType.quantityType(forIdentifier: .heartRate)!,
        HKObjectType.quantityType(forIdentifier: .restingHeartRate)!,
        HKObjectType.quantityType(forIdentifier: .walkingHeartRateAverage)!,
        HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
        HKObjectType.quantityType(forIdentifier: .stepCount)!,
        HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
        HKObjectType.quantityType(forIdentifier: .oxygenSaturation)!,
        HKObjectType.quantityType(forIdentifier: .appleSleepingWristTemperature)!,
        HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
        HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!,
        HKObjectType.quantityType(forIdentifier: .basalEnergyBurned)!
    ])
    
    private let heartRateUnit: HKUnit = HKUnit(from: "count/min")
    private let oxygenUnit: HKUnit = HKUnit(from: "%")
    private let wristTemperatureUnit: HKUnit = HKUnit(from: "degC")

    @Published var heartRate: Double = 0.0
    @Published var walkingHeartRate: Double = 0.0
    @Published var restingHeartRate: Double = 0.0
    @Published var steps: Double = 0.0
    @Published var distanceWalkingRunning: Double = 0.0
    @Published var activityEnergy: Double = 0.0
    @Published var oxygenSaturation: Double = 0.0
    @Published var inBedTime: Double = 0.0
    @Published var wristTemperature: Double = 0.0
    @Published var activityMinute: Double = 0.0
    
    @Published var accumulateActiveCalories = [LifeLogDataModel]()
    @Published var accumulateBasalEnergy = [LifeLogDataModel]()
    @Published var accumulateDistance = [LifeLogDataModel]()
    @Published var accumulateRest = [LifeLogDataModel]()
    @Published var accumulateSteps = [LifeLogDataModel]()
    @Published var accumulateTotalActivities = [LifeLogDataModel]()
    @Published var dateList = [Double]()
    @Published var lifeLogPredictData = [Double]()
    
    func requestAuthorization(completion: @escaping(_ result: Bool?) -> Void){
        self.healthStore.requestAuthorization(toShare: nil, read: read){(success, error) in
            if error != nil{
                print(error?.localizedDescription)
                completion(false)
                return
            } else{
                completion(success ? true : false)
            }
        }
    }
    
    func getLifeLogData(start: Date, end: Date, period: Int, completion: @escaping(_ result: Bool?) -> Void){
        let group = DispatchGroup()
        
        var dates = [String]()
        var values = [[Double]]()
        var activeCalories = [LifeLogDataModel]()
        
        group.enter()
        getAccumulateActiveCalories(start: start, end: end, completion: { result in
            self.accumulateActiveCalories = result
            group.leave()
        })
                
        group.enter()
        getAccumulateBasalEnergy(start: start, end: end, completion: { result in
            self.accumulateBasalEnergy = result
            group.leave()
        })
                
        group.enter()
        getAccumulateDistance(start: start, end: end, completion: { result in
            self.accumulateDistance = result
            group.leave()
        })
                
        group.enter()
        getAccumulateRest(start: start, end: end, completion: { result in
            self.accumulateRest = result
            group.leave()
        })
                
        group.enter()
        getAccumulateSteps(start: start, end: end, completion: { result in
            self.accumulateSteps = result
            group.leave()
        })
                
        group.enter()
        getAccumulateTotalActivities(start: start, end: end, completion: { result in
            self.accumulateTotalActivities = result
            group.leave()
        })
                
        group.notify(queue: .main){
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'kk:mm:ss'+09:00'"
            
            let restCount = self.accumulateRest.count
            let stepsCount = self.accumulateSteps.count
            let distanceCount = self.accumulateDistance.count
            let basalEnergyCount = self.accumulateBasalEnergy.count
            let activeCaloriesCount = self.accumulateActiveCalories.count
            let totalActivitiesCount = self.accumulateTotalActivities.count
            
            if self.accumulateRest.count != abs(period) || self.accumulateSteps.count != abs(period) ||
                self.accumulateDistance.count != abs(period) || self.accumulateBasalEnergy.count != abs(period) ||
                self.accumulateActiveCalories.count != abs(period) || self.accumulateTotalActivities.count != abs(period){
                
                print("Date List, Data List count does not match to period. Expected: \(abs(period))")
                print("****** Count List ******")
                print("Rest: \(restCount), Steps: \(stepsCount), Distance: \(distanceCount), BasalEnergy: \(basalEnergyCount), activeCalories: \(activeCaloriesCount), totalActivities: \(totalActivitiesCount)")
                completion(false)
                return
            }
            
            for i in 0 ..< abs(period){
                var data = [Double]()
                for date in self.accumulateActiveCalories{
                    self.dateList.append(CGFloat(date.date.timeIntervalSince1970))
                }
                
                data.append(self.accumulateActiveCalories[i].value)
                data.append(self.accumulateActiveCalories[i].value + self.accumulateBasalEnergy[i].value)
                data.append(self.accumulateDistance[i].value)
                data.append(self.accumulateRest[i].value)
                data.append(self.accumulateSteps[i].value)
                data.append(self.accumulateTotalActivities[i].value)
                
                self.lifeLogPredictData.append(contentsOf: data)
            }
            
            completion(true)
            return
        }
    }
    
    func updateData(completion: @escaping(_ result: Bool?) -> Void){
        let group = DispatchGroup()
        group.enter()
        
        self.getTodayActivityMinutes(completion: { _ in
            group.leave()
        })
        
        group.enter()
        
        self.getTodayHeartRateData(completion: { _ in
            group.leave()
        })
        
        group.enter()
        
        self.getTodayWalkingHeartRateData(completion: { _ in
            group.leave()
        })
        
        group.enter()
        
        self.getTodayRestingHeartRateData(completion: { _ in
            group.leave()
        })
        
        group.enter()
        
        self.getTodayStepCount(completion: { _ in
            group.leave()
        })
        
        group.enter()
        
        self.getTodayDistanceWalkingRunning(completion: { _ in
            group.leave()
        })
        
        group.enter()
        
        self.getTodayActivityEnergyBurned(completion: { _ in
            group.leave()
        })
        
        group.enter()
        
        self.getTodayOxygenSaturation(completion: { _ in
            group.leave()
        })
        
        group.enter()
        
        self.getTodayWristTemperature(completion: { _ in
            group.leave()
        })
        
        group.enter()
        
        self.getTodaySleepTime(completion: { _ in
            group.leave()
        })
        
        group.notify(queue: .main){
            completion(true)
        }
    }
    
    private func getAccumulateActiveCalories(start: Date, end: Date, completion: @escaping ([LifeLogDataModel]) -> Void){
        guard let activityQuantityType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else { return }
        var dataList: [LifeLogDataModel] = []
        
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.day = 1
        
        var anchorComponents = calendar.dateComponents([.day, .month, .year], from: Date())
        anchorComponents.hour = 0
        let anchorDate = calendar.date(from: anchorComponents)
        
        let query = HKStatisticsCollectionQuery(quantityType: activityQuantityType, quantitySamplePredicate: nil, options: .cumulativeSum, anchorDate: anchorDate!, intervalComponents: dateComponents)
        query.initialResultsHandler = {query, results, error in
            if let results = results{
                results.enumerateStatistics(from: start, to: end, with: { [self] statistics, stop in
                    if let quantity = statistics.sumQuantity(){
                        let date = statistics.startDate
                        let calories = quantity.doubleValue(for: HKUnit.kilocalorie())
                        
                        dataList.append(LifeLogDataModel(date: date, value: calories))
                    }
                })
                
                completion(dataList)
                return
            } else{
                print("Cannot get active calories")
                completion(dataList)
                return
            }
            
        }
        
        healthStore.execute(query)
    }
    
    private func getAccumulateBasalEnergy(start: Date, end: Date, completion: @escaping ([LifeLogDataModel]) -> Void){
        guard let activityQuantityType = HKQuantityType.quantityType(forIdentifier: .basalEnergyBurned) else { return }
        var dataList: [LifeLogDataModel] = []

        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.day = 1
        
        var anchorComponents = calendar.dateComponents([.day, .month, .year], from: Date())
        anchorComponents.hour = 0
        let anchorDate = calendar.date(from: anchorComponents)
        
        let query = HKStatisticsCollectionQuery(quantityType: activityQuantityType, quantitySamplePredicate: nil, options: .cumulativeSum, anchorDate: anchorDate!, intervalComponents: dateComponents)
        query.initialResultsHandler = {query, results, error in
            if let results = results{
                results.enumerateStatistics(from: start, to: end, with: { [self] statistics, stop in
                    if let quantity = statistics.sumQuantity(){
                        let date = statistics.startDate
                        let calories = quantity.doubleValue(for: HKUnit.kilocalorie())
                        
                        dataList.append(LifeLogDataModel(date: date, value: calories))
                    }
                })
                
                completion(dataList)
                return
            } else{
                print("Cannot get basal calories")
                completion(dataList)
                return
            }
        }
        
        healthStore.execute(query)
    }
    
    private func getAccumulateDistance(start: Date, end: Date, completion: @escaping ([LifeLogDataModel]) -> Void){
        guard let activityQuantityType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) else { return }
        var dataList: [LifeLogDataModel] = []

        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.day = 1
        
        var anchorComponents = calendar.dateComponents([.day, .month, .year], from: Date())
        anchorComponents.hour = 0
        let anchorDate = calendar.date(from: anchorComponents)
        
        let query = HKStatisticsCollectionQuery(quantityType: activityQuantityType, quantitySamplePredicate: nil, options: .cumulativeSum, anchorDate: anchorDate!, intervalComponents: dateComponents)
        query.initialResultsHandler = {query, results, error in
            if let results = results{
                results.enumerateStatistics(from: start, to: end, with: { [self] statistics, stop in
                    if let quantity = statistics.sumQuantity(){
                        let date = statistics.startDate
                        let distance = quantity.doubleValue(for: HKUnit.meter())
                        
                        dataList.append(LifeLogDataModel(date: date, value: distance))

                    }
                })
            
                completion(dataList)
                return
            } else{
                print("Cannot get disance")
                completion(dataList)
                return
            }
        }
        
        healthStore.execute(query)
    }
    
    private func getAccumulateRest(start: Date, end: Date, completion: @escaping ([LifeLogDataModel]) -> Void){
        guard let activityQuantityType = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime) else { return }
        var dataList: [LifeLogDataModel] = []

        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.day = 1
        
        var anchorComponents = calendar.dateComponents([.day, .month, .year], from: Date())
        anchorComponents.hour = 0
        let anchorDate = calendar.date(from: anchorComponents)
        
        let query = HKStatisticsCollectionQuery(quantityType: activityQuantityType, quantitySamplePredicate: nil, options: .cumulativeSum, anchorDate: anchorDate!, intervalComponents: dateComponents)
        query.initialResultsHandler = {query, results, error in
            if let results = results{
                results.enumerateStatistics(from: start, to: end, with: { [self] statistics, stop in
                    if let quantity = statistics.sumQuantity(){
                        let date = statistics.startDate
                        let excerciseTime = quantity.doubleValue(for: HKUnit.minute())
                        let restTime = 1440 - excerciseTime
                        
                        dataList.append(LifeLogDataModel(date: date, value: restTime))
                    }
                })
                
                completion(dataList)
                return
            } else{
                print("Cannot get rest")
                completion(dataList)
                return
            }
        }
        
        healthStore.execute(query)
    }
    
    private func getAccumulateSteps(start: Date, end: Date, completion: @escaping ([LifeLogDataModel]) -> Void){
        guard let activityQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        var dataList: [LifeLogDataModel] = []

        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.day = 1
        
        var anchorComponents = calendar.dateComponents([.day, .month, .year], from: Date())
        anchorComponents.hour = 0
        let anchorDate = calendar.date(from: anchorComponents)
        
        let query = HKStatisticsCollectionQuery(quantityType: activityQuantityType, quantitySamplePredicate: nil, options: .cumulativeSum, anchorDate: anchorDate!, intervalComponents: dateComponents)
        query.initialResultsHandler = {query, results, error in
            if let results = results{
                results.enumerateStatistics(from: start, to: end, with: { [self] statistics, stop in
                    if let quantity = statistics.sumQuantity(){
                        let date = statistics.startDate
                        let stepCount = quantity.doubleValue(for: HKUnit.count())
                        
                        dataList.append(LifeLogDataModel(date: date, value: stepCount))
                    }
                })
                
                completion(dataList)
                return
            } else{
                print("Cannot get steps")
                completion(dataList)
                return
            }
        }
        
        healthStore.execute(query)
    }
    
    private func getAccumulateTotalActivities(start: Date, end: Date, completion: @escaping ([LifeLogDataModel]) -> Void){
        guard let activityQuantityType = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime) else { return }
        var dataList: [LifeLogDataModel] = []

        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.day = 1
        
        var anchorComponents = calendar.dateComponents([.day, .month, .year], from: Date())
        anchorComponents.hour = 0
        let anchorDate = calendar.date(from: anchorComponents)
        
        let query = HKStatisticsCollectionQuery(quantityType: activityQuantityType, quantitySamplePredicate: nil, options: .cumulativeSum, anchorDate: anchorDate!, intervalComponents: dateComponents)
        query.initialResultsHandler = {query, results, error in
            if let results = results{
                results.enumerateStatistics(from: start, to: end, with: { [self] statistics, stop in
                    if let quantity = statistics.sumQuantity(){
                        let date = statistics.startDate
                        let activities = quantity.doubleValue(for: HKUnit.minute())
                        print(activities)
                        
                        dataList.append(LifeLogDataModel(date: date, value: activities))
                    }
                })
                
                completion(dataList)
                print(dataList)
                return
            } else{
                print("Cannot get total activities")
                completion(dataList)
                return
            }
        }
        
        healthStore.execute(query)
    }
    
    private func getTodayActivityMinutes(completion: @escaping(Double) -> Void){
        let start = Calendar.current.startOfDay(for: Date())
        let end = Date()
        
        guard let exercieseQuantityType = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime) else{return}
        
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictEndDate)
        let query = HKStatisticsQuery(quantityType: exercieseQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum){ (_, result, error) in
            guard let result = result, let sum = result.sumQuantity() else{
                print("Getting activity minutes data : Fail")
                return
            }
            
            if error != nil{
                print(error?.localizedDescription)
                return
            }

            DispatchQueue.main.async{
                self.activityMinute = sum.doubleValue(for: HKUnit.minute())
                completion(sum.doubleValue(for: HKUnit.minute()))
            }
        }
        
        healthStore.execute(query)
    }
    
    private func getTodayHeartRateData(completion: @escaping([HKSample]) -> Void){
        let start = Calendar.current.startOfDay(for: Date())
        let end = Date()
        
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .heartRate) else{return}
        
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor]){ (sample, result, error) in
            guard error == nil else{
                print("Getting heart rate data error: \(error.debugDescription)")
                return
            }
            
            guard let resultData = result else{
                print("Getting heart rate data : Fail")
                return
            }
            
            DispatchQueue.main.async{
                self.extractHeartRateData(results: resultData, type: "heartRate")
                completion(resultData)
            }
        }
        
        healthStore.execute(query)
    }
    
    private func getTodayWalkingHeartRateData(completion: @escaping([HKSample]) -> Void){
        let start = Calendar.current.startOfDay(for: Date())
        let end = Date()
        
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .walkingHeartRateAverage) else{return}
        
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor]){ (sample, result, error) in
            guard error == nil else{
                print("Getting Walking heart rate data error: \(error.debugDescription)")
                return
            }
            
            guard let resultData = result else{
                print("Getting Walking heart rate data : Fail")
                return
            }
            
            DispatchQueue.main.async{
                self.extractHeartRateData(results: resultData, type: "walkingHeartRate")
                completion(resultData)
            }
        }
        
        healthStore.execute(query)
    }
    
    private func getTodayRestingHeartRateData(completion: @escaping([HKSample]) -> Void){
        let start = Calendar.current.startOfDay(for: Date())
        let end = Date()
        
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .restingHeartRate) else{return}
        
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor]){ (sample, result, error) in
            guard error == nil else{
                print("Getting Resting heart rate data error: \(error.debugDescription)")
                return
            }
            
            guard let resultData = result else{
                print("Getting Resting heart rate data : Fail")
                return
            }
            
            DispatchQueue.main.async{
                self.extractHeartRateData(results: resultData, type: "restingHeartRate")
                completion(resultData)
            }
        }
        
        healthStore.execute(query)
    }
    
    private func getTodayStepCount(completion: @escaping (Double) -> Void){
        let start = Calendar.current.startOfDay(for: Date())
        let end = Date()
        
        guard let stepQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount) else{
            return
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum){(_, result, error) in
            guard let result = result, let sum = result.sumQuantity() else{
                print("Getting step count data : Fail")
                return
            }
            
            if error != nil{
                print(error?.localizedDescription)
                return
            }
            
            DispatchQueue.main.async{
                self.steps = sum.doubleValue(for: HKUnit.count())
                completion(sum.doubleValue(for: HKUnit.count()))
            }
        }
        
        healthStore.execute(query)
    }
    
    private func getTodayDistanceWalkingRunning(completion: @escaping (Double) -> Void){
        let start = Calendar.current.startOfDay(for: Date())
        let end = Date()
        
        guard let distanceWalkingRunningType = HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning) else{
            return
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: distanceWalkingRunningType, quantitySamplePredicate: predicate, options: .cumulativeSum){(_, result, error) in
            var distance: Double = 0
            
            guard let result = result, let sum = result.sumQuantity() else{
                print("Getting Distance Walking Running Data : Fail")
                return
            }
            
            distance = sum.doubleValue(for: HKUnit.meter())
            
            DispatchQueue.main.async{
                self.distanceWalkingRunning = distance
                completion(distance)
            }
        }
        
        healthStore.execute(query)
    }
    
    private func getTodayActivityEnergyBurned(completion: @escaping (Double) -> Void){
        let start = Calendar.current.startOfDay(for: Date())
        let end = Date()
        
        guard let activeEnergyBurnedType = HKSampleType.quantityType(forIdentifier: .activeEnergyBurned) else{
            return
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: activeEnergyBurnedType, quantitySamplePredicate: predicate, options: .cumulativeSum){(_, result, error) in
            var cal: Double = 0
            
            if error != nil{
                print(error?.localizedDescription)
                return
            }
            
            guard let result = result, let sum = result.sumQuantity() else{
                print("Getting Activity Energy Burned Data : Fail")
                return
            }
            
            cal = sum.doubleValue(for: HKUnit.kilocalorie())
            
            DispatchQueue.main.async{
                self.activityEnergy = cal
                completion(cal)
            }
        }
        
        healthStore.execute(query)
    }
    
    private func getAccumulateSleepData(start: Date, end: Date, completion: @escaping ([LifeLogDataModel]) -> Void){
        let start = Calendar.current.startOfDay(for: Date())
        let end = Date()
        
        guard let sleepType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis) else{
            return
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!, predicate: nil, limit: 30, sortDescriptors: [sortDescriptor]){ [weak self] (query, sleepResult, error) -> Void in
            if error != nil{
                return
            }
            
            if let result = sleepResult{
                DispatchQueue.main.async{
                    for data in result{
                        if let data = data as? HKCategorySample{
                            switch data.value{
                            case 0:
                                self?.inBedTime += Double((Int(data.endDate.timeIntervalSince(data.startDate)) % 3600) / 60)
                                
                            case 1:
                                self?.inBedTime += Double((Int(data.endDate.timeIntervalSince(data.startDate)) % 3600) / 60)

                            default:
                                break
                            }
                        }
                    }
                }
            }
        }
        
        healthStore.execute(query)
    }
    
    private func getAccumulateOxygenSaturation(start: Date, end: Date, completion: @escaping([LifeLogDataModel]) -> Void){
        guard let activityQuantityType = HKQuantityType.quantityType(forIdentifier: .oxygenSaturation) else { return }
        var dataList: [LifeLogDataModel] = []

        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.day = 1
        
        var anchorComponents = calendar.dateComponents([.day, .month, .year], from: Date())
        anchorComponents.hour = 0
        let anchorDate = calendar.date(from: anchorComponents)
        
        let query = HKStatisticsCollectionQuery(quantityType: activityQuantityType, quantitySamplePredicate: nil, options: .cumulativeSum, anchorDate: anchorDate!, intervalComponents: dateComponents)
        query.initialResultsHandler = {query, results, error in
            if let results = results{
                results.enumerateStatistics(from: start, to: end, with: { [self] statistics, stop in
                    if let quantity = statistics.sumQuantity(){
                        let date = statistics.startDate
                        let oxygenSaturation = quantity.doubleValue(for: self.oxygenUnit)
                        
                        dataList.append(LifeLogDataModel(date: date, value: oxygenSaturation))
                    }
                })
                
                completion(dataList)
                print(dataList)
                return
            } else{
                print("Cannot get total activities")
                completion(dataList)
                return
            }
        }
        
        healthStore.execute(query)
    }
    
    private func getAccumulateWristTemperature(start: Date, end: Date, completion: @escaping([LifeLogDataModel]) -> Void){
        guard let activityQuantityType = HKQuantityType.quantityType(forIdentifier: .appleSleepingWristTemperature) else { return }
        var dataList: [LifeLogDataModel] = []

        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.day = 1
        
        var anchorComponents = calendar.dateComponents([.day, .month, .year], from: Date())
        anchorComponents.hour = 0
        let anchorDate = calendar.date(from: anchorComponents)
        
        let query = HKStatisticsCollectionQuery(quantityType: activityQuantityType, quantitySamplePredicate: nil, options: .cumulativeSum, anchorDate: anchorDate!, intervalComponents: dateComponents)
        query.initialResultsHandler = {query, results, error in
            if let results = results{
                results.enumerateStatistics(from: start, to: end, with: { [self] statistics, stop in
                    if let quantity = statistics.sumQuantity(){
                        let date = statistics.startDate
                        let wristTemperature = quantity.doubleValue(for: self.wristTemperatureUnit)
                        
                        dataList.append(LifeLogDataModel(date: date, value: wristTemperature))
                    }
                })
                
                completion(dataList)
                print(dataList)
                return
            } else{
                print("Cannot get total activities")
                completion(dataList)
                return
            }
        }
        
        healthStore.execute(query)
    }
    
    private func getTodayOxygenSaturation(completion: @escaping ([HKSample]) -> Void){
        let start = Calendar.current.startOfDay(for: Date())
        let end = Date()
        
        guard let oxygenSaturationType = HKSampleType.quantityType(forIdentifier: .oxygenSaturation) else{
            return
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let osUnit: HKUnit = HKUnit(from: "%")
        
        let query = HKSampleQuery(sampleType: oxygenSaturationType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor]){(query, result, error) in
            guard error == nil else{
                print("Getting Oxygen Saturation Data error : \(error.debugDescription)")
                return
            }
            
            guard let resultData = result else{
                print("Getting Oxygen Saturation Data : Fail")
                return
            }
            
            DispatchQueue.main.async{
                if !resultData.isEmpty{
                    guard let recent = resultData[0] as? HKQuantitySample else{return}
                    self.oxygenSaturation = recent.quantity.doubleValue(for: self.oxygenUnit)
                }

                completion(resultData)
            }
        }
        
        healthStore.execute(query)
    }
    
    private func getTodayWristTemperature(completion: @escaping ([HKSample]) -> Void){
        let start = Calendar.current.startOfDay(for: Date())
        let end = Date()
        
        guard let wristTemperatureType = HKSampleType.quantityType(forIdentifier: .appleSleepingWristTemperature) else{
            return
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        let query = HKSampleQuery(sampleType: wristTemperatureType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor]){ (sample, result, error) in
            guard error == nil else{
                print("Getting wrist temperature data error: \(error.debugDescription)")
                return
            }
            
            guard let resultData = result else{
                print("Getting wrist temperatue data : Fail")
                return
            }
            
            DispatchQueue.main.async{
                if !resultData.isEmpty{
                    guard let recent: HKQuantitySample = resultData[0] as? HKQuantitySample else{return}
                    self.wristTemperature = recent.quantity.doubleValue(for: self.wristTemperatureUnit)
                    completion(resultData)
                }

            }
        }
        
        healthStore.execute(query)
    }
    
    private func getTodaySleepTime(completion: @escaping (Double?) ->  Void){
        let start = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let end = Date()
        var datas = [DateInterval]()
        
        guard let sleepType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis) else{
            return
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!, predicate: nil, limit: 30, sortDescriptors: [sortDescriptor]){ [weak self] (query, sleepResult, error) -> Void in
            if error != nil{
                completion(0.0)
                return
            }
            
            if let result = sleepResult{
                DispatchQueue.main.async{
                    for data in result{
                        if let data = data as? HKCategorySample{
                            switch data.value{
                            case 0:
                                datas.append(DateInterval(start: data.startDate, end: data.endDate))

                            default:
                                break
                            }
                        }
                    }
                    
                    let total = self?.calculateSpentTime(for: datas)
                    print(total)
                    self?.inBedTime = (Double(total ?? 0.0) / 60) / 60
                }
            }
        }
        
        healthStore.execute(query)
    }
    
    private func calculateSpentTime(for intervals: [DateInterval]) -> TimeInterval {
       guard intervals.count > 1 else {
           return intervals.first?.duration ?? 0
       }
       
       let sorted = intervals.sorted { $0.start < $1.start }
       
       var total: TimeInterval = 0
       var start = sorted[0].start
       var end = sorted[0].end
       
       for i in 1..<sorted.count {
           
           if sorted[i].start > end {
               total += end.timeIntervalSince(start)
               start = sorted[i].start
               end = sorted[i].end
           } else if sorted[i].end > end {
               end = sorted[i].end
           }
       }
       
       total += end.timeIntervalSince(start)
       return total
   }
    
    private func extractHeartRateData(results: [HKSample], type: String){
        if !results.isEmpty{
            guard let result: HKQuantitySample = results[0] as? HKQuantitySample else{return}
                    
            switch type{
            case "heartRate": self.heartRate = result.quantity.doubleValue(for: heartRateUnit)
            case "walkingHeartRate": self.walkingHeartRate = result.quantity.doubleValue(for: heartRateUnit)
            case "restingHeartRate": self.restingHeartRate = result.quantity.doubleValue(for: heartRateUnit)
            default: return
            }
        }
    }

}
