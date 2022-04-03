//
//  Theme.swift
//  DrivingLog
//
//  Created by Alex Luke on 4/3/22.
//

import Foundation
import UIKit
import SwiftUI

class Theme {
    
    static var appBackgroundColor = Color("appBackgroundColor")
    static var secondaryBackgroundColor = Color("secondaryBackgroundColor")
    static var textfieldBackgroundColor = Color("textfieldBackgroundColor")
    static var accentColor = Color("appAccentColor")
    static var primaryTextColor = Color("primaryTextColor")
    static var buttonTextColor = Color("buttonTextColor")
    static var dayColor1 = Color("dayColor1")
    static var dayColor2 = Color("dayColor2")
    static var nightColor1 = Color("nightColor1")
    static var nightColor2 = Color("nightColor2")
    
    static func navigationBarColors(background : UIColor?,
       titleColor : UIColor? = nil, tintColor : UIColor? = nil ){
        
        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.configureWithOpaqueBackground()
        navigationAppearance.backgroundColor = background ?? .clear
        
        navigationAppearance.titleTextAttributes = [.foregroundColor: titleColor ?? .black]
        navigationAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor ?? .black]
       
        UINavigationBar.appearance().standardAppearance = navigationAppearance
        UINavigationBar.appearance().compactAppearance = navigationAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationAppearance

        UINavigationBar.appearance().tintColor = tintColor ?? titleColor ?? .black
    }
    
    
    
}
