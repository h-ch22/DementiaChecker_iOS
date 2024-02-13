//
//  HomeView.swift
//  DementiaChecker
//
//  Created by 하창진 on 1/28/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userManagement: UserManagement
    
    @StateObject private var helper = HealthKitHelper()
    @State private var symbols = [
        "lungs.fill", "heart.fill", "heart.fill", "heart.fill", "bed.double.fill", "flame.fill", "flame.fill", "flame.fill", "figure"
    ]
    
    @State private var colors = [
        Color.blue, Color.red, Color.red, Color.red, Color.cyan, Color.orange, Color.orange, Color.orange, Color.purple
    ]
    
    @State private var titles = [
        "산소포화도", "심박수", "휴식기 심박수", "걷기 심박수", "수면", "걸음", "움직인 거리", "소모 칼로리", "체온"
    ]
    
    @State private var columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    private func getLifeLogValue(index: Int) -> String{
        switch index{
        case 0:
            return "\(String(format: "%.2f", helper.oxygenSaturation * 100)) %"
            
        case 1:
            return "\(String(format: "%.2f", helper.heartRate)) BPM"
            
        case 2:
            return "\(String(format: "%.2f", helper.restingHeartRate)) BPM"
            
        case 3:
            return "\(String(format: "%.2f", helper.walkingHeartRate)) BPM"
            
        case 4:
            return "\(String(format: "%.2f", helper.inBedTime)) 시간"
            
        case 5:
            return "\(String(format: "%.0f", helper.steps)) 걸음"
            
        case 6:
            return "\(String(format: "%.2f", helper.distanceWalkingRunning)) m"
            
        case 7:
            return "\(String(format: "%.2f", helper.activityEnergy)) kcal"
            
        case 8:
            return "\(String(format: "%.2f", helper.wristTemperature)) °C"
            
        default:
            return ""
        }
    }
    
    var body: some View {
        ZStack(alignment: .top){
            Color.background.ignoresSafeArea(.all, edges: [.top, .bottom])
            
            ScrollView{
                VStack{
                    HStack{
                        Text("안녕하세요,\n\(userManagement.userInfo?.name ?? "")님😆")
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.txt)
                        
                        Spacer()
                        
                        NavigationLink(destination: EmptyView()){
                            Image(systemName: "bell.fill")
                                .foregroundStyle(Color.txt)
                        }.buttonStyle(CircleNewMorphButtonStyle(foreground: Color.background, paddingValue: 7))
                    }.padding()
                    
                    VStack{                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]){
                            ForEach((0 ..< 9), id: \.self){ index in
                                HealthListModel(symbol: symbols[index], title: titles[index], value: getLifeLogValue(index: index), color: colors[index])

                            }
                        }
                    }.padding(20)
 
                }                
                .animation(.easeInOut)

                    .onAppear{
                        helper.requestAuthorization(){result in
                            guard let result = result else{return}
                        }
                        
                        let start = Calendar.current.startOfDay(for: Date())
                        
                        helper.getStepCount(start: start, end: Date()){ result in
                            guard result != nil else{return}
                        }
                        
                        helper.getOxygenSaturation(start: start, end: Date()){ result in
                            guard result != nil else{return}
                        }
                        
                        helper.getHeartRateData(start: start, end: Date()){ result in
                            guard result != nil else{return}
                        }
                        
                        helper.getRestingHeartRateData(start: start, end: Date()){ result in
                            guard result != nil else{return}
                        }
                        
                        helper.getWalkingHeartRateData(start: start, end: Date()){ result in
                            guard result != nil else{return}
                        }
                        
                        helper.getActivityEnergyBurned(start: start, end: Date()){ result in
                            guard result != nil else{return}
                        }
                        
                        helper.getDistanceWalkingRunning(start: start, end: Date()){ result in
                            guard result != nil else{return}
                        }
                        
                        helper.getSleepTime(start: start, end: Date()){ result in
                            guard result != nil else{return}
                        }
                        
                        helper.getWristTemperature(start: start, end: Date()){ result in
                            guard result != nil else{return}
                        }
                    }
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(UserManagement())
}
