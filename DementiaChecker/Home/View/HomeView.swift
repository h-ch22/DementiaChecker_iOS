//
//  HomeView.swift
//  DementiaChecker
//
//  Created by Changjin Ha on 1/28/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userManagement: UserManagement
    
    @StateObject private var helper = HealthKitHelper()
    @StateObject private var inspectionHelper = InspectionHelper()
    
    @State private var showInspectionResult = false
    @State private var symbols = [
        "lungs.fill", "heart.fill", "heart.fill", "heart.fill", "bed.double.fill", "flame.fill", "flame.fill", "flame.fill", "figure", "figure.run"
    ]
    
    @State private var colors = [
        Color.blue, Color.red, Color.red, Color.red, Color.cyan, Color.orange, Color.orange, Color.orange, Color.purple, Color.green
    ]
    
    @State private var titles = [
        "SpO2", "Heart Rate", "Resting HR", "Walking HR", "Sleep", "Steps", "Distance Walking", "Activity Energy", "Temperature", "Activity Time"
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
            return "\(String(format: "%.2f", helper.inBedTime)) hours"
            
        case 5:
            return "\(String(format: "%.0f", helper.steps)) steps"
            
        case 6:
            return "\(String(format: "%.2f", helper.distanceWalkingRunning)) m"
            
        case 7:
            return "\(String(format: "%.2f", helper.activityEnergy)) kcal"
            
        case 8:
            return "\(String(format: "%.2f", helper.wristTemperature)) °C"
            
        case 9:
            return "\(String(format: "%.2f", helper.activityMinute)) mins"
            
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
                        Text("Hello,\n\(userManagement.userInfo?.name ?? "")😆")
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
                            ForEach((0 ..< 10), id: \.self){ index in
                                HealthListModel(symbol: symbols[index], title: titles[index], value: getLifeLogValue(index: index), color: colors[index])

                            }
                        }
                    }.padding(20)
                    
                    HStack{
                        Image(systemName: "magnifyingglass")
                        
                        Spacer().frame(width: 5)
                        
                        Text("Recent Inspection Results")
                            .font(.caption)
                            .foregroundStyle(Color.gray)
                            .fontWeight(.semibold)
                        
                        Spacer()
                    }.padding(20)
                                        
                    VStack{
                        if !showInspectionResult{
                            Text("No recent inspection records.")
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.gray)
                        } else{
                            IncidenceRateListModel(data: inspectionHelper.inspectionResult)
                        }
                    }.padding([.horizontal], 20)
                }
                .animation(Animation.easeInOut(duration: 0.5), value: true)
                    .onAppear{
                        helper.requestAuthorization(){ _ in
                        }
                                                
                        helper.updateData(completion: { _ in
                            
                        })
                        
                        inspectionHelper.getLatestResult(completion: { result in
                            guard let result = result else{return}
                            
                            self.showInspectionResult = result
                        })
                    }
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(UserManagement())
}
