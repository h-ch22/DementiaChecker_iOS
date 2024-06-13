//
//  InfoView.swift
//  DementiaChecker
//
//  Created by Changjin Ha on 2/11/24.
//

import SwiftUI

struct InfoView: View {
    @StateObject private var helper = VersionHelper()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack{
            Color.background.ignoresSafeArea(.all, edges: [.top, .bottom])
            
            VStack{
                HStack{
                    Image("ic_appstore")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                    
                    VStack(alignment: .leading){
                        TextLogoRegular()
                        
                        Text("Version: \(helper.version == "" ? "Unknown" : helper.version) (Build: \(helper.build == "" ? "Unknown" : helper.build))")
                            .font(.caption)
                            .foregroundStyle(Color.txt)
                        
                        if helper.latestVersion == "" || helper.latestBuild == ""{
                            HStack{
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.caption)
                                    .foregroundStyle(Color.orange)
                                
                                Text("Unable to fetch the latest version information.")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.orange)
                                
                                Spacer()
                            }
                        } else if helper.latestVersion == helper.version && helper.latestBuild == helper.build{
                            HStack{
                                Image(systemName: "checkmark")
                                    .font(.caption)
                                    .foregroundStyle(Color.green)
                                
                                Text("Up to date.")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.green)
                                
                                Spacer()
                            }
                        } else{
                            HStack{
                                Image(systemName: "arrow.up.circle.fill")
                                    .font(.caption)
                                    .foregroundStyle(Color.blue)
                                
                                Text("Update available. (\(helper.latestVersion) (\(helper.latestBuild)))")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.blue)
                                
                                Spacer()
                            }
                        }
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.background)
                        .shadow(color: colorScheme == .light ? Color.black.opacity(0.2) : Color.btnStart.opacity(0.2), radius: 10, x: 10, y: 10)
                        .shadow(color: colorScheme == .light ? Color.white.opacity(0.7) : Color.btnEnd.opacity(0.2), radius: 10, x: -5, y: -5)
                )
                
                Spacer().frame(height: 20)
                
                Button(action: {}){
                    HStack{
                        Image(systemName: "doc.text.fill")
                            .foregroundStyle(Color.txt)
                        
                        Text("Read End User License Agreement")
                            .foregroundStyle(Color.txt)

                        Spacer()
                    }
                }.buttonStyle(NewMorphButtonStyle(foreground: Color.background, cornerRadius: 15))
                
                Spacer().frame(height: 20)
                
                Button(action: {}){
                    HStack{
                        Image(systemName: "lock.doc.fill")
                            .foregroundStyle(Color.txt)
                        
                        Text("Read Privacy Policy")
                            .foregroundStyle(Color.txt)

                        Spacer()
                    }
                }.buttonStyle(NewMorphButtonStyle(foreground: Color.background, cornerRadius: 15))
                
                Spacer().frame(height: 20)
                
                Button(action: {}){
                    HStack{
                        Image(systemName: "person.badge.shield.checkmark.fill")
                            .foregroundStyle(Color.txt)
                        
                        Text("Read Sensitive Data Collection and Processing Policy")
                            .foregroundStyle(Color.txt)

                        Spacer()
                    }
                }.buttonStyle(NewMorphButtonStyle(foreground: Color.background, cornerRadius: 15))
                
                Spacer()
                
                Text("© 2024 Changjin Ha\nAll Rights Reserved.")
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.gray)
            }.padding(20)
                .onAppear{
                    helper.getCurrnetVersion()
                    helper.getLatestVersion(){ _ in
                    }
                }
                .navigationTitle(Text("About"))
        }
    }
}

#Preview {
    InfoView()
}
