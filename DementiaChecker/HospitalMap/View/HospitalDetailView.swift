//
//  HospitalDetailView.swift
//  DementiaChecker
//
//  Created by 하창진 on 2/2/24.
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
    
    @Binding var data: LocationDataModel?
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.background.ignoresSafeArea(.all, edges: [.top, .bottom])
                
                VStack{
                    HospitalDetailMapView(data: data)
                                        
                    HStack{
                        Image(systemName: "location.fill.viewfinder")
                        Spacer().frame(width: 5)
                        Text(data?.roadAddr ?? "")
                        
                        Spacer()
                        
                        Text(data?.centerType ?? "")
                            .font(.caption)
                            .foregroundStyle(Color.gray)
                    }.padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    
                    Spacer().frame(height: 20)

                    HStack{
                        Image(systemName: "person.3.fill")
                        Spacer().frame(width: 5)
                        Text("의사")
                        
                        Spacer()
                        
                        Text("\(data?.doctorCount ?? 0)명")
                            .foregroundStyle(Color.accent)

                    }.padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    
                    Spacer().frame(height: 20)

                    HStack{
                        Image(systemName: "person.3.fill")
                        Spacer().frame(width: 5)
                        Text("간호사")
                        
                        Spacer()
                        
                        Text("\(data?.nurseCount ?? 0)명")
                            .foregroundStyle(Color.accent)

                    }.padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    
                    Spacer().frame(height: 20)

                    HStack{
                        Image(systemName: "person.3.fill")
                        Spacer().frame(width: 5)
                        Text("사회 복지사")
                        
                        Spacer()
                        
                        Text("\(data?.scrcsCount ?? 0)명")
                            .foregroundStyle(Color.accent)
                    }.padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    
                }.padding(20)
                .navigationTitle(Text(data?.centerName ?? "센터 정보"))
                .toolbar{
                    ToolbarItem(placement: .topBarLeading, content: {
                        Button("닫기"){
                            self.dismiss()
                        }
                    })
                }
            }
        }
    }
}

#Preview {
    HospitalDetailView(data: .constant(LocationDataModel(centerName: "", centerType: "", roadAddr: "", latitude: 0.0, longitude: 0.0, doctorCount: 0, nurseCount: 0, scrcsCount: 0, tel: "")))
}
