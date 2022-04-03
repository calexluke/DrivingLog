//
//  AddProfileView.swift
//  DrivingLog
//
//  Created by Alex Luke on 4/3/22.
//

import SwiftUI

struct AddProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var profileNameError = false
    @Binding var newProfileName: String
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Text("Add New Profile")
                .foregroundColor(Theme.primaryTextColor)
                .font(.title)
                .bold()
                .padding()
            
            TextField(StringConstants.profileHint, text: $newProfileName)
                .modifier(TextFieldModifer())
                .padding([.leading, .trailing])

            Spacer()
            
            Button("Continue") {
                saveProfileName()
            }
            .alert(isPresented: $profileNameError) {
                Alert(
                    title: Text(""),
                    message: Text(StringConstants.logNameMessage),
                    dismissButton: .default(Text("OK"))
                    )
            }
            .modifier(ButtonModifier())
            .padding(.bottom)
            
            Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }
            .modifier(ButtonModifier())
            .padding(.bottom)
        }
        .background(
            Theme.appBackgroundColor
                .ignoresSafeArea()
        )
    }
    
    func saveProfileName() {
        guard newProfileName != "" else {
            profileNameError = true
            return
        }
        presentationMode.wrappedValue.dismiss()
    }
}
