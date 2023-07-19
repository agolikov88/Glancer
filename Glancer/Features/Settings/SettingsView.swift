//
//  SettingsView.swift
//  WatchCards
//
//  Created by Alexander Golikov on 9/20/21.
//  Copyright © 2021 Alexander Golikov. All rights reserved.
//

import SwiftUI
import MessageUI

struct SettingsView: View {
    
    @State var sendFeedbackResult: Result<MFMailComposeResult, MFMailComposeError>? = nil
    @State var showSendFeedbackView = false
    @State var showSendFeedbackSuccessAlertDialog = false
    @State var showSendFeedbackFailureAlertDialog = false
    @State var showTutorialView = false
    @State var showSelectAppIconView = false
    
    var body: some View {
        VStack {
            Text("Settings")
                .font(.system(size: 28, weight: .bold, design: .default))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
            List {
                Section {
                    Text("Glancer v0.7")
                        .foregroundColor(.white)
                    Button(action: {showSendFeedbackView = true}, label: { Text("Send feedback")
                    })
                    .accentColor(.white)
                    .disabled(!MFMailComposeViewController.canSendMail())
                    .sheet(isPresented: $showSendFeedbackView) {
                        SendFeedbackView(isShowing: $showSendFeedbackView, result: $sendFeedbackResult)
                    }
                } header: {
                    HStack {
                        Image(systemName: "info.circle")
                        Text("About")
                    }
                }
            }
            .frame(maxHeight: 200)
            .onChange(of: sendFeedbackResult, perform: { value in
                switch value {
                case .success(_):
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showSendFeedbackSuccessAlertDialog = true
                    }
                    break
                case .failure(_):
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showSendFeedbackFailureAlertDialog = true
                    }
                    break
                case .none:
                    break
                }
            })
            .alert(isPresented: $showSendFeedbackFailureAlertDialog) {
                Alert(title: Text(""), message: Text("Error sending feedback email! Please try again"), dismissButton: .default(Text("Ok")))
            }
            Button(action: {
                showTutorialView = true
            }) {
                Text("Repeat tutorial")
                    .fontWeight(.bold)
            }
            // test...
            Button(action: {
                showSelectAppIconView = true
            }) {
                Text("Select alt icon")
                    .fontWeight(.bold)
            }
            Button(action: {
                UIApplication.shared.setAlternateIconName("AppIcon_alt1") { error in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        print("Success!")
                    }
                }
            }) {
                Text("Set alt icon")
                    .fontWeight(.bold)
            }
            Button(action: {
                UIApplication.shared.setAlternateIconName(nil) { error in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        print("Success!")
                    }
                }
            }) {
                Text("Reset alt icon")
                    .fontWeight(.bold)
            }
            Spacer()
        }
        .alert(isPresented: $showSendFeedbackSuccessAlertDialog) {
            Alert(title: Text(""), message: Text("Feedback sent! Thank you!"), dismissButton: .default(Text("Ok")))
        }
        .sheet(isPresented: $showTutorialView) {
            TutorialView(isShowing: $showTutorialView)
        }
        .sheet(isPresented: $showSelectAppIconView) {
            SelectAppIconView()
        }
        .accentColor(Color(.systemOrange))
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
