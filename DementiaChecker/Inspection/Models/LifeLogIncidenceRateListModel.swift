//
//  LifeLogIncidenceRateListModel.swift
//  DementiaChecker
//
//  Created by Changjin Ha on 2/12/24.
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
                
                Text(inspectionType == .WALK ? "Life Log Analysis Result" : "Sleep Pattern Analysis Result")
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
                    
                    Text("Normal")
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.green)
                    
                    Spacer()
                }
                
                Spacer().frame(height: 10)

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
                
                Spacer().frame(height: 10)

                Text(inspectionType == .WALK ? "User's activity logs and life log analysis data are close to normal." : "User's sleep patterns are close to normal.")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.txt)
                
            case .MCI:
                HStack{
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundStyle(Color.orange)
                    
                    Text("Caution Needed")
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.orange)
                    
                    Spacer()
                }
                
                Spacer().frame(height: 10)

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
                
                Spacer().frame(height: 10)

                Text(inspectionType == .WALK ? "User's activity logs and life log data resemble patterns of mild cognitive impairment patients.\nIncrease daily activity and improve lifestyle patterns immediately." : "User's sleep analysis data resembles patterns of mild cognitive impairment patients.\nClear your mind through meditation and go to bed early to improve sleep quality immediately.")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.txt)
                
            case .DEMENTIA:
                HStack{
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundStyle(Color.red)
                    
                    Text("Danger")
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.red)
                    
                    Spacer()
                }
                
                Spacer().frame(height: 10)

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
                
                Spacer().frame(height: 10)

                Text(inspectionType == .WALK ? "User's activity logs and life log data resemble patterns of dementia patients.\nIncrease activity and improve breathing methods to prevent progression into dementia immediately." : "User's sleep analysis data resembles patterns of dementia patients.\nClear your mind through meditation and go to bed early to improve sleep quality immediately.")
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

