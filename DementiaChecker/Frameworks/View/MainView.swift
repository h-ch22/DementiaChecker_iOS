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
    private let titles = ["홈", "병원", "진단", "기록", "더 보기"]
    
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
                                    .background(
                                        LinearGradient(colors: [Color.accentColor.opacity(0.4), Color.accentColor.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing)
                                    )
                                    .cornerRadius(30)
                                    .shadow(radius: 5)
                            }
                            
                            else{
                                VStack{
                                    Image(systemName: icons[number])
                                        .font(.system(
                                            size: 20,
                                            weight: .regular,
                                            design: .default
                                        ))
                                        .foregroundStyle(selectedIndex == number ? Color.txt : Color.gray)
                                    
                                    Spacer().frame(height: 5)
                                    
                                    if selectedIndex == number{
                                        Text(titles[number])
                                            .font(.caption)
                                            .foregroundStyle(Color.txt)
                                    }
                                }.padding(selectedIndex == number ? 10 : 0)
                                    .background(selectedIndex == number ? .ultraThinMaterial : .regular)
                                    .clipShape(RoundedRectangle(cornerRadius: selectedIndex == number ? 15 : 0))
                                
                            }
                            
                        }
                        
                        Spacer()
                    }
                }.padding(10)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .animation(.easeInOut)
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
