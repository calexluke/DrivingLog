//
//  HomeView.swift
//  DrivingLog
//
//  Created by Alex Luke on 3/3/22.
//

import SwiftUI

struct HomeView: View {
    
    @State var profileName = ""
    @State var nameAlertIsPresented = false
    @State var navigateToProgressView = false
    
    var body: some View {
        NavigationView {
            VStack {
                
                Spacer()
                
                Text("Indiana Student Driving Tracker")
                    .font(.title2)
                Image("ISDTLogo")
                    .resizable()
                    .scaledToFit()
                    .padding()
                
                Spacer()
                
                // navigate to choose profile screen
                NavigationLink(
                    destination: ChooseLogView(),
                    label: {
                        Text("Open A Saved Profile")
                            .modifier(ButtonModifier())
                    })
                    .padding(.bottom)
                
                // navigate to ProgressView with new DrivingLog object
                NavigationLink(
                    destination: ProgressView(drivingLog: DrivingLog(name: profileName)),
                    isActive: $navigateToProgressView,
                    label: {
                        Button("Start New Profile") {
                            onNewProfileTapped()
                        }
                        .modifier(ButtonModifier())
                    })
                    .padding(.bottom)
                    .alert(isPresented: $nameAlertIsPresented) {
                        noProfileNameAlert()
                    }
                
                HStack(alignment: .center) {
                    Text("Profile name: ")
                        .font(.title)
                        .padding(.leading)
                    
                    TextField(StringConstants.profileHint, text: $profileName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.trailing)
                }
                .padding(.bottom)
            }
            .navigationTitle("ISDT")
            .onAppear {
                profileName = ""
            }
        }
    }
    
    func onNewProfileTapped() {
        guard profileName != "" else {
            nameAlertIsPresented.toggle()
            return
        }
        navigateToProgressView.toggle()
    }
    
    func noProfileNameAlert() -> Alert {
        return Alert(
            title: Text(""),
            message: Text(StringConstants.logNameMessage),
            dismissButton: .default(Text("OK"))
        )
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}



