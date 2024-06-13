//
//  MMSEInspectionResultView.swift
//  DementiaChecker
//
//  Created by Changjin Ha on 2/12/24.
//

import SwiftUI

struct MMSEInspectionResultView: View {
    let MMSEResult: [Int64]
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
                
                Text("Cognitive Function Test Analysis Result")
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
                
                Text("/ 30")
                    .font(.caption)
                    .foregroundStyle(Color.gray)
            }
            
            Spacer().frame(height: 10)
            
            HStack{
                Text("Normal: __\(String(format: "%.2f", MMSEData.percentageOfNormal))%__")
                    .font(.caption)
                    .foregroundStyle(Color.txt)
                
                Spacer()
                
                BarGraph(value: MMSEData.percentageOfNormal / 100, color: Color.green)
            }
            
            HStack{
                Text("Mild Cognitive Impairment (MCI): __\(String(format: "%.2f", MMSEData.percentageOfMCI))%__")
                    .font(.caption)
                    .foregroundStyle(Color.txt)
                
                Spacer()
                
                BarGraph(value: MMSEData.percentageOfMCI / 100, color: Color.orange)
            }
            
            HStack{
                Text("Dementia: __\(String(format: "%.2f", MMSEData.percentageOfDementia))%__")
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
                if result == 2{
                    score += 1
                }
            }
        }
    }
}

#Preview {
    MMSEInspectionResultView(MMSEResult: [0],
                             MMSEData: ClassInspectionResultDataModel(max: .NORMAL, percentageOfNormal: 80, percentageOfMCI: 10, percentageOfDementia: 10)
    )
}
