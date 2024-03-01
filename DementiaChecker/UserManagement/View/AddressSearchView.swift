//
//  AddressSearchView.swift
//  DementiaChecker
//
//  Created by Changjin Ha on 2/12/24.
//

import SwiftUI
import WebKit

struct AddressSearchView: UIViewRepresentable{
    var urlToLoad: String = "https://dementiachecker-76d73.web.app/index.html"
    @Environment(\.dismiss) var dismiss
    @Binding var address: String
    
    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: self.urlToLoad) else {
            return WKWebView()
        }
        
        let contentController = WKUserContentController()
        contentController.add(context.coordinator, name: "callBackHandler")
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = contentController

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.load(URLRequest(url: url))
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(address: self.$address, parent: self)
    }
    
    class Coordinator: NSObject, WKScriptMessageHandler{
        @Binding var address: String
        var parent: AddressSearchView
        
        init(address: Binding<String>, parent: AddressSearchView) {
            _address = address
            self.parent = parent
            super.init()
        }
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if let data = message.body as? [String: Any] {
                address = data["roadAddress"] as? String ?? ""
            }
            
            parent.dismiss()
        }
    }
}
