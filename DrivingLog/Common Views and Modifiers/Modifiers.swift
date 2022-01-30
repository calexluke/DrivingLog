//
//  Modifiers.swift
//  DrivingLog
//
//  Created by Alex Luke on 1/30/22.
//

// create re-useable view components and view modifiers in this file

import Foundation
import SwiftUI

struct ButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: FloatConstants.buttonWidth, height: FloatConstants.buttonHeight, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .font(.title3)
            .foregroundColor(.white)
            .background(Color.purple)
            .clipShape(Capsule())
            
    }
}
