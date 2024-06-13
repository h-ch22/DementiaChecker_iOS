//
//  HistoryView.swift
//  DementiaChecker
//
//  Created by Changjin Ha on 1/28/24.
//

import SwiftUI

struct HistoryView: View {
    @StateObject private var helper = InspectionHelper()
    @State private var showView = false
    @State private var docList = [String]()
    @State private var selectedIndex = 0
    @State private var showMMSEResult = false
    
    @EnvironmentObject private var userManagement: UserManagement
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack{
            Color.background.ignoresSafeArea(.all, edges: [.top, .bottom])
            
            if !showView{
                VStack{
                    Spacer()
                    
                    DotProgressView()
                    
                    Spacer()
                }.padding(20)
            } else{
                if docList.isEmpty{
                    VStack{
                        Spacer()
                        
                        Image(systemName: "plus")
                            .foregroundStyle(Color.gray)
                        
                        Spacer().frame(height: 5)
                        
                        Text("You can review diagnosis results on this page once dementia diagnosis is completed.")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color.gray)
                        
                        Spacer()
                    }.padding(20)
                } else{
                    ScrollView{
                        VStack{
                            Picker("Select Examination Date", selection: $selectedIndex){
                                ForEach(docList.indices, id: \.self){ index in
                                    Text(docList[index])
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .cornerRadius(15)
                            .padding()
                            
                            Spacer().frame(height: 20)
                            
                            switch helper.inspectionResult.type{
                            case .NORMAL:
                                HStack{
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.largeTitle)
                                        .foregroundStyle(Color.green)
                                    
                                    Text("No issues were found from the user's data by Dementia Checker.")
                                        .foregroundStyle(Color.txt)
                                        .fontWeight(.semibold)
                                    
                                    Spacer()
                                }
                                
                                Spacer().frame(height: 10)
                                
                                HStack{
                                    Text("No symptoms of mild cognitive impairment (MCI) or dementia were identified in the user.\nThe user is presumed to be in a normal state.")
                                        .font(.caption)
                                        .foregroundStyle(Color.gray)
                                    
                                    Spacer()
                                }
                                
                            case .MCI:
                                HStack{
                                    Image(systemName: "exclamationmark.circle.fill")
                                        .font(.largeTitle)
                                        .foregroundStyle(Color.orange)
                                    
                                    Text("Dementia Checker has identified symptoms of mild cognitive impairment (MCI) in the user.")
                                        .foregroundStyle(Color.txt)
                                        .fontWeight(.semibold)
                                    
                                    Spacer()
                                }
                                
                                Spacer().frame(height: 10)
                                
                                HStack{
                                    Text("Symptoms of mild cognitive impairment (MCI) have been identified in the user.\nTake measures to prevent progression to dementia by improving lifestyle habits.")
                                        .font(.caption)
                                        .foregroundStyle(Color.gray)
                                    
                                    Spacer()
                                }
                                
                                
                            case .DEMENTIA:
                                HStack{
                                    Image(systemName: "exclamationmark.circle.fill")
                                        .font(.largeTitle)
                                        .foregroundStyle(Color.red)
                                    
                                    Text("Dementia Checker has identified symptoms of dementia in the user's data.")
                                        .foregroundStyle(Color.txt)
                                        .fontWeight(.semibold)
                                    
                                    Spacer()
                                }
                                
                                Spacer().frame(height: 10)
                                
                                HStack{
                                    Text("Symptoms of dementia have been identified in the user.\nVisit a medical institution immediately for further examination.")
                                        .font(.caption)
                                        .foregroundStyle(Color.gray)
                                    
                                    Spacer()
                                }
                                
                                Divider()
                            }
                            
                            Spacer().frame(height: 20)
                            
                            Group{
                                IncidenceRateListModel(data: helper.inspectionResult)
                            }
                            
                            Spacer().frame(height: 20)
                            
                            Group{
                                VStack(alignment: .leading){
                                    HStack{
                                        Image(systemName: "arrow.triangle.branch")
                                            .font(.caption)
                                            .foregroundStyle(Color.gray)
                                        
                                        Text("Recommended Follow-up Actions")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(Color.gray)
                                        
                                        Spacer()
                                    }
                                    
                                    Spacer().frame(height: 20)
                                    
                                    switch helper.inspectionResult.type {
                                    case .NORMAL:
                                        Text("No symptoms of dementia or mild cognitive impairment (MCI) were identified in the user.\nMaintain proper lifestyle habits to prevent dementia.")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(Color.txt)
                                        
                                    case .MCI:
                                        Text("Symptoms of mild cognitive impairment (MCI) have been identified in the user.\nImprove lifestyle habits to prevent progression to dementia, and consider measures such as brain training for dementia prevention.")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(Color.txt)
                                        
                                    case .DEMENTIA:
                                        Text("Symptoms of dementia have been identified in the user.\nVisit a medical institution immediately for further examination and medical intervention.")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(Color.txt)
                                    }
                                }.padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(Color.background)
                                            .shadow(color: colorScheme == .light ? Color.black.opacity(0.2) : Color.btnStart.opacity(0.2), radius: 10, x: 10, y: 10)
                                            .shadow(color: colorScheme == .light ? Color.white.opacity(0.7) : Color.btnEnd.opacity(0.2), radius: 10, x: -5, y: -5)
                                    )
                            }
                            
                            Spacer().frame(height: 20)
                            
                            Group{
                                MMSEInspectionResultView(MMSEResult: helper.scores, MMSEData: helper.mmseData)
                                
                                Spacer().frame(height: 20)
                                
                                HStack{
                                    Spacer()
                                    
                                    Button(action: {
                                        showMMSEResult = true
                                    }){
                                        HStack{
                                            Text("View Cognitive Function Test Results")
                                                .font(.caption)
                                                .foregroundStyle(Color.txt)
                                            
                                            Image(systemName: "chevron.right")
                                                .font(.caption)
                                                .foregroundStyle(Color.txt)
                                        }
                                    }
                                }
                                
                                Spacer().frame(height: 20)
                                
                                LifeLogIncidenceRateListModel(data: helper.lifeLogData, inspectionType: .WALK)
                                
                                Spacer().frame(height: 20)
                                
                                LifeLogIncidenceRateListModel(data: helper.sleepData, inspectionType: .SLEEP)
                            }
                            
                            Spacer().frame(height: 20)
                            
                            Group{
                                VStack(alignment: .leading){
                                    HStack{
                                        Image(systemName: "lightbulb.max.fill")
                                            .font(.caption)
                                            .foregroundStyle(Color.gray)
                                        
                                        Text("About This Condition")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(Color.gray)
                                        
                                        Spacer()
                                    }
                                    
                                    Spacer().frame(height: 20)
                                    
                                    switch helper.inspectionResult.type {
                                    case .NORMAL:
                                        Text("Normal indicates that there are no issues with the user's cognitive function, brain function, or lifestyle habits.\nMild cognitive impairment (MCI) is a condition where cognitive function, especially memory, is lower than the same age group, but the ability to perform daily activities is preserved, meaning it is not yet dementia.\nDementia is a condition of multiple cognitive impairments, with decreased memory being the most important symptom, but also including impaired speech or understanding, sensory impairments in time and space, personality changes, and decreased ability to perform daily or social activities.")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(Color.txt)
                                        
                                    case .MCI:
                                        Text("Mild cognitive impairment (MCI) is a condition where cognitive function, especially memory, is lower than the same age group, but the ability to perform daily activities is preserved, meaning it is not yet dementia.\nIt is considered an intermediate stage between dementia and normal, and is identified as the highest risk group for progression to dementia. It is also a clinically important stage as it is the earliest stage to detect Alzheimer's disease and maximize treatment effects.")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(Color.txt)
                                        
                                    case .DEMENTIA:
                                        Text("Dementia is a condition of multiple cognitive impairments, with decreased memory being the most important symptom, but also including impaired speech or understanding, sensory impairments in time and space, personality changes, and decreased ability to perform daily or social activities.")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(Color.txt)
                                    }
                                }.padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(Color.background)
                                            .shadow(color: colorScheme == .light ? Color.black.opacity(0.2) : Color.btnStart.opacity(0.2), radius: 10, x: 10, y: 10)
                                            .shadow(color: colorScheme == .light ? Color.white.opacity(0.7) : Color.btnEnd.opacity(0.2), radius: 10, x: -5, y: -5)
                                    )
                                
                                Spacer().frame(height: 20)
                                
                                Image(systemName: "person.badge.shield.checkmark.fill")
                                    .foregroundStyle(Color.accent)
                                
                                Text("Dementia Checker does not guarantee the accuracy of diagnosis results.\nIf dementia is suspected, visit a medical institution for consultation with experts and medical intervention.\nUsers cannot benefit from Dementia Checker for medical treatment.")
                                    .font(.caption)
                                    .foregroundStyle(Color.gray)
                                    .multilineTextAlignment(.center)
                            }
                        }.padding(20)
                        
                            .sheet(isPresented: $showMMSEResult, content: {
                                MMSEResultsView(MMSEResult: helper.scores, MMSEData: helper.mmseData)
                            })
                            .onChange(of: self.selectedIndex){ _, _ in
                                showView = false
                                
                                helper.getResult(id: docList[selectedIndex], completion: { inspectionResult in
                                    guard let inspectionResult = inspectionResult else{return}
                                    
                                    showView = inspectionResult
                                })
                            }
                    }
                    
                }
            }
        }
        .navigationTitle(Text("History"))
        .onAppear{
            helper.getDataList(){ result in
                guard let result = result else{return}
                
                self.docList = result
                
                if !result.isEmpty{
                    helper.getResult(id: docList[selectedIndex]){ _ in                        
                        showView = true
                    }
                } else{
                    showView = true
                }
            }
        }
    }
}

#Preview {
    HistoryView()
        .environmentObject(UserManagement())
}
