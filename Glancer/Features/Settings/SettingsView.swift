//
//  SettingsView.swift
//  WatchCards
//
//  Created by Alexander Golikov on 9/20/21.
//  Copyright © 2021 Alexander Golikov. All rights reserved.
//

import SwiftUI
import MessageUI
import StoreKit

struct SettingsView: View {
    
    @EnvironmentObject private var store: Store
    
    @State var sendFeedbackResult: Result<MFMailComposeResult, MFMailComposeError>? = nil
    @State var showSendFeedbackView = false
    @State var showSendFeedbackSuccessAlertDialog = false
    @State var showSendFeedbackFailureAlertDialog = false
    @State var includeLogs = false
    @State var showTutorialView = false
    @State var showSelectAppIconView = false
    @State var showSubscriptionView = false
    @State var showTermsOfServiceView = false
    @State var showThirdPartyResourcesView = false
    
    init() {
        _includeLogs = State(initialValue: AppSettings.isAttachLogsEnabled())
    }
    
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
                        Text("Watch Cards v1.2")
                            .foregroundColor(.white)
                    }
                    ShareLink(item: URL(string: "https://apps.apple.com/us/app/watch-cards/id6450130685")!) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(Color(.systemOrange))
                            Text("Share with friends")
                                .foregroundColor(.white)
                        }
                    }
                    Button(action: {rateApp()}, label: {
                        HStack {
                            Image(systemName: "star.bubble")
                                .foregroundColor(Color(.systemOrange))
                            Text("How are we doing?")
                        }
                    })
                    .accentColor(.white)
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
                        SendFeedbackView(isShowing: $showSendFeedbackView, attachLogs: includeLogs, result: $sendFeedbackResult)
                    }
                    HStack {
                        Image(systemName: "doc")
                            .foregroundColor(Color(.systemOrange))
                        Toggle("Include logs", isOn: $includeLogs)
                    }
                    .accentColor(.white)
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
                        if store.isPaidSubscription {
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
                    Button(action: {
                        Task {
                            do {
                                try await AppStore.sync()
                            } catch {
                                print(error)
                            }
                        }
                    }, label: {
                        HStack {
                            Image(systemName: "dollarsign.circle")
                                .foregroundColor(Color(.systemOrange))
                            Text("Restore purchases")
                        }
                    })
                    .accentColor(.white)
                    Button(action: {
                        showTermsOfServiceView = true
                    }, label: {
                        HStack {
                            Image(systemName: "checkmark.seal")
                                .foregroundColor(Color(.systemOrange))
                            Text("Terms of service")
                        }
                    })
                    .accentColor(.white)
                    Button(action: {
                        showThirdPartyResourcesView = true
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
            .onChange(of: includeLogs, perform: { value in
                AppSettings.toggleAttachLogs()
            })
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
        .sheet(isPresented: $showTermsOfServiceView) {
            LegalNoticesView(noticeType: .termsOfService)
        }
        .sheet(isPresented: $showThirdPartyResourcesView) {
            LegalNoticesView(noticeType: .thirdParty)
        }
        .accentColor(Color(.systemOrange))
    }
    
    private func rateApp() {
        let url = URL(string: "itms-apps:itunes.apple.com/us/app/apple-store/id6450130685?mt=8&action=write-review")
        if let url = url {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
