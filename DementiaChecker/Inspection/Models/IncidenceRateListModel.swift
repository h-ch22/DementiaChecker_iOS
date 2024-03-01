//
//  BarChartListModel.swift
//  DementiaChecker
//
//  Created by Changjin Ha on 2/12/24.
//

import SwiftUI

struct IncidenceRateListModel: View {
    @Environment(\.colorScheme) var colorScheme
    
    let data: InspectionResultDataModel
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Image(systemName: "chart.pie.fill")
                    .font(.caption)
                    .foregroundStyle(Color.gray)
                
                Text("Incidence Rates by Condition")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.gray)
                
                Spacer()
            }
            
            Spacer().frame(height: 20)
            
            HStack{
                Text("Normal: __\(String(format: "%.2f", data.percentageOfNormal))%__")
                    .font(.caption)
                    .foregroundStyle(Color.txt)
                
                Spacer()
                
                BarGraph(value: data.percentageOfNormal / 100, color: Color.green)
            }
            
            HStack{
                Text("Mild Cognitive Impairment (MCI): __\(String(format: "%.2f", data.percentageOfMCI))%__")
                    .font(.caption)
                    .foregroundStyle(Color.txt)
                
                Spacer()
                
                BarGraph(value: data.percentageOfMCI / 100, color: Color.orange)
            }
            
            HStack{
                Text("Dementia: __\(String(format: "%.2f", data.percentageOfDementia))%__")
                    .font(.caption)
                    .foregroundStyle(Color.txt)
                
                Spacer()
                
                BarGraph(value: data.percentageOfDementia / 100, color: Color.red)
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

#Preview {
    IncidenceRateListModel(data: InspectionResultDataModel(type: .NORMAL, percentageOfNormal: 80, percentageOfMCI: 10, percentageOfDementia: 10))
}

