//
//  DementiaImprovementMainView.swift
//  DementiaChecker
//
//  Created by Changjin Ha on 11/2/24.
//

import SwiftUI

struct DementiaImprovementMainView: View {
    @State private var showHelper = false
    @State private var introductionTexts = [
        IntroductionDataModel(icon: "brain.head.profile.fill",
                                        title: "Start Dementia Improvement Process",
                                        description: "Slow down the progression of dementia or improve some symptoms through meditation, cognitive enhancement processes, etc."),
        
        IntroductionDataModel(icon: "puzzlepiece.extension.fill",
                                        title: "Process Information",
                                        description: "This process may take over 1 hour depending on the severity of the user.\nTo improve cognitive abilities, you need to solve multiple problems, and adjust the difficulty depending on the severity of dementia improvement."),
        
        IntroductionDataModel(icon: "lightbulb.max.fill",
                                        title: "Get Medical Advice",
                                        description: "Depending on the severity of dementia, you may not benefit from this process.\nIt is recommended to visit a medical institution to confirm the suitability of this process and seek medical advice before proceeding.")
    ]
    
    var body: some View {
        ZStack{
            Color.background.ignoresSafeArea(.all, edges: [.top, .bottom])
            
            VStack{
                Spacer()
                
                Group{
                    ForEach(introductionTexts, id: \.self){ text in
                        InspectionIntroductionListModel(icon: text.icon, title: text.title, description: text.description)
                        
                        Spacer().frame(height: 20)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "person.badge.shield.checkmark.fill")
                        .foregroundStyle(Color.accent)
                    
                    Text("This process does not guarantee complete recovery from dementia.\nIf dementia is severe, seek medical advice and medical measures through consultation with experts at a medical institution.\nUsers may not benefit from Dementia Checker for medical purposes.")
                        .font(.caption)
                        .foregroundStyle(Color.gray)
                        .multilineTextAlignment(.center)
                    
                    Spacer().frame(height: 20)
                    
                    HStack{
                        Spacer()
                        
                        NavigationLink(destination: DementiaImprovementTypeSelectionView()){
                            HStack{
                                Spacer()
                                
                                Text("Next Step")
                                    .foregroundStyle(Color.txt)
                                
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(Color.txt)
                                
                                Spacer()
                                
                            }
                        }.buttonStyle(NewMorphButtonStyle(foreground: Color.background))
                        
                        Spacer().frame(width: 20)
                        
                        Button(action: {
                            showHelper = true
                        }){
                            Image(systemName: "questionmark")
                                .font(.caption)
                                .foregroundStyle(Color.txt)
                        }.buttonStyle(CircleNewMorphButtonStyle(foreground: Color.background, paddingValue: 7))
                    }
                }
            }.padding(20).navigationTitle(Text("Start Dementia Improvement Process"))
                .sheet(isPresented: $showHelper, content: {
                    DementiaSeverityInfoView()
                })
                .animation(.easeInOut)
        }
    }
}

#Preview {
    DementiaImprovementMainView()
}
