//
//  InspectionResultsView.swift
//  DementiaChecker
//
//  Created by Changjin Ha on 2/11/24.
//

import SwiftUI

struct InspectionResultsView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    @State private var showMMSEResult = false
    
    let data: InspectionResultDataModel
    let mmseData: ClassInspectionResultDataModel
    let sleepData: ClassInspectionResultDataModel
    let lifeLogData: ClassInspectionResultDataModel
    let MMSEResult: [Int]
    let MMSEAnswer: [String]
    let answerList: [String]
    
    var body: some View {
        ZStack{
            Color.background.ignoresSafeArea(.all, edges: [.top, .bottom])
            
            ScrollView{
                VStack{
                    switch data.type{
                    case .NORMAL:
                        HStack{
                            Image(systemName: "checkmark.circle.fill")
                                .font(.largeTitle)
                                .foregroundStyle(Color.green)
                            
                            Text("No issues found from user data by Dementia Checker.")
                                .foregroundStyle(Color.txt)
                                .fontWeight(.semibold)
                            
                            Spacer()
                        }
                        
                        Spacer().frame(height: 10)
                        
                        HStack{
                            Text("No symptoms of mild cognitive impairment (MCI) or dementia were detected in the user.\nThe user is presumed to be in a normal state.")
                                .font(.caption)
                                .foregroundStyle(Color.gray)
                            
                            Spacer()
                        }

                    case .MCI:
                        HStack{
                            Image(systemName: "exclamationmark.circle.fill")
                                .font(.largeTitle)
                                .foregroundStyle(Color.orange)
                            
                            Text("Dementia Checker has detected symptoms of mild cognitive impairment (MCI) in the user.")
                                .foregroundStyle(Color.txt)
                                .fontWeight(.semibold)
                            
                            Spacer()
                        }
                        
                        Spacer().frame(height: 10)
                        
                        HStack{
                            Text("Symptoms of mild cognitive impairment (MCI) have been detected in the user.\nImprove lifestyle habits to prevent progression to dementia.")
                                .font(.caption)
                                .foregroundStyle(Color.gray)
                            
                            Spacer()
                        }

                        
                    case .DEMENTIA:
                        HStack{
                            Image(systemName: "exclamationmark.circle.fill")
                                .font(.largeTitle)
                                .foregroundStyle(Color.red)
                            
                            Text("Dementia Checker has detected symptoms of dementia in the user.")
                                .foregroundStyle(Color.txt)
                                .fontWeight(.semibold)
                            
                            Spacer()
                        }
                        
                        Spacer().frame(height: 10)
                        
                        HStack{
                            Text("Symptoms of dementia have been detected in the user.\nSeek immediate medical attention and request a comprehensive examination.")
                                .font(.caption)
                                .foregroundStyle(Color.gray)
                            
                            Spacer()
                        }

                        Divider()
                    }
                    
                    Spacer().frame(height: 20)
                    
                    Group{
                        IncidenceRateListModel(data: data)
                    }
                    
                    Spacer().frame(height: 20)

                    Group{
                        VStack(alignment: .leading){
                            HStack{
                                Image(systemName: "arrow.triangle.branch")
                                    .font(.caption)
                                    .foregroundStyle(Color.gray)
                                
                                Text("Recommended Actions")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.gray)
                                
                                Spacer()
                            }
                            
                            Spacer().frame(height: 20)
                            
                            switch data.type {
                            case .NORMAL:
                                Text("No symptoms of dementia or mild cognitive impairment (MCI) were detected in the user.\nMaintain proper lifestyle habits to prevent dementia.")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.txt)
                                
                            case .MCI:
                                Text("Symptoms of mild cognitive impairment (MCI) have been detected in the user.\nTo prevent progression to dementia, improve lifestyle habits and consider measures such as brain training for dementia prevention.")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.txt)
                                
                            case .DEMENTIA:
                                Text("Symptoms of dementia have been detected in the user.\nSeek immediate medical attention, undergo a comprehensive examination, and receive medical treatment.")
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
                        MMSEInspectionResultView(MMSEResult: MMSEResult, MMSEData: mmseData)
                        
                        Spacer().frame(height: 20)
                        
                        HStack{
                            Spacer()
                            
                            Button(action: {
                                showMMSEResult = true
                            }){
                                HStack{
                                    Text("View Cognitive Test Results")
                                        .font(.caption)
                                        .foregroundStyle(Color.txt)
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundStyle(Color.txt)
                                }
                            }
                        }
                        
                        Spacer().frame(height: 20)

                        LifeLogIncidenceRateListModel(data: lifeLogData, inspectionType: .WALK)
                        
                        Spacer().frame(height: 20)

                        LifeLogIncidenceRateListModel(data: sleepData, inspectionType: .SLEEP)
                    }
                    
                    Spacer().frame(height: 20)

                    Group{
                        VStack(alignment: .leading){
                            HStack{
                                Image(systemName: "lightbulb.max.fill")
                                    .font(.caption)
                                    .foregroundStyle(Color.gray)
                                
                                Text("About the Condition")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.gray)
                                
                                Spacer()
                            }
                            
                            Spacer().frame(height: 20)
                            
                            switch data.type {
                            case .NORMAL:
                                Text("Normal indicates that there are no issues with the user's cognitive function, brain function, or lifestyle habits.\nMild cognitive impairment (MCI) refers to a state where cognitive function, especially memory, is impaired compared to the same age group, but the ability to perform daily activities is preserved, indicating that it is not yet dementia.\nDementia is a condition of multiple cognitive function impairments, with impaired memory being the most important symptom. However, in addition to this, there are impairments in speaking or understanding, sensory impairments in time and space, personality changes, and decreased ability to perform calculations, leading to difficulties in daily life and social activities.")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.txt)
                                
                            case .MCI:
                                Text("Mild cognitive impairment (MCI) refers to a state where cognitive function, especially memory, is impaired compared to the same age group, but the ability to perform daily activities is preserved, indicating that it is not yet dementia.\nThis state is considered a high-risk group for progression to dementia. It is also the stage where Alzheimer's disease can be detected earliest and is clinically important because it can maximize treatment effects.")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.txt)
                                
                            case .DEMENTIA:
                                Text("Dementia is a condition of multiple cognitive function impairments, with impaired memory being the most important symptom. However, in addition to this, there are impairments in speaking or understanding, sensory impairments in time and space, personality changes, and decreased ability to perform calculations, leading to difficulties in daily life and social activities.")
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

                        Button(action: { self.dismiss() }){
                            HStack{
                                Spacer()
                                
                                Text("Close")
                                    .foregroundStyle(Color.txt)
                                
                                Spacer()
                            }
                        }.buttonStyle(NewMorphButtonStyle(foreground: Color.background, cornerRadius: 15))
                        
                        Spacer().frame(height: 20)

                        Button(action: {}){
                            HStack{
                                Image(systemName: "square.and.arrow.up")
                                
                                Text("Share Results")
                            }
                        }
                        
                        Spacer().frame(height: 20)
                        
                        Image(systemName: "person.badge.shield.checkmark.fill")
                            .foregroundStyle(Color.accent)
                        
                        Text("Dementia Checker does not guarantee the accuracy of diagnostic results.\nIf dementia is suspected, visit a medical institution for consultation with experts and medical treatment.\nUsers cannot benefit medically from Dementia Checker.")
                            .font(.caption)
                            .foregroundStyle(Color.gray)
                            .multilineTextAlignment(.center)
                    }
                }.padding(20)
                    .sheet(isPresented: $showMMSEResult, content: {
                        MMSEResultsView(MMSEResult: MMSEResult, MMSEData: mmseData)
                    })
            }
        }
    }
}

