//
//  HospitalListModel.swift
//  DementiaChecker
//
//  Created by 하창진 on 2/1/24.
//

import SwiftUI

struct HospitalListModel: View {
    let data: LocationDataModel
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text(data.centerName)
                
                Spacer()
                
                Text(data.centerType)
                    .font(.caption)
            }
            
            Spacer().frame(height: 5)
            
            Divider()
            
            Spacer().frame(height: 5)

            HStack{
                Image(systemName: "location.fill.viewfinder")
                    .foregroundStyle(Color.gray)
                
                Spacer().frame(width: 5)
                
                Text(data.roadAddr)
                    .font(.caption)
                    .foregroundStyle(Color.gray)
            }
            
            Spacer().frame(height: 10)
            
            Button(action: {}){
                Image(systemName: "phone.circle.fill")
            }
            
        }.padding()

    }
}

#Preview {
    HospitalListModel(data: LocationDataModel(centerName: "Center Name", centerType: "Center Type", roadAddr: "Road Addr", latitude: 0.0, longitude: 0.0, doctorCount: 0, nurseCount: 0, scrcsCount: 0, tel: ""))
}
