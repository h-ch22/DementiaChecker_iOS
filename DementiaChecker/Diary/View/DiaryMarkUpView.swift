//
//  DiaryMarkUpView.swift
//  DementiaChecker
//
//  Created by Changjin Ha on 2/11/24.
//

import SwiftUI
import PencilKit

struct DiaryMarkUpView: View {
    @State private var canvasView = PKCanvasView()
    @Binding var images: [UIImage]
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView{
            VStack{
                DiaryCanvasView(canvas: $canvasView)
            }.padding(20).toolbar{
                ToolbarItemGroup(placement: .topBarLeading){
                    Button("Cancel"){
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItemGroup(placement: .topBarTrailing){
                    Button("Done"){
                        images.append(canvasView.asUIImage())
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    DiaryMarkUpView(images: .constant([]))
}
