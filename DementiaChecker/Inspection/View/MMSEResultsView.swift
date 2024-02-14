//
//  MMSEResultsView.swift
//  DementiaChecker
//
//  Created by 하창진 on 2/13/24.
//

import SwiftUI

struct MMSEResultsView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    @State private var scoreIndexes = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29]
    @State private var titles = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11-1", "11-2", "11-3", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30"]
    @State private var scoreOfTime = 0
    @State private var scoreOfLocaion = 0
    @State private var scoreOfMemory = 0
    @State private var scoreOfCalculate = 0
    @State private var scoreOfremember = 0
    @State private var scoreOflanguage = 0
    
    let MMSEResult: [Int]
    let MMSEData: ClassInspectionResultDataModel
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.background.edgesIgnoringSafeArea(.all)
                
                ScrollView{
                    VStack{
                        MMSEInspectionResultView(MMSEResult: MMSEResult, MMSEData: MMSEData)
                        
                        Spacer().frame(height: 20)
                        
                        HStack{
                            Text("문항별 채점 결과")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.gray)
                            
                            Spacer()
                        }
                        
                        Spacer().frame(height: 10)
                        
                        ScrollView(.horizontal){
                            HStack{
                                MMSEResultListModel(title: "문항", isCorrect: "정답 여부")
                                
                                ForEach(0..<29, id: \.self){ index in
                                    MMSEResultListModel(title: titles[index], isCorrect: MMSEResult[scoreIndexes[index]] == 2 ? "정답":"오답")
                                }
                            }
                            
                        }
                        
                        Spacer().frame(height: 20)
                        
                        HStack{
                            Text("영역별 채점 결과")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.gray)
                            
                            Spacer()
                        }
                        
                        Spacer().frame(height: 10)
                        
                        HStack{
                            Image(systemName: "calendar.badge.clock")
                                .font(.caption)
                                .foregroundStyle(Color.gray)
                            
                            Text("지남력 (시간) 채점 결과")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.gray)
                            
                            Spacer()
                            
                            HStack(alignment: .lastTextBaseline){
                                Text(String(scoreOfTime))
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.accentColor)
                                
                                Text("/ 5")
                                    .font(.caption)
                                    .foregroundStyle(Color.gray)
                            }
                        }.padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.background)
                                    .shadow(color: colorScheme == .light ? Color.black.opacity(0.2) : Color.btnStart.opacity(0.2), radius: 10, x: 10, y: 10)
                                    .shadow(color: colorScheme == .light ? Color.white.opacity(0.7) : Color.btnEnd.opacity(0.2), radius: 10, x: -5, y: -5)
                            )
                        
                        Spacer().frame(height: 10)
                        
                        HStack{
                            Image(systemName: "location.fill")
                                .font(.caption)
                                .foregroundStyle(Color.gray)
                            
                            Text("지남력 (장소) 채점 결과")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.gray)
                            
                            Spacer()
                            
                            HStack(alignment: .lastTextBaseline){
                                Text(String(scoreOfLocaion))
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.accentColor)
                                
                                Text("/ 5")
                                    .font(.caption)
                                    .foregroundStyle(Color.gray)
                            }
                        }.padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.background)
                                    .shadow(color: colorScheme == .light ? Color.black.opacity(0.2) : Color.btnStart.opacity(0.2), radius: 10, x: 10, y: 10)
                                    .shadow(color: colorScheme == .light ? Color.white.opacity(0.7) : Color.btnEnd.opacity(0.2), radius: 10, x: -5, y: -5)
                            )
                        
                        Spacer().frame(height: 10)
                        
                        HStack{
                            Image(systemName: "brain.filled.head.profile")
                                .font(.caption)
                                .foregroundStyle(Color.gray)
                            
                            Text("기억등록 영역 채점 결과")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.gray)
                            
                            Spacer()
                            
                            HStack(alignment: .lastTextBaseline){
                                Text(String(scoreOfMemory))
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.accentColor)
                                
                                Text("/ 3")
                                    .font(.caption)
                                    .foregroundStyle(Color.gray)
                            }
                        }.padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.background)
                                    .shadow(color: colorScheme == .light ? Color.black.opacity(0.2) : Color.btnStart.opacity(0.2), radius: 10, x: 10, y: 10)
                                    .shadow(color: colorScheme == .light ? Color.white.opacity(0.7) : Color.btnEnd.opacity(0.2), radius: 10, x: -5, y: -5)
                            )
                        
                        Spacer().frame(height: 10)
                        
                        HStack{
                            Image(systemName: "plus")
                                .font(.caption)
                                .foregroundStyle(Color.gray)
                            
                            Text("주의집중 및 계산 영역 채점 결과")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.gray)
                            
                            Spacer()
                            
                            HStack(alignment: .lastTextBaseline){
                                Text(String(scoreOfCalculate))
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.accentColor)
                                
                                Text("/ 5")
                                    .font(.caption)
                                    .foregroundStyle(Color.gray)
                            }
                        }.padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.background)
                                    .shadow(color: colorScheme == .light ? Color.black.opacity(0.2) : Color.btnStart.opacity(0.2), radius: 10, x: 10, y: 10)
                                    .shadow(color: colorScheme == .light ? Color.white.opacity(0.7) : Color.btnEnd.opacity(0.2), radius: 10, x: -5, y: -5)
                            )
                        
                        Spacer().frame(height: 10)
                        
                        HStack{
                            Image(systemName: "ellipsis.bubble.fill")
                                .font(.caption)
                                .foregroundStyle(Color.gray)
                            
                            Text("기억회상 영역 채점 결과")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.gray)
                            
                            Spacer()
                            
                            HStack(alignment: .lastTextBaseline){
                                Text(String(scoreOfremember))
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.accentColor)
                                
                                Text("/ 3")
                                    .font(.caption)
                                    .foregroundStyle(Color.gray)
                            }
                        }.padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.background)
                                    .shadow(color: colorScheme == .light ? Color.black.opacity(0.2) : Color.btnStart.opacity(0.2), radius: 10, x: 10, y: 10)
                                    .shadow(color: colorScheme == .light ? Color.white.opacity(0.7) : Color.btnEnd.opacity(0.2), radius: 10, x: -5, y: -5)
                            )
                        
                        Spacer().frame(height: 10)
                        
                        HStack{
                            Image(systemName: "t.bubble.fill")
                                .font(.caption)
                                .foregroundStyle(Color.gray)
                            
                            Text("언어 및 시공간 구성 영역 채점 결과")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.gray)
                            
                            Spacer()
                            
                            HStack(alignment: .lastTextBaseline){
                                Text(String(scoreOflanguage))
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.accentColor)
                                
                                Text("/ 9")
                                    .font(.caption)
                                    .foregroundStyle(Color.gray)
                            }
                        }.padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.background)
                                    .shadow(color: colorScheme == .light ? Color.black.opacity(0.2) : Color.btnStart.opacity(0.2), radius: 10, x: 10, y: 10)
                                    .shadow(color: colorScheme == .light ? Color.white.opacity(0.7) : Color.btnEnd.opacity(0.2), radius: 10, x: -5, y: -5)
                            )
                        
                    }.padding(20)
                        .toolbar{
                            ToolbarItem(placement: .topBarLeading, content: {
                                Button("닫기"){
                                    dismiss()
                                }
                            })
                        }
                        .onAppear{
                            for var i in 0...4{
                                if MMSEResult[i] == 2{
                                    scoreOfTime += 1
                                }
                            }
                            
                            for var i in 5...9{
                                if MMSEResult[i] == 2{
                                    scoreOfLocaion += 1
                                }
                            }
                            
                            for var i in 10...12{
                                if MMSEResult[i] == 2{
                                    scoreOfMemory += 1
                                }
                            }
                            
                            for var i in 13...17{
                                if MMSEResult[i] == 2{
                                    scoreOfCalculate += 1
                                }
                            }
                            
                            for var i in 18...20{
                                if MMSEResult[i] == 2{
                                    scoreOfremember += 1
                                }
                            }
                            
                            for var i in 21...29{
                                if MMSEResult[i] == 2{
                                    scoreOflanguage += 1
                                }
                            }
                        }
                        .navigationTitle(Text("인지기능검사 결과"))
                }
            }
        }
    }
}
