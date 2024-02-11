//
//  PuzzleView.swift
//  DementiaChecker
//
//  Created by 하창진 on 2/11/24.
//

import SwiftUI
import SwiftImage
import PhotosUI

struct PuzzleView: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var showPhotoPicker = false
    @State private var data = Self.initialData
    @State private var imageParts: [[UIImage]] = [[]]
    @State private var showPuzzles = false
    
    @ViewBuilder
    func cell(_ dataCoord: Coord) -> some View{
        if let imageCoord = getData(at: dataCoord){
            Image(uiImage: imageParts[imageCoord.x][imageCoord.y])
                .resizable()
                .onTapGesture{
                    let freeCoord = freeCoord
                    
                    switch(abs(freeCoord.x - dataCoord.x), abs(freeCoord.y - dataCoord.y)){
                    case (1, 0), (0, 1):
                        withAnimation{
                            swap(dataCoord, freeCoord)
                        }
                        
                    default: break
                    }
                }
        }
    }
    
    var body: some View {
        ZStack{
            Color.background.ignoresSafeArea(.all, edges: [.top, .bottom])
            
            VStack{
                if !showPuzzles{
                    Image(systemName: "puzzlepiece.extension.fill")
                        .foregroundStyle(Color.gray)
                    
                    Spacer().frame(height: 10)
                    
                    Text("이미지 불러오기")
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.gray)
                    
                    Text("계속 하려면 퍼즐에 사용할 이미지를 불러오십시오.")
                        .font(.caption)
                        .foregroundStyle(Color.gray)
                    
                    Spacer().frame(height: 20)
                    
                    if selectedItem == nil{
                        Button(action: {
                            showPhotoPicker = true
                        }){
                            HStack{
                                Image(systemName: "plus")
                                Text("이미지 불러오기")
                            }
                        }.buttonStyle(NewMorphButtonStyle(foreground: Color.background))
                    } else{
                        DotProgressView()
                    }
                    
                } else{
                    VStack(spacing: Consts.rowsSpacing){
                        ForEach(0..<Consts.rows){ y in
                            HStack(spacing: Consts.columnsSpacing){
                                ForEach(0..<Consts.columns){ x in
                                    cell(.init(x, y))
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                }
                            }
                        }
                    }.navigationTitle(Text("퍼즐"))
                        .toolbar{
                            HStack{
                                Button(action: {
                                    selectedItem = nil
                                    showPhotoPicker = true
                                    showPuzzles = false
                                }){
                                    Image(systemName: "photo.fill")
                                }
                                
                                Button(action: { data = shuffledData }){
                                    Image(systemName: "shuffle.circle.fill")
                                }
                                
                                Button(action: { data = Self.initialData }){
                                    Image(systemName: "checkmark.circle.fill")
                                }
                            }
                        }
                }
            }.photosPicker(isPresented: $showPhotoPicker, selection: $selectedItem, matching: .images, photoLibrary: .shared())
                .onChange(of: selectedItem){ newItem in
                    DispatchQueue.global(qos: .background).async{
                        Task{
                            if let data = try? await newItem?.loadTransferable(type: Data.self){
                                let pic = SwiftImage.Image<RGBA<UInt8>>(data: data)!
                                let picAsUIImage = UIImage(data: data)!
                                var img: [[UIImage]] = []
                                
                                for x in 0..<Consts.columns {
                                    img.append([])
                                    
                                    for y in 0..<Consts.rows{
                                        let widthPart = pic.width / Consts.columns
                                        let heightPart = pic.height / Consts.rows
                                        
                                        let slice = SwiftImage.Image<RGBA<UInt8>>(
                                            pic[(widthPart * x) ..< (widthPart * (x + 1)),
                                                (heightPart * y) ..< (heightPart * (y + 1))]
                                        ).uiImage
                                        
                                        img[x].append(slice)
                                    }
                                }
                                
                                imageParts = img
                                
                                showPuzzles = true
                            }
                        }
                    }

                }
        }
    }
}

#Preview {
    PuzzleView()
}

private extension PuzzleView{
    static var initialData: [[Coord?]] {
        var dat = [[Coord?]]()
        
        for x in 0..<Consts.columns{
            dat.append(.init())
            
            for y in 0..<Consts.rows{
                dat[x].append(.init(x, y))
            }
        }
        
        dat[dat.count - 1][dat.last!.count - 1] = nil
        
        return dat
    }
    
    var shuffledData: [[Coord?]] {
        data.reduce([Coord?](), +).shuffled().chunked(into: Consts.rows)
    }
    
    func getData(at coord: Coord) -> Coord?{
        guard 0..<Consts.rows ~= coord.y, 0..<Consts.columns ~= coord.x else{ return nil }
        
        return data[coord.x][coord.y]
    }
    
    func updateData(at coord: Coord, _ newValue: Coord?) {
        guard 0..<Consts.rows ~= coord.y, 0..<Consts.columns ~= coord.x else { return }
        data[coord.x][coord.y] = newValue
    }
    
    func swap(_ lhs: Coord, _ rhs: Coord) {
        let val = getData(at: lhs)
        data[lhs.x][lhs.y] = getData(at: rhs)
        data[rhs.x][rhs.y] = val
    }
    
    var freeCoord: Coord {
        for x in 0..<Consts.columns {
            for y in 0..<Consts.rows {
                if data[x][y] == nil {
                    return .init(x, y)
                }
            }
        }
        
        fatalError()
    }
}
