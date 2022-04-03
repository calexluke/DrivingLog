//
//  HomeView.swift
//  DrivingLog
//
//  Created by Alex Luke on 3/3/22.
//

import SwiftUI

struct HomeView: View {
    
    @State var profileName = ""
    @State var navigateToProgressView = false
    @State var showNewProfileSheet = false
    
    init() {
        Theme.navigationBarColors(background: UIColor(named: "appBackgroundColor"),
                                  titleColor: UIColor(named: "primaryTextColor"),
                                  tintColor: UIColor(named: "accentColor"))
        UITableView.appearance().backgroundColor = .clear
        UITableView.appearance().tintColor = UIColor(named: "accentColor")
    }
    
    var body: some View {
            NavigationView {
                VStack {
                    
                    Spacer()
                    
                    Text("Indiana Student Driving Tracker")
                        .font(.title2)
                        .bold()
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
    
    func onProfileNameSaved() {
        guard profileName != "" else {
            return
        }
        navigateToProgressView.toggle()
    }
    
    func onNewProfileTapped() {
        showNewProfileSheet.toggle()
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



