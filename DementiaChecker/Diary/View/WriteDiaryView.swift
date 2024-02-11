//
//  WriteDiaryView.swift
//  DementiaChecker
//
//  Created by 하창진 on 2/11/24.
//

import SwiftUI
import PhotosUI

struct WriteDiaryView: View {
    @StateObject private var helper = DiaryHelper()
    
    @State private var emotion: DiaryEmotionModel? = nil
    @State private var year = ""
    @State private var month = ""
    @State private var dayOfMonth = ""
    @State private var weekDay = ""
    @State private var title = ""
    @State private var contents = ""
    @State private var emotions = ["🥰 행복해요", "😆 최고예요", "😀 좋아요", "🙂 그저그래요", "☹️ 안좋아요", "😢 슬퍼요", "😣 혼자있고싶어요", "😡 화나요"]
    @State private var selectedIndex = 0
    @State private var showActionSheet = false
    @State private var selectedPhotos : [PhotosPickerItem] = []
    @State private var imageData : [UIImage] = []
    @State private var markUpData: [UIImage] = []
    @State private var photoData: [UIImage] = []
    @State private var showCamera = false
    @State private var showPhotosPicker = false
    @State private var showMarkUp = false
    @State private var showProgress = false
    @State private var showAlert = false
    @State private var isError = false
    
    @Environment(\.dismiss) var dismiss
    
    private func codeToWeekDay(code: Int) -> String{
        switch code{
        case 1:
            return "일"
            
        case 2:
            return "월"
            
        case 3:
            return "화"
            
        case 4:
            return "수"
            
        case 5:
            return "목"
            
        case 6:
            return "금"
            
        case 7:
            return "토"
            
        default:
            return ""
        }
    }
    
