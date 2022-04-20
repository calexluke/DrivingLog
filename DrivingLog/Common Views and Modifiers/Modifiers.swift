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
            .foregroundColor(Theme.buttonTextColor)
            .background(Theme.accentColor)
            .clipShape(Capsule())
            .contentShape(Capsule())
    }
}

struct TextFieldModifer: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(height: 30)
            .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
            .background(Theme.textfieldBackgroundColor)
            .cornerRadius(5)
            .accentColor(Theme.accentColor)
            .foregroundColor(Theme.primaryTextColor)
    }
}