#Preview {
    InspectionResultsView(
        data: InspectionResultDataModel(type: .NORMAL, percentageOfNormal: 80, percentageOfMCI: 10, percentageOfDementia: 10),
        mmseData: ClassInspectionResultDataModel(max: .NORMAL, percentageOfNormal: 80, percentageOfMCI: 10, percentageOfDementia: 10),
        sleepData: ClassInspectionResultDataModel(max: .NORMAL, percentageOfNormal: 80, percentageOfMCI: 10, percentageOfDementia: 10),
        lifeLogData: ClassInspectionResultDataModel(max: .NORMAL, percentageOfNormal: 80, percentageOfMCI: 10, percentageOfDementia: 10),
        MMSEResult: [0],
        MMSEAnswer: ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""],
        answerList: ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
    )
}

#Preview {
    InspectionResultsView(data: InspectionResultDataModel(type: .MCI, percentageOfNormal: 10, percentageOfMCI: 80, percentageOfDementia: 10),
                          mmseData: ClassInspectionResultDataModel(max: .MCI, percentageOfNormal: 10, percentageOfMCI: 80, percentageOfDementia: 10),
                          sleepData: ClassInspectionResultDataModel(max: .MCI, percentageOfNormal: 10, percentageOfMCI: 80, percentageOfDementia: 10),
                          lifeLogData: ClassInspectionResultDataModel(max: .MCI, percentageOfNormal: 10, percentageOfMCI: 80, percentageOfDementia: 10),
                          MMSEResult: [0],
                          MMSEAnswer: ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""],
                          answerList: ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
    )
}

#Preview {
    InspectionResultsView(data: InspectionResultDataModel(type: .DEMENTIA, percentageOfNormal: 10, percentageOfMCI: 10, percentageOfDementia: 80),
                          mmseData: ClassInspectionResultDataModel(max: .DEMENTIA, percentageOfNormal: 10, percentageOfMCI: 10, percentageOfDementia: 80),
                          sleepData: ClassInspectionResultDataModel(max: .DEMENTIA, percentageOfNormal: 10, percentageOfMCI: 10, percentageOfDementia: 80),
                          lifeLogData: ClassInspectionResultDataModel(max: .DEMENTIA, percentageOfNormal: 10, percentageOfMCI: 10, percentageOfDementia: 80),
                          MMSEResult: [0],
                          MMSEAnswer: ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""],
                          answerList: ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
    )
}
