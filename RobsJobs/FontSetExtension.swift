////
////  FontSetExtension.swift
////  RobsJobs
////
////  Created by MacBook on 6/8/17.
////  Copyright © 2017 MacBook. All rights reserved.
////
//
//import Foundation
//import UIKit
//import CoreFoundation
//import CoreData
//
//extension UIFont {
//    
//    struct AppFontName {
//        static let regular = "Roboto-Regular"
//        static let bold = "Roboto-Bold"
//        static let italic = "roboto-Italic"
//        static let heavy = "Roboto-Black"
//        static let demiBold = "roboto-DemiBoldMT"
//    }
//    
//    convenience init(myCoder aDecoder: NSCoder) {
//        if let fontDescriptor = aDecoder.decodeObject(forKey: "UIFontDescriptor") as? UIFontDescriptor {
//            if let fontAttribute = fontDescriptor.fontAttributes["NSCTFontUIUsageAttribute"] as? String {
//                var fontName = ""
//                switch fontAttribute {
//                case "CTFontRegularUsage":
//                    fontName = AppFontName.regular
//                case "CTFontEmphasizedUsage", "CTFontBoldUsage":
//                    fontName = AppFontName.bold
//                case "CTFontObliqueUsage":
//                    fontName = AppFontName.italic
//                case "CTFontHeavyUsage":
//                    fontName = AppFontName.heavy
//                case "CTFontDemiUsage":
//                    fontName = AppFontName.demiBold
//                default:
//                    print(fontAttribute)
//                    fontName = AppFontName.regular
//                }
//                
//                let descriptor = UIFontDescriptor(name: fontName, size: fontDescriptor.pointSize)
//                self.init(descriptor: descriptor, size: fontDescriptor.pointSize)
//            }
//            else {
//                self.init(myCoder: aDecoder)
//            }
//        }
//        else {
//            self.init(myCoder: aDecoder)
//        }
//    }
//    
//    class func mySystemFont(ofSize size: CGFloat) -> UIFont {
//        let fontDescriptor = UIFontDescriptor(name: AppFontName.regular, size: size)
//        return UIFont(descriptor: fontDescriptor, size: size)
//    }
//    
//     class func myBoldSystemFont(ofSize size: CGFloat) -> UIFont {
//        let fontDescriptor = UIFontDescriptor(name: AppFontName.bold, size: size)
//        return UIFont(descriptor: fontDescriptor, size: size)
//    }
//    
//     class func myItalicSystemFont(ofSize size: CGFloat) -> UIFont {
//        let fontDescriptor = UIFontDescriptor(name: AppFontName.italic, size: size)
//        return UIFont(descriptor: fontDescriptor, size: size)
//    }
//    
//    class func overrideInitialize() {
//        if self == UIFont.self {
//            let systemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:)))
//            let mySystemFontMethod = class_getClassMethod(self, #selector(mySystemFont(ofSize:)))
//            method_exchangeImplementations(systemFontMethod, mySystemFontMethod)
//            
//            let boldSystemFontMethod = class_getClassMethod(self, #selector(boldSystemFont(ofSize:)))
//            let myBoldSystemFontMethod = class_getClassMethod(self, #selector(myBoldSystemFont(ofSize:)))
//            method_exchangeImplementations(boldSystemFontMethod, myBoldSystemFontMethod)
//            
//            let italicSystemFontMethod = class_getClassMethod(self, #selector(italicSystemFont(ofSize:)))
//            let myItalicSystemFontMethod = class_getClassMethod(self, #selector(myItalicSystemFont(ofSize:)))
//            method_exchangeImplementations(italicSystemFontMethod, myItalicSystemFontMethod)
//            
//            let initCoderMethod = class_getInstanceMethod(self, #selector(UIFontDescriptor.init(coder:))) // Trick to get over the lack of UIFont.init(coder:))
//            let myInitCoderMethod = class_getInstanceMethod(self, #selector(UIFont.init(myCoder:)))
//            method_exchangeImplementations(initCoderMethod, myInitCoderMethod)
//        }
//    }
//}
