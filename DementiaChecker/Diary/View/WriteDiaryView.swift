//
//  WriteDiaryView.swift
//  DementiaChecker
//
//  Created by Changjin Ha on 11/2/24.
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
    @State private var emotions = ["🥰 Happy", "😆 Excellent", "😀 Good", "🙂 Okay", "☹️ Not Good", "😢 Sad", "😣 Want to be alone", "😡 Angry"]
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
            return "Sun"
            
        case 2:
            return "Mon"
            
        case 3:
            return "Tue"
            
        case 4:
            return "Wed"
            
        case 5:
            return "Thu"
            
        case 6:
            return "Fri"
            
        case 7:
            return "Sat"
            
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
                                    
                                    Text("\(weekDay)")
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
                                    Picker("Select Emotion", selection: $selectedIndex){
                                        ForEach(emotions.indices, id: \.self){
                                            Text(emotions[$0])
                                                .font(.custom("KoreanKPNB-R", size: 12))
                                                .foregroundStyle(Color.txt)
                                        }
                                    }.pickerStyle(.menu)
                                }
                            }
                        }
                        
                        TextField("Title", text: $title)
                            .font(.custom("KoreanKPNB-R", size: 15))
                        
                        Spacer().frame(height : 20)
                        
                        TextField("Write about today.", text: $contents, axis: .vertical)
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
                        .confirmationDialog("Add Media", isPresented: $showActionSheet){
                            Button("Take Photo"){
                                showCamera = true
                            }
                            Button("Select Photo"){
                                showPhotosPicker = true
                            }
                            
                            Button("Markup"){
                                showMarkUp = true
                            }
                            Button("Cancel", role: .cancel){
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
                                Text("Done")
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
                        return Alert(title: Text("Error"), message: Text("There was a problem uploading. Please check your network connection or try again later."), dismissButton: .default(Text("OK")))
                    } else{
                        return Alert(title: Text("Upload Complete"), message: Text("Your diary has been uploaded!"), dismissButton: .default(Text("OK")){
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
