//
//  DementiaImprovementTypeSelectionView.swift
//  DementiaChecker
//
//  Created by Changjin Ha on 11/2/24.
//

import SwiftUI

struct DementiaImprovementTypeSelectionView: View {
    var body: some View {
        ZStack{
            Color.background.ignoresSafeArea(.all, edges: [.top, .bottom])
            
            VStack{
                Text("Start the dementia improvement process.\nSelect the type of process and proceed.")
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.gray)
                
                Spacer().frame(height: 20)

                Group{
                    NavigationLink(destination: EmptyView()){
                        HStack{
                            Image(systemName: "heart.fill")
                                .foregroundStyle(Color.txt)
                            
                            Spacer().frame(width: 10)
                            
                            VStack(alignment: .leading){
                                HStack{
                                    Text("Meditation")
                                        .fontWeight(.semibold)
                                        .foregroundStyle(Color.txt)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "clock.fill")
                                        .font(.caption)
                                        .foregroundStyle(Color.accentColor)
                                    
                                    Text("Duration: Approx. 3 minutes")
                                        .font(.caption)
                                        .foregroundStyle(Color.accentColor)
                                }

                                
                                Text("Enhance cognitive abilities and concentration through meditation to organize thoughts.")
                                    .font(.caption)
                                    .foregroundStyle(Color.gray)
                            }
                            
                            Spacer()
                        }
                    }.buttonStyle(NewMorphButtonStyle(foreground: Color.background, cornerRadius: 15))
                    
                    Spacer().frame(height: 20)
                    
                    NavigationLink(destination: EmptyView()){
                        HStack{
                            Image(systemName: "brain.fill")
                                .foregroundStyle(Color.txt)
                            
                            Spacer().frame(width: 10)
                            
                            VStack(alignment: .leading){
                                HStack{
                                    Text("Memory Enhancement")
                                        .fontWeight(.semibold)
                                        .foregroundStyle(Color.txt)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "clock.fill")
                                        .font(.caption)
                                        .foregroundStyle(Color.accentColor)
                                    
                                    Text("Duration: Approx. 5 minutes")
                                        .font(.caption)
                                        .foregroundStyle(Color.accentColor)
                                }

                                
                                Text("Enhance damaged memory due to dementia through memory enhancement training.")
                                    .font(.caption)
                                    .foregroundStyle(Color.gray)
                            }
                            
                            Spacer()
                        }
                    }.buttonStyle(NewMorphButtonStyle(foreground: Color.background, cornerRadius: 15))
                    
                    Spacer().frame(height: 20)
                    
                    NavigationLink(destination: AcrosticPoemView()){
                        HStack{
                            Image(systemName: "text.word.spacing")
                                .foregroundStyle(Color.txt)
                            
                            Spacer().frame(width: 10)
                            
                            VStack(alignment: .leading){
                                HStack{
                                    Text("Acrostic Poem")
                                        .fontWeight(.semibold)
                                        .foregroundStyle(Color.txt)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "clock.fill")
                                        .font(.caption)
                                        .foregroundStyle(Color.accentColor)
                                    
                                    Text("Duration: Approx. 10 minutes")
                                        .font(.caption)
                                        .foregroundStyle(Color.accentColor)
                                }

                                
                                Text("Enhance language ability, memory, and executive function through acrostic poem.")
                                    .font(.caption)
                                    .foregroundStyle(Color.gray)
                            }
                            
                            Spacer()
                        }
                    }.buttonStyle(NewMorphButtonStyle(foreground: Color.background, cornerRadius: 15))
                    
                    Spacer().frame(height: 20)
                    
                    NavigationLink(destination: PuzzleView()){
                        HStack{
                            Image(systemName: "puzzlepiece.extension.fill")
                                .foregroundStyle(Color.txt)
                            
                            Spacer().frame(width: 10)
                            
                            VStack(alignment: .leading){
                                HStack{
                                    Text("Puzzle")
                                        .fontWeight(.semibold)
                                        .foregroundStyle(Color.txt)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "clock.fill")
                                        .font(.caption)
                                        .foregroundStyle(Color.accentColor)
                                    
                                    Text("Duration: Approx. 30 minutes")
                                        .font(.caption)
                                        .foregroundStyle(Color.accentColor)
                                }

                                
                                Text("Enhance spatial and temporal abilities, fine motor skills, attention, and executive function through puzzle games.")
                                    .font(.caption)
                                    .foregroundStyle(Color.gray)
                            }
                            
                            Spacer()
                        }
                    }.buttonStyle(NewMorphButtonStyle(foreground: Color.background, cornerRadius: 15))
                    
                    Spacer()
                }
            }.padding(20)
                .navigationTitle(Text("Select Process Type"))
        }
    }
}

#Preview {
    DementiaImprovementTypeSelectionView()
}
