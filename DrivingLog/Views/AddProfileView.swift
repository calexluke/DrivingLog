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
            
            //Text for the screen
            Text("Add New Profile")
                .foregroundColor(Theme.primaryTextColor)
                .font(.title)
                .bold()
                .padding()
            
            //Text box for a user to enter their name
            TextField(StringConstants.profileHint, text: $newProfileName)
                .modifier(TextFieldModifer())
                .padding([.leading, .trailing])

            Spacer()
            
            //clicking this button saves the profile temporarily
            Button("Continue") {
                saveProfileName()
            }
            //gives an alert to the user if there is an error
            .alert(isPresented: $profileNameError) {
                Alert(
                    title: Text(""),
                    message: Text(StringConstants.logNameMessage),
                    dismissButton: .default(Text("OK"))
                    )
            }
            .modifier(ButtonModifier())
            .padding(.bottom)
            
            //button that cancels profile creation
            Button("Cancel") {
                newProfileName = ""
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
    
    /*This function saves the profile to the 
    app.*/
    func saveProfileName() {
        //checks if there is an error in the name
        guard newProfileName != "" else {
            profileNameError = true
            return
        }
        presentationMode.wrappedValue.dismiss()
    }
}
