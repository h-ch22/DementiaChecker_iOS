//
//  DementiaImprovementTypeSelectionView.swift
//  DementiaChecker
//
//  Created by 하창진 on 2/11/24.
//

import SwiftUI

struct DementiaImprovementTypeSelectionView: View {
    var body: some View {
        ZStack{
            Color.background.ignoresSafeArea(.all, edges: [.top, .bottom])
            
            VStack{
                Text("치매 개선 프로세스를 시작합니다.\n프로세스의 종류를 선택하고 진행하십시오.")
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.gray)
                
                Spacer().frame(height: 20)

                Group{
                    NavigationLink(destination: EmptyView()){
                        HStack{
                            Image(systemName: "heart.fill")
                                .foregroundStyle(Color.txt)
                            
                            Spacer().frame(width: 10)
                            
                            VStack(alignment: .leading){
                                HStack{
                                    Text("명상")
                                        .fontWeight(.semibold)
                                        .foregroundStyle(Color.txt)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "clock.fill")
                                        .font(.caption)
                                        .foregroundStyle(Color.accentColor)
                                    
                                    Text("소요시간: 약 3분")
                                        .font(.caption)
                                        .foregroundStyle(Color.accentColor)
                                }

                                
                                Text("명상을 통해 생각을 정리하고 인지 능력과 집중력을 강화합니다.")
                                    .font(.caption)
                                    .foregroundStyle(Color.gray)
                            }
                            
                            Spacer()
                        }
                    }.buttonStyle(NewMorphButtonStyle(foreground: Color.background, cornerRadius: 15))
                    
                    Spacer().frame(height: 20)
                    
                    NavigationLink(destination: EmptyView()){
                        HStack{
                            Image(systemName: "brain.fill")
                                .foregroundStyle(Color.txt)
                            
                            Spacer().frame(width: 10)
                            
                            VStack(alignment: .leading){
                                HStack{
                                    Text("기억력 강화")
                                        .fontWeight(.semibold)
                                        .foregroundStyle(Color.txt)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "clock.fill")
                                        .font(.caption)
                                        .foregroundStyle(Color.accentColor)
                                    
                                    Text("소요시간: 약 5분")
                                        .font(.caption)
                                        .foregroundStyle(Color.accentColor)
                                }

                                
                                Text("기억력 강화 훈련을 통해 치매로 인해 손상된 기억력을 강화합니다.")
                                    .font(.caption)
                                    .foregroundStyle(Color.gray)
                            }
                            
                            Spacer()
                        }
                    }.buttonStyle(NewMorphButtonStyle(foreground: Color.background, cornerRadius: 15))
                    
                    Spacer().frame(height: 20)
                    
                    NavigationLink(destination: AcrosticPoemView()){
                        HStack{
                            Image(systemName: "text.word.spacing")
                                .foregroundStyle(Color.txt)
                            
                            Spacer().frame(width: 10)
                            
                            VStack(alignment: .leading){
                                HStack{
                                    Text("삼행시")
                                        .fontWeight(.semibold)
                                        .foregroundStyle(Color.txt)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "clock.fill")
                                        .font(.caption)
                                        .foregroundStyle(Color.accentColor)
                                    
                                    Text("소요시간: 약 10분")
                                        .font(.caption)
                                        .foregroundStyle(Color.accentColor)
                                }

                                
                                Text("삼행시를 통해 언어능력과 기억력, 집행 기능을 강화합니다.")
                                    .font(.caption)
                                    .foregroundStyle(Color.gray)
                            }
                            
                            Spacer()
                        }
                    }.buttonStyle(NewMorphButtonStyle(foreground: Color.background, cornerRadius: 15))
                    
                    Spacer().frame(height: 20)
                    
                    NavigationLink(destination: PuzzleView()){
                        HStack{
                            Image(systemName: "puzzlepiece.extension.fill")
                                .foregroundStyle(Color.txt)
                            
                            Spacer().frame(width: 10)
                            
                            VStack(alignment: .leading){
                                HStack{
                                    Text("퍼즐")
                                        .fontWeight(.semibold)
                                        .foregroundStyle(Color.txt)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "clock.fill")
                                        .font(.caption)
                                        .foregroundStyle(Color.accentColor)
                                    
                                    Text("소요시간: 약 30분")
                                        .font(.caption)
                                        .foregroundStyle(Color.accentColor)
                                }

                                
                                Text("퍼즐 맞추기 게임을 통해 시공간능력, 소근육운동기능, 주의집중력 및 집행기능을 강화합니다.")
                                    .font(.caption)
                                    .foregroundStyle(Color.gray)
                            }
                            
                            Spacer()
                        }
                    }.buttonStyle(NewMorphButtonStyle(foreground: Color.background, cornerRadius: 15))
                    
                    Spacer()
                }
            }.padding(20)
                .navigationTitle(Text("프로세스 종류 선택"))
        }
    }
}

#Preview {
    DementiaImprovementTypeSelectionView()
}
