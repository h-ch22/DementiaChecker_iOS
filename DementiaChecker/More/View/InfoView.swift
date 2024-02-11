//
//  InfoView.swift
//  DementiaChecker
//
//  Created by 하창진 on 2/11/24.
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
                        
                        Text("버전: \(helper.version == "" ? "알 수 없음" : helper.version) (빌드: \(helper.build == "" ? "알 수 없음" : helper.build))")
                            .font(.caption)
                            .foregroundStyle(Color.txt)
                        
                        if helper.latestVersion == "" || helper.latestBuild == ""{
                            HStack{
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.caption)
                                    .foregroundStyle(Color.orange)
                                
                                Text("최신 버전 정보를 확인할 수 없습니다.")
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
                                
                                Text("최신 버전입니다.")
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
                                
                                Text("업데이트를 사용할 수 있습니다. (\(helper.latestVersion) (\(helper.latestBuild)))")
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
                        
                        Text("최종 사용권 계약서 읽기")
                            .foregroundStyle(Color.txt)

                        Spacer()
                    }
                }.buttonStyle(NewMorphButtonStyle(foreground: Color.background, cornerRadius: 15))
                
                Spacer().frame(height: 20)
                
                Button(action: {}){
                    HStack{
                        Image(systemName: "lock.doc.fill")
                            .foregroundStyle(Color.txt)
                        
                        Text("개인정보 수집 및 처리 방침 읽기")
                            .foregroundStyle(Color.txt)

                        Spacer()
                    }
                }.buttonStyle(NewMorphButtonStyle(foreground: Color.background, cornerRadius: 15))
                
                Spacer().frame(height: 20)
                
                Button(action: {}){
                    HStack{
                        Image(systemName: "person.badge.shield.checkmark.fill")
                            .foregroundStyle(Color.txt)
                        
                        Text("민감정보 수집 및 처리 방침 읽기")
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
                    helper.getLatestVersion(){ result in
                        guard let result = result else{return}
                    }
                }
                .navigationTitle(Text("정보"))
        }
    }
}

#Preview {
    InfoView()
}
