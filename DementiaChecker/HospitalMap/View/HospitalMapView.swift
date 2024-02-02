//
//  HospitalMapView.swift
//  DementiaChecker
//
//  Created by 하창진 on 1/28/24.
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
    
    var body: some View {
        ZStack{
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
                        .background(.ultraThickMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(radius: 5)
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                }
                
                
            } else{
                ProgressView()
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
    }
}

#Preview {
    HospitalMapView()
}
