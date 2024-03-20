//
//  LifeLogPeriodSelectionView.swift
//  DementiaChecker
//
//  Created by 하창진 on 3/19/24.
//

import SwiftUI

struct LifeLogPeriodSelectionView: View {
    @StateObject private var helper = InspectionHelper()
    @EnvironmentObject var userManagement: UserManagement
    
    var body: some View {
        ZStack{
            Color.background.ignoresSafeArea([.all], edges: [.top, .bottom])
            
            VStack{
                Text("Select Data Period")
                    .font(.title)
                    .foregroundStyle(Color.txt)
                    .fontWeight(.semibold)
                
                Text("Select the duration of the data you want to use for the diagnosis. The longer the duration, the more accurate the diagnosis will be.")
                    .font(.caption)
                    .foregroundStyle(Color.gray)
                
                Spacer()
                
                HStack{
                    Button(action: {
                        helper.period = .ONE_DAY
                    }){
                        Text("1 DAY")
                            .foregroundStyle(Color.txt)
                    }
                    .buttonStyle(PushButtonNewMorphStyle(isSelected: helper.period == .ONE_DAY, foreground: Color.background))
                    
                    Spacer()
                    
                    Button(action: {
                        helper.period = .ONE_WEEK
                    }){
                        Text("7 DAYS")
                            .foregroundStyle(Color.txt)
                    }
                    .buttonStyle(PushButtonNewMorphStyle(isSelected: helper.period == .ONE_WEEK, foreground: Color.background))
                    
                    Spacer()
                    
                    Button(action: {
                        helper.period = .TWO_WEEKS
                    }){
                        VStack{
                            Text("14 DAYS")
                            Text("(recommended)")
                                .font(.caption)
                        }
                            .foregroundStyle(Color.txt)
                    }
                    .buttonStyle(PushButtonNewMorphStyle(isSelected: helper.period == .TWO_WEEKS, foreground: Color.background))
                }
                
                Spacer()
                
                NavigationLink(destination: MMSEInspectionMainView(helper: helper).environmentObject(userManagement)){
                    HStack{
                        Spacer()

                        Text("Next Step")
                            .foregroundStyle(Color.txt)
                        
                        Image(systemName: "chevron.right")
                            .foregroundStyle(Color.txt)
                        
                        Spacer()

                    }
                }.buttonStyle(NewMorphButtonStyle(foreground: Color.background))
            }
            .padding(20)
        }
    }
}

#Preview {
    LifeLogPeriodSelectionView()
}
