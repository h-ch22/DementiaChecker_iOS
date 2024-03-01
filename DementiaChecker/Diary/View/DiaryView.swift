//
//  DiaryView.swift
//  DementiaChecker
//
//  Created by Changjin Ha on 2/11/24.
//

import SwiftUI

struct DiaryView: View {
    @StateObject private var helper = DiaryHelper()
    
    @State private var showProgress = true
    @State private var showError = false
    @State private var showModal = false
    @State private var currentIndex = 0
    @State private var emotions = ["🥰 Happy", "😆 Best", "😀 Good", "🙂 Soso", "☹️ Bad", "😢 Sad", "😣 Want to be alone", "😡 Angry"]
    @State private var showAlert = false
    
    private func getCodeByEmotion(code: DiaryEmotionModel) -> String{
        switch code{
        case .HAPPY: return emotions[0]
        case .GREAT: return emotions[1]
        case .GOOD: return emotions[2]
        case .SOSO: return emotions[3]
        case .BAD: return emotions[4]
        case .SAD: return emotions[5]
        case .STAY_ALONE: return emotions[6]
        case .ANGRY: return emotions[8]
        }
    }
    
    private func getStringDate() -> (String, String, String?){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd."
        
        let date = dateFormatter.date(from: helper.diaryList[currentIndex].date)
        
        let year = date?.year
        let month = date?.month
        let day = date?.day
        let weekDay = date?.weekDay
        
        return (String("\(year ?? 0)/\(month ?? 0)"), String(day ?? 0), date?.codeToWeekDay(code: weekDay ?? 0))
    }
    
    var body: some View {
        ZStack{
            Color.background.ignoresSafeArea(.all, edges: [.top, .bottom])
            
            VStack{
                if showProgress{
                    Spacer()
                    
                    DotProgressView()
                    
                    Spacer()
                } else if showError{
                    Spacer()
                    
                    Image(systemName : "exclamationmark.circle.fill")
                        .font(.largeTitle)
                        .foregroundStyle(Color.gray)
                    
                    Spacer()
                } else if helper.diaryList.isEmpty{
                    VStack{
                        Spacer()
                        
                        Image(systemName : "square.and.pencil")
                            .font(.title)
                        
                        Text("Write down who you are today.")
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.gray)
                        
                        Spacer()
                    }
                } else{
                    ScrollView{
                        VStack{
                            Group{
                                HStack{
                                    Button(action: {
                                        if currentIndex > 0{
                                            currentIndex -= 1
                                            
                                            helper.getURL(id: helper.diaryList[currentIndex].date, imgCount: helper.diaryList[currentIndex].imgCount){ downloadResult in
                                                guard let downloadResult = downloadResult else{return}
                                            }
                                        }
                                    }){
                                        Image(systemName: "chevron.left")
                                    }.buttonStyle(CircleNewMorphButtonStyle(foreground: Color.background, paddingValue: 7))
                                    
                                    Spacer()
                                    
                                    Text(self.getStringDate().1)
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundStyle(Color.txt)
                                    
                                    VStack(alignment: .leading){
                                        Text(self.getStringDate().0)
                                            .font(.caption)
                                            .foregroundStyle(Color.gray)
                                        
                                        Text("\(self.getStringDate().2 ?? "")")
                                            .font(.caption)
                                            .foregroundStyle(Color.gray)
                                    }
                                    
                                    Spacer()

                                    Button(action: {
                                        if currentIndex < helper.diaryList.count-1{
                                            currentIndex += 1
                                            
                                            helper.getURL(id: helper.diaryList[currentIndex].date, imgCount: helper.diaryList[currentIndex].imgCount){ downloadResult in
                                                guard let downloadResult = downloadResult else{return}
                                            }
                                        }
                                    }){
                                        Image(systemName: "chevron.right")
                                    }.buttonStyle(CircleNewMorphButtonStyle(foreground: Color.background, paddingValue: 7))
                                }.padding()
                            }
                            
                            Spacer().frame(height : 20)
                            
                            HStack{
                                Text(AES256Util.decrypt(encoded: helper.diaryList[currentIndex].title))
                                    .font(.custom("KoreanKPNB-R", size: 24))
                                    .foregroundStyle(Color.txt)
                                
                                Spacer()
                                
                                Text(self.getCodeByEmotion(code: helper.diaryList[currentIndex].emotion))
                                    .font(.custom("KoreanKPNB-R", size: 18))
                                    .foregroundStyle(Color.txt)
                            }
                            
                            Spacer().frame(height : 20)
                            
                            HStack{
                                Text(AES256Util.decrypt(encoded: helper.diaryList[currentIndex].contents))
                                    .font(.custom("KoreanKPNB-R", size: 20))
                                    .foregroundStyle(Color.txt)
                                
                                Spacer()
                            }
                            
                            if helper.diaryList[currentIndex].imgCount > 0{
                                Spacer().frame(height : 20)
                                
                                ScrollView(.horizontal){
                                    HStack(spacing: 10){
                                        ForEach(helper.urlList, id: \.self){url in
                                            AsyncImage(url: url!){ image in
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width : 150, height : 150)
                                            } placeholder: {
                                                DotProgressView()
                                            }
                                        }
                                    }
                                }
                            }
                            
                            Spacer()
                        }
                    }
                }
            }.padding(20).onAppear{
                helper.getDiaryList(){ result in
                    guard let result = result else{return}
                    
                    if result{
                        showProgress = false
                        
                        if helper.diaryList.count > 0{
                            helper.getURL(id: helper.diaryList[0].date, imgCount: helper.diaryList[0].imgCount){ downloadResult in
                                guard let downloadResult = downloadResult else{return}
                            }
                        }

                    } else{
                        showProgress = false
                        showError = true
                    }
                }
            }
            .navigationTitle(Text("Daily Diary"))
            .toolbar(content: {
                ToolbarItemGroup(placement: .topBarTrailing, content: {
                    if helper.diaryList.count > 0{
                        Button(action: {}){
                            Image(systemName : "trash.fill")
                                .foregroundStyle(Color.red)
                        }
                    }
                    
                    Button(action: {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy. MM. dd."
                        
                        if helper.diaryList.contains(where: {$0.date == dateFormatter.string(from: Date())}){
                            self.showAlert = true
                        } else{
                            self.showModal = true
                        }
                    }){
                        Image(systemName: "pencil")
                    }
                })

            })
            .sheet(isPresented: $showModal, content: {
                WriteDiaryMainView()
            })
            .alert(isPresented: $showAlert, content: {
                return Alert(title: Text("Warning"), message: Text("The daily diary is designed to record the user's daily mental state once a day.\nIt is assumed that the user has already recorded today's diary. If you proceed, today's diary will be removed and replaced with a new one.\nDo you want to continue?"), primaryButton: .default(Text("Yes")){
                    self.showModal = true
                }, secondaryButton: .default(Text("No")))
                
            })
        }
    }
}

#Preview {
    DiaryView()
}
