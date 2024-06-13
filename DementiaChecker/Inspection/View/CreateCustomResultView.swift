//
//  CreateCustomResultView.swift
//  DementiaChecker
//
//  Created by 하창진 on 4/23/24.
//

import SwiftUI

struct CreateCustomResultView: View {
    @StateObject var helper: InspectionHelper
    
    @EnvironmentObject var userManagement: UserManagement
    
    @State private var answerList = [Bool](repeating: false, count: 30)
    @State private var changeView = false
    
    var body: some View {
        ZStack{
            Color.background.ignoresSafeArea(.all, edges: [.top, .bottom])
            
            ScrollView{
                VStack{
                    ForEach(0...29, id: \.self){idx in
                        HStack{
                            Toggle(isOn: $answerList[idx], label: {
                                Text(helper.getCustomMMSEQuestion(id: idx))
                            }).toggleStyle(NewMorphToggleStyle())
                                .padding(5)
                        }
                    }
                    
                    Spacer().frame(height: 20)
                    
                    Button(action: {
                        changeView = true
                    }){
                        HStack{
                            Text("Start Prediction")
                                .foregroundStyle(Color.txt)
                            
                            Image(systemName: "chevron.right")
                                .foregroundStyle(Color.txt)
                        }.padding([.horizontal], 80)
                    }.buttonStyle(NewMorphButtonStyle(foreground: Color.background))
                }.padding(20)
            }.background(
                Color.background.ignoresSafeArea(.all, edges: [.top, .bottom])
            )
            .navigationTitle(Text("Create Custom Result"))
            .fullScreenCover(isPresented: $changeView, content: {
                MMSEInspectionView(helper: helper, useCustomData: true, answerList: answerList)
                    .environmentObject(userManagement)
            })
        }
    }
}

#Preview {
    CreateCustomResultView(helper: InspectionHelper()).environmentObject(UserManagement())
}
