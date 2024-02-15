//
//  HistoryView.swift
//  DementiaChecker
//
//  Created by 하창진 on 1/28/24.
//

import SwiftUI

struct HistoryView: View {
    @StateObject private var helper = InspectionHelper()
    @State private var showView = false
    @State private var docList = [String]()
    @State private var selectedIndex = 0
    @State private var showMMSEResult = false

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
                        
                        Text("치매 진단을 진행하면 이 페이지에서 진단 결과를 다시 확인할 수 있습니다.")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color.gray)
                        
                        Spacer()
                    }.padding(20)
                } else{
                    ScrollView{
                        VStack{
                            Picker("검사 날짜 선택", selection: $selectedIndex){
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
                                    
                                    Text("Dementia Checker에서 사용자의 데이터로부터 문제를 찾지 못했습니다.")
                                        .foregroundStyle(Color.txt)
                                        .fontWeight(.semibold)
                                    
                                    Spacer()
                                }
                                
                                Spacer().frame(height: 10)
                                
                                HStack{
                                    Text("사용자에게 경도인지장애 또는 치매의 증상이 확인되지 않습니다.\n사용자는 정상적인 상태로 추정됩니다.")
                                        .font(.caption)
                                        .foregroundStyle(Color.gray)
                                    
                                    Spacer()
                                }

                            case .MCI:
                                HStack{
                                    Image(systemName: "exclamationmark.circle.fill")
                                        .font(.largeTitle)
                                        .foregroundStyle(Color.orange)
                                    
                                    Text("Dementia Checker에서 사용자에게 경도인지장애의 증상이 있음을 확인하였습니다.")
                                        .foregroundStyle(Color.txt)
                                        .fontWeight(.semibold)
                                    
                                    Spacer()
                                }
                                
                                Spacer().frame(height: 10)
                                
                                HStack{
                                    Text("사용자에게 경도인지장애의 증상이 확인되었습니다.\n치매로 진행되지 않도록 생활 습관을 개선하십시오.")
                                        .font(.caption)
                                        .foregroundStyle(Color.gray)
                                    
                                    Spacer()
                                }

                                
                            case .DEMENTIA:
                                HStack{
                                    Image(systemName: "exclamationmark.circle.fill")
                                        .font(.largeTitle)
                                        .foregroundStyle(Color.red)
                                    
                                    Text("Dementia Checker에서 사용자의 데이터로부터 치매 증상이 있음을 확인하였습니다.")
                                        .foregroundStyle(Color.txt)
                                        .fontWeight(.semibold)
                                    
                                    Spacer()
                                }
                                
                                Spacer().frame(height: 10)
                                
                                HStack{
                                    Text("사용자에게 치매 증상이 확인되었습니다.\n즉시 의료기관에 방문하여 정밀 검사를 의뢰하십시오.")
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
                                        
                                        Text("권장되는 후속조치")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(Color.gray)
                                        
                                        Spacer()
                                    }
                                    
                                    Spacer().frame(height: 20)
                                    
                                    switch helper.inspectionResult.type {
                                    case .NORMAL:
                                        Text("사용자에게는 치매 또는 경도인지장애의 증상이 확인되지 않습니다.\n치매를 예방하기 위해 올바른 생활습관을 유지하십시오.")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(Color.txt)
                                        
                                    case .MCI:
                                        Text("사용자에게 경도인지장애의 증상이 확인되었습니다.\n치매로 진행되지 않도록 생활습관을 개선하고, 치매 예방을 위한 두뇌 훈련 등의 조치가 필요할 수 있습니다.")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(Color.txt)
                                        
                                    case .DEMENTIA:
                                        Text("사용자에게 치매의 증상이 확인되었습니다.\n즉시 의료기관에 내원하여 정밀검사를 의뢰하고, 의학적 조치를 받으십시오.")
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
                                            Text("인지기능검사 결과 확인")
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
                                        
                                        Text("이 질환에 대하여")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(Color.gray)
                                        
                                        Spacer()
                                    }
                                    
                                    Spacer().frame(height: 20)
                                    
                                    switch helper.inspectionResult.type {
                                    case .NORMAL:
                                        Text("정상은 사용자의 인지기능을 포함한 뇌 기능, 생활습관에 문제가 없음을 의미합니다.\n경도인지장애는 동일 연령대에 비해 인지기능, 특히 기억력이 떨어져 있는 상태이며, 일상생활을 수행하는 능력은 보존되어 있어 아직은 치매가 아닌 상태를 의미합니다.\n치매는 다발성 인지기능의 장애로 기억력이 떨어진 것이 가장 중요한 증상이지만 이것 뿐 아니라, 말을 하거나 이해하는 능력이 떨어지고, 시간과 공간에 대한 감각장애, 성격변화가 생기고, 계산능력이 떨어져 일상 생활이나 사회생활을 하는데 지장을 일으키는 상태를 의미합니다.")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(Color.txt)
                                        
                                    case .MCI:
                                        Text("경도인지장애는 동일 연령대에 비해 인지기능, 특히 기억력이 떨어져 있는 상태이며, 일상생활을 수행하는 능력은 보존되어 있어 아직은 치매가 아닌 상태를 의미합니다.\n치매와 정상의 중간 단계로 치매로 진행할 수 있는 고위험군으로 지목됩니다. 또한 이 상태는 알츠하이머병을 가장 이른 시기에 발견할 수 있는 단계이며 치료효과를 극대화시킬 수 있다는 점에서 임상적으로 중요한 단계입니다.")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(Color.txt)
                                        
                                    case .DEMENTIA:
                                        Text("치매는 다발성 인지기능의 장애로 기억력이 떨어진 것이 가장 중요한 증상이지만 이것 뿐 아니라, 말을 하거나 이해하는 능력이 떨어지고, 시간과 공간에 대한 감각장애, 성격변화가 생기고, 계산능력이 떨어져 일상 생활이나 사회생활을 하는데 지장을 일으키는 질환입니다.")
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

                                Button(action: {}){
                                    HStack{
                                        Image(systemName: "square.and.arrow.up")
                                        
                                        Text("검사 결과 공유")
                                    }
                                }
                                
                                Spacer().frame(height: 20)
                                
                                Image(systemName: "person.badge.shield.checkmark.fill")
                                    .foregroundStyle(Color.accent)
                                
                                Text("Dementia Checker는 진단 결과의 정확성을 보증하지 않습니다.\n치매가 의심되는 경우 의료기관에 방문해 전문가와 상담을 통해 의학적 조치를 받으십시오.\n사용자는 Dementia Checker를 통해 치료상의 이익을 얻을 수 없습니다.")
                                    .font(.caption)
                                    .foregroundStyle(Color.gray)
                                    .multilineTextAlignment(.center)
                            }
                        }.padding(20)

                            .sheet(isPresented: $showMMSEResult, content: {
                                MMSEResultsView(MMSEResult: helper.scores, MMSEData: helper.mmseData)
                            })
                            .onChange(of: self.selectedIndex){ _ in
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
        .navigationTitle(Text("검사 기록"))
        .onAppear{
            helper.getDataList(){ result in
                guard let result = result else{return}
                
                self.docList = result
                
                if !result.isEmpty{
                    helper.getResult(id: docList[selectedIndex]){ inspectionResult in
                        guard let inspectionResult = inspectionResult else{return}
                        
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
}