    var body: some View {
        NavigationView{
            ZStack{
                Color.background.ignoresSafeArea(.all, edges: [.top, .bottom])

                ScrollView{
                    VStack{
                        Group{
                            HStack{
                                Spacer()
                                
                                Button(action:{
                                    dismiss()
                                }){
                                    Image(systemName: "xmark")
                                        .foregroundStyle(Color.txt)
                                }.buttonStyle(CircleNewMorphButtonStyle(foreground: Color.background, paddingValue: 7))
                            }
                            HStack{
                                Text(dayOfMonth)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color.txt)
                                
                                VStack(alignment: .leading){
                                    Text("\(year)/\(month)")
                                        .font(.caption)
                                        .foregroundStyle(Color.gray)
                                    
                                    Text("\(weekDay)요일")
                                        .font(.caption)
                                        .foregroundStyle(Color.gray)
                                }
                                
                                Spacer()
                                
                                if UIDevice.current.userInterfaceIdiom == .pad{
                                    ForEach(emotions.indices, id: \.self){ item in
                                        Button(action: {
                                            self.selectedIndex = item
                                        }){
                                            VStack{
                                                Text(emotions[item].split(separator: " ")[0])
                                                Text(emotions[item].split(separator: " ")[1])
                                                    .font(.custom("KoreanKPNB-R", size: 9))
                                                    .foregroundStyle(Color.txt)
                                            }
                                            
                                        }.buttonStyle(NewMorphButtonStyle(foreground: selectedIndex == item ? Color.accentColor : Color.background, paddingValue: 10, cornerRadius: 5))
                                        
                                        Spacer().frame(width: 20)
                                    }
                                } else{
                                    Picker("감정 선택", selection: $selectedIndex){
                                        ForEach(emotions.indices, id: \.self){
                                            Text(emotions[$0])
                                                .font(.custom("KoreanKPNB-R", size: 12))
                                                .foregroundStyle(Color.txt)
                                        }
                                    }.pickerStyle(.menu)
                                }
                            }
                        }
                        
                        TextField("제목", text: $title)
                            .font(.custom("KoreanKPNB-R", size: 15))
                        
                        Spacer().frame(height : 20)
                        
                        TextField("오늘을 기록해보세요.", text: $contents, axis: .vertical)
                            .font(.custom("KoreanKPNB-R", size: 15))
                        
                        if !imageData.isEmpty || !markUpData.isEmpty || !photoData.isEmpty{
                            Spacer().frame(height : 20)
                            
                            ScrollView(.horizontal){
                                HStack(spacing: 5){
                                    ForEach(photoData, id: \.self){photo in
                                        Image(uiImage: photo)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width : 100, height : 100)
                                    }
                                    
                                    ForEach(imageData, id: \.self){image in
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width : 100, height : 100)
                                    }
                                    
                                    ForEach(markUpData, id: \.self){markUp in
                                        Image(uiImage: markUp)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width : 100, height : 100)
                                    }
                                }
                                
                            }
                        }
                        
                        Spacer()
                        
                    }.padding(20)
                        .confirmationDialog("미디어 추가", isPresented: $showActionSheet){
                            Button("사진 촬영"){
                                showCamera = true
                            }
                            Button("사진 선택"){
                                showPhotosPicker = true
                            }
                            
                            Button("마크업"){
                                showMarkUp = true
                            }
                            Button("취소", role: .cancel){
                                self.showActionSheet = false
                            }
                        }
                }.onAppear{
                    let calendar = Calendar.current
                    let components = calendar.dateComponents([.year, .month, .day, .weekday], from: Date())
                    
                    self.year = String(components.year ?? 0)
                    self.month = String(components.month ?? 0)
                    self.dayOfMonth = String(components.day ?? 0)
                    self.weekDay = String(self.codeToWeekDay(code: components.weekday ?? 0))
                }
                .toolbar{
                    ToolbarItemGroup(placement: .bottomBar, content: {
                        Button(action: {
                            showActionSheet = true
                        }){
                            Image(systemName : "photo.on.rectangle.angled")
                        }
                        
                        if !showProgress{
                            Button(action: {
                                if self.title != "" && self.contents != ""{
                                    showProgress = true
                                    
                                    helper.uploadDiary(title: self.title, contents: self.contents, emotionCode: DiaryHelper.indexToEmotion(index: selectedIndex)!, photos: self.photoData, images: self.imageData, markUps: self.markUpData){ result in
                                        guard let result = result else{return}
                                        showProgress = false
                                        isError = !result
                                        showAlert = true
                                    }
                                }

                            }){
                                Text("완료")
                                    .foregroundStyle(self.title != "" && self.contents != "" ? Color.accentColor : Color.gray)
                            }
                        } else{
                            DotProgressView()
                        }

                    })
                }
                
                .photosPicker(isPresented: $showPhotosPicker, selection: $selectedPhotos)
                .onChange(of: selectedPhotos){ items in
                    self.imageData.removeAll()
                    
                    for item in items{
                        item.loadTransferable(type: Data.self){ result in
                            switch result{
                            case .success(let image):
                                if let image{
                                    self.imageData.append(UIImage(data: image)!)
                                } else{
                                    print("No supported content type found.")
                                }
                                
                            case .failure(let error):
                                print(error)
                            }
                        }
                    }
                }
                .fullScreenCover(isPresented: $showMarkUp, content: {
                    DiaryMarkUpView(images: $markUpData)
                })
                .fullScreenCover(isPresented: $showCamera){
                    ImagePicker(sourceType: .camera, selectedImage: self.$photoData)
                }
                .alert(isPresented: $showAlert, content: {
                    if isError{
                        return Alert(title: Text("오류"), message: Text("업로드를 진행하는 중 문제가 발생하였습니다.\n정상 로그인 여부, 네트워크 상태를 확인하거나 나중에 다시 시도하십시오."), dismissButton: .default(Text("확인")))
                    } else{
                        return Alert(title: Text("업로드 완료"), message: Text("하루일기가 업로드되었어요!"), dismissButton: .default(Text("확인")){
                            self.dismiss()
                        })
                    }
                })
            }
            
            
        }.navigationViewStyle(StackNavigationViewStyle())

        
    }
}

#Preview {
    WriteDiaryView()
}
