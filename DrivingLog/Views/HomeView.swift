//
//  HomeView.swift
//  DrivingLog
//
//  Created by Alex Luke on 3/3/22.
//

import SwiftUI

struct HomeView: View {
    
    //Initializing the variables needed for the Home View
    @State var profileName = ""
    @State var navigateToProgressView = false
    @State var showNewProfileSheet = false
    
    //Initializing UI design colors
    init() {
        Theme.navigationBarColors(background: UIColor(named: "appBackgroundColor"),
                                  titleColor: UIColor(named: "primaryTextColor"),
                                  tintColor: UIColor(named: "appAccentColor"))
        UITableView.appearance().backgroundColor = .clear
        UITableView.appearance().tintColor = UIColor(named: "appAccentColor")
    }
    
    //This represents what the user will see when they first launch the app
    var body: some View {
        NavigationView {
            ZStack {
                Theme.appBackgroundColor
                    .ignoresSafeArea()
                VStack {
                    
                    Spacer()
                    
                    //App title
                    Text("Indiana Student Driving Tracker")
                        .font(.title2)
                        .bold()
                    
                    //App logo, instead of just a blank, boring template
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
                }
                
                //More UI design, using the colors initialized earlier
                .navigationTitle("ISDT")
                .foregroundColor(Theme.primaryTextColor)
                .sheet(isPresented: $showNewProfileSheet, onDismiss: onProfileNameSaved, content: {
                    AddProfileView(newProfileName: $profileName)
                })
                .onAppear {
                    profileName = ""
                }
                .background(
                    Theme.appBackgroundColor
                        .ignoresSafeArea()
                )
            }
            .accentColor(Theme.accentColor)
        }
        
    }
    
    /// This function allows for the user to navigate to the progress view IF there is a profile name.
    func onProfileNameSaved() {
        guard profileName != "" else {
            return
        }
        navigateToProgressView.toggle()
    }
    
    /// This function allows for the user to navigate to the new profile sheet IF there is not already a profile name.
    func onNewProfileTapped() {
        showNewProfileSheet.toggle()
    }
    
    /// This function returns an alert IF the user attempts to create a profile with no name.
    /// - Returns: An alert saying that the user needs to input a name.
    func noProfileNameAlert() -> Alert {
        return Alert(
            title: Text(""),
            message: Text(StringConstants.logNameMessage),
            dismissButton: .default(Text("OK"))
        )
    }
}

//This works to produce a view preview of the home view in the Xcode IDE
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}



