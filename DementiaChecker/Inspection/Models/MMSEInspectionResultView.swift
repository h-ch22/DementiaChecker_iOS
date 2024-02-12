//
//  MMSEInspectionResultView.swift
//  DementiaChecker
//
//  Created by 하창진 on 2/12/24.
//

import SwiftUI

struct MMSEInspectionResultView: View {
    let MMSEResult: [Bool]
    let MMSEAnswer: [String]
    let MMSEData: ClassInspectionResultDataModel
    
    @State private var score = 0
    
    @Environment(\.colorScheme) var colorScheme
    
    private func getColor() -> Color{
        switch MMSEData.max {
        case .NORMAL:
            return Color.green
            
        case .MCI:
            return Color.orange
            
        case .DEMENTIA:
            return Color.red
        }
    }
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Image(systemName: "brain.fill")
                    .font(.caption)
                    .foregroundStyle(Color.gray)
                
                Text("인지기능검사 분석 결과")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.gray)
                
                Spacer()
            }
            
            Spacer().frame(height: 20)

            HStack(alignment: .lastTextBaseline){
                Text(String(score))
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(getColor())
                
                Text("/ 28")
                    .font(.caption)
                    .foregroundStyle(Color.gray)
            }
            
            Spacer().frame(height: 10)
            
            HStack{
                Text("정상 (Normal): __\(String(format: "%.2f", MMSEData.percentageOfNormal))%__")
                    .font(.caption)
                    .foregroundStyle(Color.txt)
                
                Spacer()
                
                BarGraph(value: MMSEData.percentageOfNormal / 100, color: Color.green)
            }
            
            HStack{
                Text("경도인지장애 (MCI): __\(String(format: "%.2f", MMSEData.percentageOfMCI))%__")
                    .font(.caption)
                    .foregroundStyle(Color.txt)
                
                Spacer()
                
                BarGraph(value: MMSEData.percentageOfMCI / 100, color: Color.orange)
            }
            
            HStack{
                Text("치매 (Dementia): __\(String(format: "%.2f", MMSEData.percentageOfDementia))%__")
                    .font(.caption)
                    .foregroundStyle(Color.txt)
                
                Spacer()
                
                BarGraph(value: MMSEData.percentageOfDementia / 100, color: Color.red)
            }
            
        }.padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.background)
                .shadow(color: colorScheme == .light ? Color.black.opacity(0.2) : Color.btnStart.opacity(0.2), radius: 10, x: 10, y: 10)
                .shadow(color: colorScheme == .light ? Color.white.opacity(0.7) : Color.btnEnd.opacity(0.2), radius: 10, x: -5, y: -5)
        )
        .onAppear{
            for result in MMSEResult{
                if result{
                    score += 1
                }
            }
        }
    }
}

#Preview {
    MMSEInspectionResultView(MMSEResult: [true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, false, false, false, true, true, true, true, true],
                             MMSEAnswer: ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""],
                             MMSEData: ClassInspectionResultDataModel(max: .NORMAL, percentageOfNormal: 80, percentageOfMCI: 10, percentageOfDementia: 10)
    )
}
