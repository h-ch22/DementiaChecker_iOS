//
//  HospitalMapView.swift
//  DementiaChecker
//
//  Created by Changjin Ha on 1/28/24.
//

import SwiftUI
import SwiftUIPager

struct HospitalMapViewController: UIViewControllerRepresentable{
    @EnvironmentObject var helper: HospitalMapHelper
    
    func makeUIViewController(context: Context) -> MapView {
        let view = MapView(data: helper.hospitalList)
        
        return view
    }
    
    func updateUIViewController(_ uiViewController: MapView, context: Context) {
        
    }
}

struct HospitalMapView: View {
    @StateObject var helper = HospitalMapHelper()
    
    @State private var showView = false
    @State private var showDetailView = false
    @State private var currentIndex = 0
    @State private var selectedData: LocationDataModel? = nil
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack{
            Color.background.ignoresSafeArea(.all, edges: [.top, .bottom])
            
            if showView{
                HospitalMapViewController()
                    .environmentObject(helper)
                
                VStack{
                    Spacer()
                    
                    TabView(selection: $currentIndex){
                        ForEach(helper.hospitalList, id: \.self){ item in
                            Button(action: {
                                selectedData = item
                                showDetailView = true
                            }){
                                HospitalListModel(data: item)
                                    .padding(20)
                                
                            }
                            
                        }
                    }.frame(width: 300, height: 100)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.background)
                                .shadow(color: colorScheme == .light ? Color.black.opacity(0.2) : Color.btnStart.opacity(0.2), radius: 10, x: 10, y: 10)
                                .shadow(color: colorScheme == .light ? Color.white.opacity(0.7) : Color.btnEnd.opacity(0.2), radius: 10, x: -5, y: -5)
                        )
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                }
                
                
            } else{
                VStack{
                    Spacer()
                    
                    DotProgressView()
                    
                    Spacer()
                }
            }
            
        }
        .onAppear{
            helper.parse(){ result in
                guard let result = result else{return}
                
                if result{
                    showView = true
                }
            }
        }
        .sheet(isPresented: $showDetailView, content: {
            HospitalDetailView(data: $selectedData)
        })
        .animation(Animation.easeInOut(duration: 0.5), value: true)

    }
}

#Preview {
    HospitalMapView()
}
