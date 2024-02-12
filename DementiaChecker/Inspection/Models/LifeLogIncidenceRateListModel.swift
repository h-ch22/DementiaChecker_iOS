//
//  LifeLogIncidenceRateListModel.swift
//  DementiaChecker
//
//  Created by 하창진 on 2/12/24.
//

import SwiftUI

struct LifeLogIncidenceRateListModel: View {
    let data: ClassInspectionResultDataModel
    let inspectionType: InspectionTypeModel
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Image(systemName: inspectionType == .WALK ? "figure.run" : "bed.double.fill")
                    .font(.caption)
                    .foregroundStyle(Color.gray)
                
                Text(inspectionType == .WALK ? "라이프로그 분석 결과" : "수면 패턴 분석 결과")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.gray)
                
                Spacer()
            }
            
            Spacer().frame(height: 20)
            
            switch data.max {
            case .NORMAL:
                HStack{
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(Color.green)
                    
                    Text("정상")
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.green)
                    
                    Spacer()
                }
                
                Spacer().frame(height: 10)

                HStack{
                    Text("정상 (Normal): __\(String(format: "%.2f", data.percentageOfNormal))%__")
                        .font(.caption)
                        .foregroundStyle(Color.txt)
                    
                    Spacer()
                    
                    BarGraph(value: data.percentageOfNormal / 100, color: Color.green)
                }
                
                HStack{
                    Text("경도인지장애 (MCI): __\(String(format: "%.2f", data.percentageOfMCI))%__")
                        .font(.caption)
                        .foregroundStyle(Color.txt)
                    
                    Spacer()
                    
                    BarGraph(value: data.percentageOfMCI / 100, color: Color.orange)
                }
                
                HStack{
                    Text("치매 (Dementia): __\(String(format: "%.2f", data.percentageOfDementia))%__")
                        .font(.caption)
                        .foregroundStyle(Color.txt)
                    
                    Spacer()
                    
                    BarGraph(value: data.percentageOfDementia / 100, color: Color.red)
                }
                
                Spacer().frame(height: 10)

                Text(inspectionType == .WALK ? "사용자의 활동 기록 등 라이프로그 분석 결과는 정상에 가깝습니다." : "사용자의 수면 패턴은 정상에 가깝습니다.")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.txt)
                
            case .MCI:
                HStack{
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundStyle(Color.orange)
                    
                    Text("주의 필요")
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.orange)
                    
                    Spacer()
                }
                
                Spacer().frame(height: 10)

                HStack{
                    Text("정상 (Normal): __\(String(format: "%.2f", data.percentageOfNormal))%__")
                        .font(.caption)
                        .foregroundStyle(Color.txt)
                    
                    Spacer()
                    
                    BarGraph(value: data.percentageOfNormal / 100, color: Color.green)
                }
                
                HStack{
                    Text("경도인지장애 (MCI): __\(String(format: "%.2f", data.percentageOfMCI))%__")
                        .font(.caption)
                        .foregroundStyle(Color.txt)
                    
                    Spacer()
                    
                    BarGraph(value: data.percentageOfMCI / 100, color: Color.orange)
                }
                
                HStack{
                    Text("치매 (Dementia): __\(String(format: "%.2f", data.percentageOfDementia))%__")
                        .font(.caption)
                        .foregroundStyle(Color.txt)
                    
                    Spacer()
                    
                    BarGraph(value: data.percentageOfDementia / 100, color: Color.red)
                }
                
                Spacer().frame(height: 10)

                Text(inspectionType == .WALK ? "사용자의 활동 기록 등 라이프로그 데이터는 경도인지장애 환자의 패턴에 가깝습니다.\n평소 활동량을 늘려 생활패턴을 개선하십시오." : "사용자의 수면 분석 데이터는 경도인지장애 환자의 패턴에 가깝습니다.\n명상 등을 통해 생각을 정리하고, 일찍 잠자리에 드는 등의 방법을 통해 깊은 수면을 늘려 수면의 질을 개선하십시오.")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.txt)
                
            case .DEMENTIA:
                HStack{
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundStyle(Color.red)
                    
                    Text("위험")
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.red)
                    
                    Spacer()
                }
                
                Spacer().frame(height: 10)

                HStack{
                    Text("정상 (Normal): __\(String(format: "%.2f", data.percentageOfNormal))%__")
                        .font(.caption)
                        .foregroundStyle(Color.txt)
                    
                    Spacer()
                    
                    BarGraph(value: data.percentageOfNormal / 100, color: Color.green)
                }
                
                HStack{
                    Text("경도인지장애 (MCI): __\(String(format: "%.2f", data.percentageOfMCI))%__")
                        .font(.caption)
                        .foregroundStyle(Color.txt)
                    
                    Spacer()
                    
                    BarGraph(value: data.percentageOfMCI / 100, color: Color.orange)
                }
                
                HStack{
                    Text("치매 (Dementia): __\(String(format: "%.2f", data.percentageOfDementia))%__")
                        .font(.caption)
                        .foregroundStyle(Color.txt)
                    
                    Spacer()
                    
                    BarGraph(value: data.percentageOfDementia / 100, color: Color.red)
                }
                
                Spacer().frame(height: 10)

                Text(inspectionType == .WALK ? "사용자의 활동 기록 등 라이프로그 데이터는 치매 환자의 패턴에 가깝습니다.\n활동량을 늘리고, 복식호흡 등 호흡 방법을 개선하여 치매로 발전하지 않도록 즉시 생활 패턴을 개선하십시오." : "사용자의 수면 분석 데이터는 치매 환자의 패턴에 가깝습니다.\n명상 등을 통해 생각을 정리하고, 일찍 잠자리에 드는 등의 방법을 통해 깊은 수면을 늘려 즉시 수면의 질을 개선하십시오.")
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
}
