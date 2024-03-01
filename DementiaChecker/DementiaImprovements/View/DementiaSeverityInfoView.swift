//
//  DementiaSeverityInfoView.swift
//  DementiaChecker
//
//  Created by Changjin Ha on 11/2/24.
//

import SwiftUI

struct DementiaSeverityInfoView: View {
    @Environment(\.dismiss) var dismiss
    @State private var severityList = [
        DementiaSeverityDataModel(icon: "0.circle.fill", title: "Severity Level 0 (Very Mild)", description: "Frequently forgets the location of objects.\nHas difficulty remembering the names of people or objects.\nThis level of severity is not easily revealed even in detailed examinations.", IQLevel: "Approx. 85"),
        DementiaSeverityDataModel(icon: "1.circle.fill", title: "Severity Level 1 (Mild)", description: "Cannot recall the name of new people, the content of books, or words.\nMay misplace objects or have difficulty finding their way in unfamiliar places, and their work performance may deteriorate.\nThe user may not easily recognize their declining memory and may be found with a low probability in detailed examinations.", IQLevel: "Approx. 75"),
        DementiaSeverityDataModel(icon: "2.circle.fill", title: "Severity Level 2 (Moderate)", description: "It is difficult to live alone without the help of others, and recent events or important past events are easily forgotten.\nCalculation ability is slightly impaired, making it difficult to go out alone, calculate money, and no longer remember things properly.\nThe user is hardly aware of their declining memory and exhibits symptoms of indifference.\nDefinitively detected in detailed examinations.", IQLevel: "Approx. 65"),
        DementiaSeverityDataModel(icon: "3.circle.fill", title: "Severity Level 3 (Early Severe)", description: "The mental age begins to regress.\nUnable to live alone without the help of others, they forget important information about daily life and past memories.\nTime and space perception is impaired, and even very simple calculations become difficult.\nThe user cannot perceive their declining memory.", IQLevel: "Approx. 50"),
        DementiaSeverityDataModel(icon: "4.circle.fill", title: "Severity Level 4 (Mid Severe)", description: "The mental age significantly decreases.\nCannot remember the names of family members and forgets all recent events.\nCan barely remember past memories and cannot perform simple calculations.\nCannot find a way outside very familiar places and must depend on others for daily life.\nFrom this stage, the user cannot distinguish between day and night, and experiences severe insomnia, extreme mood swings, and various personality disorders.", IQLevel: "Approx. 40"),
        DementiaSeverityDataModel(icon: "5.circle.fill", title: "Severity Level 5 (End-Stage Severe)", description: "The mental age decreases to the level of 2-7 years old.\nCommunication ability is completely lost, and they can no longer go outside alone.\nAll memories stored in the brain are erased, and they are completely dependent on others for all actions.\nThey can hardly move their body, and their physical functions deteriorate rapidly.\nFrom this stage, the user is close to death.", IQLevel: "Below 30")
    ]
    
    var body: some View {
        NavigationView{
            ZStack{
                Color.background.ignoresSafeArea(.all, edges: [.top, .bottom])
                
                ScrollView{
                    VStack{
                        ForEach(severityList, id: \.self){ text in
                            DementiaSeverityInfoListModel(data: text)
                            
                            Spacer().frame(height: 20)
                        }
                    }.padding(20)
                }
                .navigationTitle(Text("Dementia Severity Information"))
                .toolbar{
                    ToolbarItem(placement: .topBarLeading, content: {Button("Close"){
                        dismiss()
                    }})
                }
                .animation(.easeInOut)

            }
        }
    }
}

#Preview {
    DementiaSeverityInfoView()
}
