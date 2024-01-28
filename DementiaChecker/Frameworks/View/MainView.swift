//
//  MainView.swift
//  DementiaChecker
//
//  Created by 하창진 on 1/28/24.
//

import SwiftUI

struct MainView: View {
    @State var selectedIndex = 0
    @State private var showModal = false
    
    private let icons = ["house.fill", "map.fill", "plus", "calendar.badge.clock", "ellipsis.circle.fill"]

    var body: some View {
        NavigationStack{
            VStack{
                ZStack{
                    switch selectedIndex{
                    case 0:
                        HomeView()
                        
                    case 1:
                        HospitalMapView()
                        
                    case 3:
                        HistoryView()
                        
                    case 4:
                        MoreView()
                        
                    default:
                        HomeView()
                    }
                }
                
                Spacer()
                
                Divider()
                
                HStack{
                    ForEach(0..<5, id:\.self){number in
                        Spacer()
                        
                        Button(action: {
                            if number == 2{
                                self.showModal = true
                            }
                            
                            else{
                                selectedIndex = number
                            }
                        }){
                            if number == 2{
                                Image(systemName: icons[number])
                                    .font(.system(
                                        size: 25,
                                        weight: .regular,
                                        design: .default
                                    ))
                                    .foregroundColor(.white)
                                    .frame(width : 60, height : 60)
                                    .background(Color.accent)
                                    .cornerRadius(30)
                                    .shadow(radius: 3)
                            }
                            
                            else{
                                Image(systemName: icons[number])
                                    .font(.system(
                                        size: 25,
                                        weight: .regular,
                                        design: .default
                                    ))
                                    .foregroundColor(selectedIndex == number ? .accent : .gray)
                            }
                            
                        }
                        
                        Spacer()
                    }
                }
            }
            
            .sheet(isPresented: $showModal, content: {
                InspectionView()
            })
            
            .background(Color.background.ignoresSafeArea(.all, edges: [.top, .bottom]))
            
        }
        .toolbar(.hidden)
    }
}

#Preview {
    MainView()
}
