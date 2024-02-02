//
//  onInspectionView.swift
//  DementiaChecker
//
//  Created by 하창진 on 1/31/24.
//

import SwiftUI

struct onInspectionView: View {
    @State private var currentInspectingType = InspectionTypeModel.MMSE
    @State private var errorType : InspectionTypeModel? = nil
    
    var body: some View {
        ZStack(alignment: .top){
            LinearGradient(colors: [Color.backgroundStart, Color.backgroundEnd], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea(.all, edges: [.top, .bottom])
            
            Rectangle()
                .frame(height: 200, alignment: .top)
                .background(.ultraThinMaterial)
                .ignoresSafeArea()
            
            VStack{
                Text(errorType == nil ? "검사 진행 중" : "검사 실패")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.white)
                
                Spacer().frame(height: 10)
                
                Text(errorType == nil ? "Dementia Checker에서 사용자의 인지 기능, 라이프스타일 데이터를 기반으로 치매 여부를 진단하고 있습니다.\n잠시 기다려 주십시오." : "Dementia Checker에서 사용자의 데이터를 기반으로 치매 여부를 진단하는 중 문제가 발셍했습니다.\n나중에 다시 시도하거나, 데이터를 확인하십시오.")
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.white)
            }.padding([.vertical], 20)
            
            VStack{
                Spacer()
                
                HStack{
                    if errorType != .MMSE{
                        switch currentInspectingType {
                        case .MMSE:
                            ProgressView()
                            
                        case .SLEEP, .WALK:
                            Image(systemName: "checkmark")
                                .foregroundStyle(Color.green)
                        }
                    } else if errorType == .MMSE{
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundStyle(Color.orange)
                    }
                    
                    Spacer().frame(width: 5)
                    
                    Text("인지 기능 검사")
                        .foregroundStyle(Color.white)
                        .fontWeight(currentInspectingType == .MMSE ? .semibold : .regular)
                        .font(currentInspectingType == .MMSE ? .headline : .caption)
                }
                
                Spacer().frame(height: 10)
                
                HStack{
                    if errorType != .SLEEP{
                        switch currentInspectingType {
                        case .MMSE:
                            EmptyView()
                            
                        case .SLEEP:
                            ProgressView()
                            
                        case .WALK:
                            Image(systemName: "checkmark")
                                .foregroundStyle(Color.green)
                        }
                    } else if errorType == .SLEEP{
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundStyle(Color.orange)
                    }

                    
                    Spacer().frame(width: 5)
                    
                    Text("수면 검사")
                        .foregroundStyle(Color.white)
                        .fontWeight(currentInspectingType == .SLEEP ? .semibold : .regular)
                        .font(currentInspectingType == .SLEEP ? .headline : .caption)
                }
                
                Spacer().frame(height: 10)
                
                HStack{
                    if errorType != .WALK{
                        switch currentInspectingType {
                        case .MMSE, .SLEEP:
                            EmptyView()
                            
                        case .WALK:
                            ProgressView()
                        }
                    } else if errorType == .WALK{
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundStyle(Color.orange)
                    }

                    Spacer().frame(width: 5)
                    
                    Text("활동 내역 검사")
                        .foregroundStyle(Color.white)
                        .fontWeight(currentInspectingType == .WALK ? .semibold : .regular)
                        .font(currentInspectingType == .WALK ? .headline : .caption)
                }
                
                Spacer()
                
                if errorType != nil{
                    Button(action: {}){
                        HStack{
                            Text("이전 화면으로")
                                .foregroundStyle(Color.white)
                            
                            Image(systemName: "chevron.right")
                                .foregroundStyle(Color.white)
                        }.padding(20)
                            .padding([.horizontal], 80)
                            .background(
                                LinearGradient(colors: [Color.gray.opacity(0.4), Color.gray.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(radius: 5)
                    }
                }
                
            }.padding(20)
            .animation(.easeInOut)
        }
    }
}

#Preview {
    onInspectionView()
}
