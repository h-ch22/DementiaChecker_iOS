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

extension CLLocationCoordinate2D{
    func distance(from: CLLocationCoordinate2D) -> CLLocationDistance{
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: self.latitude, longitude: self.longitude)
        
        return from.distance(from: to)
    }
}

extension LinearGradient {
    init(_ colors: Color...) {
        self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

extension Array{
    func chunked(into size: Int) -> [[Element]]{
        return stride(from: 0, to: count, by: size).map{
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

extension View {
    public func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        
        controller.view.backgroundColor = .clear
        
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)
        
        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()
        
        let image = controller.view.asUIImage()
        controller.view.removeFromSuperview()
        return image
    }
}

extension UIView {
    public func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

extension UIImage {
    func resize(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale

        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }

        return renderImage
    }
    
    func resized(to newSize: CGSize, scale: CGFloat = 1) -> UIImage {
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = scale
        let renderer = UIGraphicsImageRenderer(size: newSize, format: format)
        let image = renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: newSize))
        }
        return image
    }
}

extension Date{
    public var year: Int{
        return Calendar.current.component(.year, from: self)
    }
    
    public var month: Int{
        return Calendar.current.component(.month, from: self)
    }
    
    public var day: Int{
        return Calendar.current.component(.day, from: self)
    }
    
    public var weekDay: Int{
        return Calendar.current.component(.weekday, from: self)
    }
    
    public func codeToWeekDay(code: Int) -> String{
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
}
