//
//  DigitalInheritanceMainView.swift
//  DementiaChecker
//
//  Created by Changjin Ha on 1/29/24.
//

import SwiftUI

struct DigitalInheritanceMainView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var helper: UserManagement
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.background.ignoresSafeArea(.all, edges: [.bottom, .top])
                
                VStack{
                    Spacer()
                    
                    HStack{
                        Image(systemName: "person.fill")
                            .foregroundStyle(Color.txt)

                        VStack(alignment: .leading){
                            Text("Start Digital Inheritance")
                                .fontWeight(.semibold)
                            
                            Text("By adding the account of a trusted person, that person will be able to access the user's data after the user's death.")
                                .font(.caption)
                                .foregroundStyle(Color.gray)
                        }
                        
                        Spacer()
                    }
                    
                    Spacer().frame(height: 20)
                    
                    HStack{
                        Image(systemName: "lock.doc.fill")
                            .foregroundStyle(Color.txt)

                        VStack(alignment: .leading){
                            Text("Access Restriction")
                                .fontWeight(.semibold)
                            
                            Text("Until it is confirmed that the user has died, the inheritance manager cannot access any information other than what the user has permitted.")
                                .font(.caption)
                                .foregroundStyle(Color.gray)
                        }
                        
                        Spacer()
                    }
                    
                    Spacer().frame(height: 20)
                    
                    HStack{
                        Image(systemName: "doc.fill")
                            .foregroundStyle(Color.txt)
                        
                        VStack(alignment: .leading){
                            Text("Passing on Digital Inheritance")
                                .fontWeight(.semibold)
                            
                            Text("You can share or request disposal of test records, health status, and personal information stored within the application with loved ones as inheritance.")
                                .font(.caption)
                                .foregroundStyle(Color.gray)
                        }
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: InheritanceGuardianSelectionView().environmentObject(helper)){
                        HStack{
                            Spacer()
                            
                            Text("Get Started")
                                .foregroundStyle(Color.txt)
                            
                            Image(systemName: "chevron.right")
                                .foregroundStyle(Color.txt)
                            
                            Spacer()
                        }
                    }.buttonStyle(NewMorphButtonStyle(foreground: Color.background))
                }.padding(20)
            }.navigationTitle(Text("Digital Inheritance"))
                .toolbar{
                    ToolbarItem(placement: .topBarLeading, content: {
                        Button("Close"){
                            dismiss()
                        }
                    })
                }
                .animation(.easeInOut)

        }
    }
}

#Preview {
    DigitalInheritanceMainView()
        .environmentObject(UserManagement())
}
