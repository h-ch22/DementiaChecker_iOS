//
//  AcrosticPoemView.swift
//  DementiaChecker
//
//  Created by 하창진 on 2/11/24.
//

import SwiftUI

struct AcrosticPoemView: View {
    @State private var showProgress = true
    @State private var showDoneScreen = false
    @State private var word: [Character] = []
    
    @State private var sentence_first = ""
    @State private var sentence_second = ""
    @State private var sentence_third = ""
    
    @StateObject private var helper = DementiaImprovementsHelper()
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack{
            Color.background.ignoresSafeArea(.all, edges: [.top, .bottom])
            
            VStack{
                if showProgress{
                    DotProgressView()
                } else if !showDoneScreen{
                    Spacer()
                    
                    HStack{
                        Text(String(word[0]))
                            .padding(20)
                            .background(
                                Circle()
                                    .fill(Color.background)
                                    .shadow(color: colorScheme == .light ? Color.black.opacity(0.2) : Color.btnStart.opacity(0.2), radius: 10, x: 10, y: 10)
                                    .shadow(color: colorScheme == .light ? Color.white.opacity(0.7) : Color.btnEnd.opacity(0.2), radius: 10, x: -5, y: -5)
                            )
                        
                        Spacer().frame(width: 10)
                        
                        HStack {
                            Image(systemName: "a.circle.fill")
                                .foregroundStyle(sentence_first == "" ? Color.gray : Color.accent)
                            
                            TextField("첫번째 문장", text: $sentence_first)
                        }
                        .foregroundStyle(Color.accent)
                        .padding(20)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(radius: 5)
                    }
                    
                    HStack{
                        Text(String(word[1]))
                            .padding(20)
                            .background(
                                Circle()
                                    .fill(Color.background)
                                    .shadow(color: colorScheme == .light ? Color.black.opacity(0.2) : Color.btnStart.opacity(0.2), radius: 10, x: 10, y: 10)
                                    .shadow(color: colorScheme == .light ? Color.white.opacity(0.7) : Color.btnEnd.opacity(0.2), radius: 10, x: -5, y: -5)
                            )
                        
                        Spacer().frame(width: 10)
                        
                        HStack {
                            Image(systemName: "a.circle.fill")
                                .foregroundStyle(sentence_second == "" ? Color.gray : Color.accent)
                            
                            TextField("두번째 문장", text: $sentence_second)
                        }
                        .foregroundStyle(Color.accent)
                        .padding(20)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(radius: 5)
                    }
                    
                    HStack{
                        Text(String(word[2]))
                            .padding(20)
                            .background(
                                Circle()
                                    .fill(Color.background)
                                    .shadow(color: colorScheme == .light ? Color.black.opacity(0.2) : Color.btnStart.opacity(0.2), radius: 10, x: 10, y: 10)
                                    .shadow(color: colorScheme == .light ? Color.white.opacity(0.7) : Color.btnEnd.opacity(0.2), radius: 10, x: -5, y: -5)
                            )
                        
                        Spacer().frame(width: 10)
                        
                        HStack {
                            Image(systemName: "a.circle.fill")
                                .foregroundStyle(sentence_third == "" ? Color.gray : Color.accent)
                            
                            TextField("세번째 문장", text: $sentence_third)
                        }
                        .foregroundStyle(Color.accent)
                        .padding(20)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(radius: 5)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        if sentence_first != "" && sentence_second != "" && sentence_third != ""{
                            if sentence_first.prefix(1) == String(word[0]) &&
                                sentence_second.prefix(1) == String(word[1]) &&
                                sentence_third.prefix(1) == String(word[2]) &&
                                sentence_first.count > 1 && sentence_second.count > 1 && sentence_third.count > 1{
                                showDoneScreen = true
                            }
                        }
                    }){
                        HStack{
                            Spacer()
                            
                            Text("완료")
                            Image(systemName: "chevron.right")
                            
                            Spacer()
                        }
                    }.buttonStyle(NewMorphButtonStyle(foreground: Color.background))
                } else{
                    Spacer()
                    
                    Image(systemName: "smiley")
                        .font(.largeTitle)
                        .foregroundStyle(Color.accentColor)
                    
                    Text("잘했어요!")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.accentColor)
                    
                    Text("하루에 한번, 삼행시를 반복해서 플레이해보세요!\n기억력과 집행 능력이 강화되어 치매 현상이 완화될 수 있습니다.")
                        .font(.caption)
                        .foregroundStyle(Color.gray)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    Button(action: {dismiss()}){
                        HStack{
                            Spacer()
                            
                            Text("이전 화면으로")
                            Image(systemName: "chevron.right")
                            
                            Spacer()
                        }
                    }.buttonStyle(NewMorphButtonStyle(foreground: Color.background))
                }
            }.padding(20)
                .animation(.easeInOut)
                .navigationTitle(Text("삼행시"))
                .onAppear{
                    let wordAsString = helper.getWord()
                    
                    for i in wordAsString{
                        word.append(i)
                    }
                    
                    showProgress = false
                }
        }
    }
}

#Preview {
    AcrosticPoemView()
}
