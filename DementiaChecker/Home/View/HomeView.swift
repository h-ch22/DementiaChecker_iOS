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
    
    var body: some View {
        ZStack(alignment: .top){
            LinearGradient(colors: [Color.backgroundStart, Color.backgroundEnd], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea(.all, edges: [.top, .bottom])
            
            ScrollView{
                VStack{
                    HStack{
                        Text("안녕하세요,\n\(userManagement.userInfo?.name ?? "")님😆")
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.white)
                        
                        Spacer()
                        
                        NavigationLink(destination: EmptyView()){
                            Image(systemName: "bell.fill")
                                .foregroundStyle(Color.txt.opacity(0.5))
                                .background(.ultraThinMaterial)
                        }.buttonStyle(CircleNewMorphButtonStyle(foreground: Color.btn, paddingValue: 7))
                    }.padding()
                    
                    VStack{                        
                        LazyHGrid(rows: columns){
                            ForEach((0 ..< 9), id: \.self){ index in
                                VStack{
                                    HStack{
                                        Image(systemName: symbols[index])
                                            .font(.caption)
                                            .foregroundStyle(colors[index])
                                        
                                        Text(titles[index])
                                            .font(.caption)
                                            .foregroundStyle(Color.txt)
                                        
                                        Spacer()
                                    }
                                    
                                    switch index{
                                    case 0:
                                        Text("__\(String(format: "%.2f", helper.oxygenSaturation * 100))__ %")
                                            .foregroundStyle(colors[index])
                                        
                                    case 1:
                                        Text("__\(String(format: "%.2f", helper.heartRate))__ BPM")
                                            .foregroundStyle(colors[index])
                                        
                                    case 2:
                                        Text("__\(String(format: "%.2f", helper.restingHeartRate))__ BPM")
                                            .foregroundStyle(colors[index])
                                        
                                    case 3:
                                        Text("__\(String(format: "%.2f", helper.walkingHeartRate))__ BPM")
                                            .foregroundStyle(colors[index])
                                        
                                    case 4:
                                        Text("__\(String(format: "%.2f", helper.inBedTime))__ 시간")
                                            .foregroundStyle(colors[index])
                                        
                                    case 5:
                                        Text("__\(String(format: "%.0f", helper.steps))__ 걸음")
                                            .foregroundStyle(colors[index])
                                        
                                    case 6:
                                        Text("__\(String(format: "%.2f", helper.distanceWalkingRunning))__ M")
                                            .foregroundStyle(colors[index])
                                        
                                    case 7:
                                        Text("__\(String(format: "%.2f", helper.activityEnergy))__ KCAL")
                                            .foregroundStyle(colors[index])
                                        
                                    case 8:
                                        Text("__\(String(format: "%.2f", helper.wristTemperature))__ °C")
                                            .foregroundStyle(colors[index])
                                        
                                    default:
                                        Text("")
                                    }
                                }
                                .padding(20)
                                .frame(width: (UIScreen.main.bounds.width * 0.8) / 2, height: 80)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .shadow(radius: 5)
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
