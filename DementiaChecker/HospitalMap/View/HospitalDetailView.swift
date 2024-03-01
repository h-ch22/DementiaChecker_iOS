//
//  HospitalDetailView.swift
//  DementiaChecker
//
//  Created by Changjin Ha on 2/2/24.
//

import SwiftUI
import NMapsMap

struct HospitalDetailMapView: UIViewControllerRepresentable{
    let data: LocationDataModel?
    typealias UIViewControllerType = HospitalDetailsMapViewController
    
    func makeUIViewController(context: Context) -> HospitalDetailsMapViewController {
        return HospitalDetailsMapViewController(location: NMGLatLng(lat: data?.latitude ?? 0.0, lng: data?.longitude ?? 0.0), hospitalName: data?.centerName ?? "")
    }
    
    func updateUIViewController(_ uiViewController: HospitalDetailsMapViewController, context: Context) {
        
    }
}

struct HospitalDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var data: LocationDataModel?
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.background.ignoresSafeArea(.all, edges: [.top, .bottom])
                
                ScrollView{
                    VStack{
                        HospitalDetailMapView(data: data)
                            .frame(width: 300, height: 250)
                        
                        Spacer().frame(height: 20)
                        
                        HStack{
                            Button(action: {
                                let url = URL(string: "maps://?saddr=&daddr=\(data?.latitude ?? 0.0), \(data?.longitude ?? 0.0)")
                                
                                if UIApplication.shared.canOpenURL(url!){
                                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                                }
                            }){
                                VStack{
                                    Image(systemName: "arrow.triangle.turn.up.right.diamond.fill")
                                        .foregroundStyle(Color.white)
                                    
                                    Spacer().frame(height: 5)
                                    
                                    Text("Directions")
                                        .foregroundStyle(Color.white)
                                }
                                    .frame(width: 80, height: 80)
                            }
                            .buttonStyle(NewMorphButtonStyle(foreground: Color.blue, paddingValue: 5, cornerRadius: 15))
                            
                            Spacer()
                            
                            Button(action: {
                                if let url = NSURL(string: "tel://\(data?.tel ?? "")"){
                                    if UIApplication.shared.canOpenURL(url as URL){
                                        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                                    }
                                }
                            }){
                                VStack{
                                    Image(systemName: "phone.fill")
                                        .foregroundStyle(Color.txt)
                                    
                                    Spacer().frame(height: 5)
                                    
                                    Text("Call")
                                        .foregroundStyle(Color.txt)
                                }
                                    .frame(width: 80, height: 80)
                            }
                            .buttonStyle(NewMorphButtonStyle(foreground: Color.background, paddingValue: 5, cornerRadius: 15))
                            
                            Spacer()
                            
                            Button(action: {
                                if let url = NSURL(string: "https://map.naver.com/index.nhn?enc=utf8&level=2&lng=\(data?.longitude ?? 0.0)&lat=\(data?.latitude ?? 0.0)&pinTitle=\(data?.centerName ?? "")&pinType=SITE"){
                                    if UIApplication.shared.canOpenURL(url as URL){
                                        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                                    }
                                }
                            }){
                                VStack{
                                    Image(systemName: "ellipsis")
                                        .foregroundStyle(Color.txt)
                                    
                                    Spacer().frame(height: 5)
                                    
                                    Text("More")
                                        .foregroundStyle(Color.txt)
                                }
                                    .frame(width: 80, height: 80)
                            }
                            .buttonStyle(NewMorphButtonStyle(foreground: Color.background, paddingValue: 5, cornerRadius: 15))
                        }
                        
                        Spacer().frame(height: 20)
                                           
                        HStack{
                            Image(systemName: "location.fill.viewfinder")
                            Spacer().frame(width: 5)
                            Text(data?.roadAddr ?? "")
                            
                            Spacer()
                            
                            Text(data?.centerType ?? "")
                                .font(.caption)
                                .foregroundStyle(Color.gray)
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.background)
                                .shadow(color: colorScheme == .light ? Color.black.opacity(0.2) : Color.btnStart.opacity(0.2), radius: 10, x: 10, y: 10)
                                .shadow(color: colorScheme == .light ? Color.white.opacity(0.7) : Color.btnEnd.opacity(0.2), radius: 10, x: -5, y: -5)
                        )
                        
                        Spacer().frame(height: 20)
                        

                        HStack{
                            Image(systemName: "person.3.fill")
                            Spacer().frame(width: 5)
                            Text("Doctors")
                            
                            Spacer()
                            
                            Text("\(data?.doctorCount ?? 0)")
                                .foregroundStyle(Color.accent)

                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.background)
                                .shadow(color: colorScheme == .light ? Color.black.opacity(0.2) : Color.btnStart.opacity(0.2), radius: 10, x: 10, y: 10)
                                .shadow(color: colorScheme == .light ? Color.white.opacity(0.7) : Color.btnEnd.opacity(0.2), radius: 10, x: -5, y: -5)
                        )
                        
                        Spacer().frame(height: 20)

                        HStack{
                            Image(systemName: "person.3.fill")
                            Spacer().frame(width: 5)
                            Text("Nurses")
                            
                            Spacer()
                            
                            Text("\(data?.nurseCount ?? 0)")
                                .foregroundStyle(Color.accent)

                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.background)
                                .shadow(color: colorScheme == .light ? Color.black.opacity(0.2) : Color.btnStart.opacity(0.2), radius: 10, x: 10, y: 10)
                                .shadow(color: colorScheme == .light ? Color.white.opacity(0.7) : Color.btnEnd.opacity(0.2), radius: 10, x: -5, y: -5)
                        )
                        
                        Spacer().frame(height: 20)

                        HStack{
                            Image(systemName: "person.3.fill")
                            Spacer().frame(width: 5)
                            Text("Social Workers")
                            
                            Spacer()
                            
                            Text("\(data?.scrcsCount ?? 0)")
                                .foregroundStyle(Color.accent)
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.background)
                                .shadow(color: colorScheme == .light ? Color.black.opacity(0.2) : Color.btnStart.opacity(0.2), radius: 10, x: 10, y: 10)
                                .shadow(color: colorScheme == .light ? Color.white.opacity(0.7) : Color.btnEnd.opacity(0.2), radius: 10, x: -5, y: -5)
                        )
                        
                        
                    }.padding(20)
                    .navigationTitle(Text(data?.centerName ?? "Center Information"))
                    .toolbar{
                        ToolbarItem(placement: .topBarLeading, content: {
                            Button("Close"){
                                self.dismiss()
                            }
                        })
                    }
                    .animation(.easeInOut)
                }
            }
        }
    }
}

#Preview {
    HospitalDetailView(data: .constant(LocationDataModel(centerName: "", centerType: "", roadAddr: "", latitude: 0.0, longitude: 0.0, doctorCount: 0, nurseCount: 0, scrcsCount: 0, tel: "")))
}
