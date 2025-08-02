//
//  InspectionView.swift
//  DementiaChecker
//
//  Created by Changjin Ha on 1/28/24.
//

import SwiftUI

struct InspectionView: View {
    @Environment(\.dismiss) var dismiss
    @State private var introductionTexts = [
        IntroductionDataModel(icon: "magnifyingglass",
                              title: "Dementia Assessment Using Deep Learning",
                              description: "By using deep learning based on lifestyle patterns and basic test results, the app can assess and predict the user's dementia condition."),
        
        IntroductionDataModel(icon: "calendar.badge.clock",
                              title: "View Test Records",
                              description: "In the test records tab, you can view the user's test records by date and track the trend of severity changes."),
        
        IntroductionDataModel(icon: "applewatch",
                              title: "Wear an Apple Watch for Accurate Diagnosis",
                              description: "For accurate diagnosis, wear an Apple Watch and live with it for at least 2 weeks.")
    ]
    
    @EnvironmentObject var userManagement: UserManagement
    let showToolbar: Bool
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.background.ignoresSafeArea(.all, edges: [.top, .bottom])
                
                VStack{
                    Spacer()

                    ForEach(introductionTexts, id: \.self){ text in
                        InspectionIntroductionListModel(icon: text.icon, title: text.title, description: text.description)
                        
                        Spacer().frame(height: 20)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "person.badge.shield.checkmark.fill")
                        .foregroundStyle(Color.accent)
                    
                    Text("Dementia Checker does not guarantee the accuracy of diagnostic results.\nIf dementia is suspected, visit a medical institution for consultation with experts and receive medical treatment.\nThe user cannot benefit from medical treatment through Dementia Checker.")
                        .font(.caption)
                        .foregroundStyle(Color.gray)
                        .multilineTextAlignment(.center)
                    
                    Spacer().frame(height: 20)
                    
                    NavigationLink(destination: LifeLogPeriodSelectionView().environmentObject(userManagement)){
                        HStack{
                            Spacer()

                            Text("Next Step")
                                .foregroundStyle(Color.txt)
                            
                            Image(systemName: "chevron.right")
                                .foregroundStyle(Color.txt)
                            
                            Spacer()

                        }
                    }.buttonStyle(NewMorphButtonStyle(foreground: Color.background))
                }.padding(20)
                .navigationTitle(Text("Start Inspection"))
                .toolbar{
                    if showToolbar{
                        ToolbarItem(placement: .topBarLeading, content: {
                            Button(action: { dismiss() }){
                                Image(systemName: "xmark")
                            }
                        })
                    }
                }
                .animation(Animation.easeInOut(duration: 0.5), value: true)

            }
        }
    }
}

#Preview {
    InspectionView(showToolbar: false)
        .environmentObject(UserManagement())
}
