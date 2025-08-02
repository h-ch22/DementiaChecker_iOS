//
//  WriteDiaryMainView.swift
//  DementiaChecker
//
//  Created by Changjin Ha on 2/11/24.
//

import SwiftUI

struct WriteDiaryMainView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var changeView = false

    var body: some View {
        NavigationView{
            ZStack{
                Color.background.ignoresSafeArea(.all, edges: [.top, .bottom])
                
                VStack{
                    Spacer()
                    
                    HStack{
                        Image(systemName : "pencil")
                        
                        VStack{
                            HStack{
                                Text("Recording Today's Day")
                                    .foregroundStyle(Color.txt)
                                
                                Spacer()
                            }

                            HStack{
                                Text("Write a daily diary and record who you are today.")
                                    .font(.caption)
                                    .foregroundStyle(Color.gray)
                                
                                Spacer()
                            }

                        }
                    }
                    
                    Spacer().frame(height : 20)
                    
                    HStack{
                        Image(systemName : "calendar")
                        
                        VStack{
                            HStack{
                                Text("Review")
                                    .foregroundStyle(Color.txt)
                                
                                Spacer()
                            }

                            HStack{
                                Text("Keep track of your day and look back on your days.")
                                    .font(.caption)
                                    .foregroundStyle(Color.gray)
                                
                                Spacer()
                            }

                        }
                    }
                    
                    Spacer().frame(height : 20)
                    
                    HStack{
                        Image(systemName : "chart.xyaxis.line")
                        
                        VStack{
                            HStack{
                                Text("Export Emotional Status")
                                    .foregroundStyle(Color.txt)
                                
                                Spacer()
                            }

                            HStack{
                                Text("If you need a psychological consultation with a professional, you can export your emotional state as a PDF and use it as a reference for the consultation.")
                                    .font(.caption)
                                    .foregroundStyle(Color.gray)
                                
                                Spacer()
                            }

                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        self.changeView = true
                    }){
                        HStack{
                            Spacer()
                            
                            Text("Write a diary")
                                .foregroundStyle(Color.txt)
                            
                            Image(systemName : "chevron.right")
                                .foregroundStyle(Color.txt)

                            Spacer()
                        }
                    }.buttonStyle(NewMorphButtonStyle(foreground: Color.background))
                }
                .padding(20)

            }
            .navigationTitle(Text("Write a diary"))
                .toolbar(content: {
                    ToolbarItemGroup(placement: .topBarTrailing, content: {
                        Button(action: { self.presentationMode.wrappedValue.dismiss() }){
                            Image(systemName: "xmark")
                        }
                    })
                })
                .fullScreenCover(isPresented: $changeView, content: {
                    WriteDiaryView()
                })
        }
        .navigationViewStyle(StackNavigationViewStyle())

    }
}

#Preview {
    WriteDiaryMainView()
}
