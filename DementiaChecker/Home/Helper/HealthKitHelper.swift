//
//  HealthKitHelper.swift
//  DementiaChecker
//
//  Created by 하창진 on 2/2/24.
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
        HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
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
    
    func getHeartRateData(start: Date, end: Date, completion: @escaping([HKSample]) -> Void){
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
    
    func getWalkingHeartRateData(start: Date, end: Date, completion: @escaping([HKSample]) -> Void){
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
    
    func getRestingHeartRateData(start: Date, end: Date, completion: @escaping([HKSample]) -> Void){
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
    
    func getStepCount(start: Date, end: Date, completion: @escaping (Double) -> Void){
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
    
    func getDistanceWalkingRunning(start: Date, end: Date, completion: @escaping (Double) -> Void){
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
    
    func getActivityEnergyBurned(start: Date, end: Date, completion: @escaping (Double) -> Void){
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
    
    func getOxygenSaturation(start: Date, end: Date, completion: @escaping ([HKSample]) -> Void){
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
    
    func getWristTemperature(start: Date, end: Date, completion: @escaping ([HKSample]) -> Void){
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
    
    func getSleepTime(start: Date, end: Date, completion: @escaping (Double?) ->  Void){
        var sleepHoursCount: Double = 0.0

        guard let sleepType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis) else{
            return
        }
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: sleepType, predicate: nil, limit: 30, sortDescriptors: [sortDescriptor]){ (query, samples, error) in
            guard error == nil, samples == samples as? [HKCategorySample] else{
                print("Error while getting sleep analysis: \(error.debugDescription)")
                return
            }
            
            DispatchQueue.main.async{
                if !samples!.isEmpty{
                    guard let result = samples as? [HKCategorySample] else{return}
                    
                    for sample in result{
                        guard let sleepValue = HKCategoryValueSleepAnalysis(rawValue: sample.value) else{
                            print("Invalid sleep data")
                            return
                        }
                        
                        let start = sample.startDate
                        let end = sample.endDate
                        self.inBedTime = sample.endDate.timeIntervalSince(sample.startDate)
                    }
                    
                }
                
                completion(self.inBedTime / 3600)
            }
        }
        
        healthStore.execute(query)
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
