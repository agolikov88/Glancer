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
    @State var showSubscriptionView = false
    
    var body: some View {
        VStack {
            Text("Settings")
                .font(.system(size: 28, weight: .bold, design: .default))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
            List {
                Section {
                    HStack {
                        Image(systemName: "info.circle")
                            .foregroundColor(Color(.systemOrange))
                        Text("Watch Cards v0.7.3")
                            .foregroundColor(.white)
                    }
                    Button(action: {showSendFeedbackView = true}, label: {
                        HStack {
                            Image(systemName: "envelope")
                                .foregroundColor(Color(.systemOrange))
                            Text("Send feedback")
                        }
                    })
                    .accentColor(.white)
                    .disabled(!MFMailComposeViewController.canSendMail())
                    .sheet(isPresented: $showSendFeedbackView) {
                        SendFeedbackView(isShowing: $showSendFeedbackView, result: $sendFeedbackResult)
                    }
                } header: {
                    Text("About")
                }
                Section {
                    Button(action: {showTutorialView = true}, label: {
                        HStack {
                            Image(systemName: "questionmark.circle")
                                .foregroundColor(Color(.systemOrange))
                            Text("Repeat tutorial")
                        }
                    })
                    .accentColor(.white)
                    Button(action: {
                        if AppSettings.isPaidSubscription() {
                            showSelectAppIconView = true
                        } else {
                            showSubscriptionView = true
                        }
                    }, label: {
                        HStack {
                            Image(systemName: "apps.iphone")
                                .foregroundColor(Color(.systemOrange))
                            Text("Change app icon")
                        }
                    })
                    .accentColor(.white)
                } header: {
                    Text("Additional resources")
                }
                Section {
                    Button(action: {}, label: {
                        HStack {
                            Image(systemName: "dollarsign.circle")
                                .foregroundColor(Color(.systemOrange))
                            Text("Restore purchases")
                        }
                    })
                    .accentColor(.white)
                    Button(action: {
                        
                    }, label: {
                        HStack {
                            Image(systemName: "checkmark.seal")
                                .foregroundColor(Color(.systemOrange))
                            Text("Terms of service")
                        }
                    })
                    .accentColor(.white)
                    Button(action: {
                        
                    }, label: {
                        HStack {
                            Image(systemName: "pencil.circle")
                                .foregroundColor(Color(.systemOrange))
                            Text("Third-party")
                        }
                    })
                    .accentColor(.white)
                } header: {
                    Text("Support")
                }
            }
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
        }
        .alert(isPresented: $showSendFeedbackSuccessAlertDialog) {
            Alert(title: Text(""), message: Text("Feedback sent! Thank you!"), dismissButton: .default(Text("Ok")))
        }
        .sheet(isPresented: $showTutorialView) {
            TutorialView(isShowing: $showTutorialView)
        }
        .sheet(isPresented: $showSelectAppIconView) {
            SelectAppIconView(watchFaceCustomizationService: WatchFaceCustomizationWorker())
        }
        .sheet(isPresented: $showSubscriptionView) {
            SubscriptionView(isShowing: $showSubscriptionView)
        }
        .accentColor(Color(.systemOrange))
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
