//
//  DementiaCheckerApp.swift
//  DementiaChecker
//
//  Created by Ha Changjin on 1/16/24.
//

import SwiftUI
import FirebaseCore
import NMapsMap

class AppDelegate: NSObject, UIApplicationDelegate{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        NMFAuthManager.shared().clientId = "wg1lmr2uds"
        
        return true
    }
}

@main
struct DementiaCheckerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            SignInView()
        }
    }
}

extension View {
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}
