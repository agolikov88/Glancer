//
//  ContentView.swift
//  Glancer
//
//  Created by Alexander Golikov on 3/12/23.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var viewModel: MainViewModel
    
    @FocusState var isInputActive: Bool
    
    @State var showCompletionStateView = false
    @State var clearTextFieldRequested = false
    @State var showSettingsView = false
    @State var showTutorialView = !AppSettings.isTutorialViewed()
    @State var showCustomizationView = false
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack {
                CardsPreviewView(topic: Topic(), topicCards: [viewModel.topicCard], currentBackgroundIndex: 0)
                    .onTapGesture {
                        SOCManager.present(isPresented: $showCustomizationView) {
                            CustomizationView(viewModel: viewModel)
                        }
                    }
                    .padding(.top)
                Spacer()
                TextField("Type your text here", text: $viewModel.cardText, axis: .vertical)
                    .lineLimit(2, reservesSpace: true)
                    .padding(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                    .focused($isInputActive)
                    .padding(.bottom)
                if !isInputActive {
                    Button(action: {
                        viewModel.addWatchFace()
                    }) {
                        if viewModel.watchFaceState == .generating {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.buttonBackgroundOrange)
                                .cornerRadius(16)
                        } else {
                            Text("Send to Watch")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.buttonBackgroundOrange)
                                .cornerRadius(16)
                                .foregroundColor(.white)
                        }
                    }
                    .disabled(viewModel.watchFaceState == .generating)
                    .padding(.bottom)
                    Button(action: {
                        launchWatchApp()
                    }) {
                        Text("Manage Watch Faces")
                            .fontWeight(.bold)
                    }
                }
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Glancer").font(.custom("Cookie-Regular", size: 36))
                }
            }
            .navigationBarItems(
                trailing:
                    HStack {
                        Button(action: {showSettingsView = true}, label: { Image(systemName: "info.circle")
                        })
                        if isInputActive {
                            Button(action: {isInputActive = false}, label: { Text("Done") })
                        }
                    }
            )
            .onChange(of: viewModel.watchFaceState, perform: { value in
                if (viewModel.watchFaceState == .created || viewModel.watchFaceState == .failed) {
                    showCompletionStateView = true
                }
            })
            .sheet(isPresented: $showCompletionStateView) {
                CompletionStateView(isShowing: $showCompletionStateView, textField: $viewModel.cardText, succesful: viewModel.watchFaceState == .created)
            }
            .sheet(isPresented: $showSettingsView) {
                SettingsView()
            }
            .sheet(isPresented: $showTutorialView) {
                TutorialView(isShowing: $showTutorialView)
            }
            .accentColor(Color(.systemOrange))
        }
    }
    
    private func launchWatchApp() {
        if let url = URL(string: "itms-watchs://bridge:root=GENERAL_LINK") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewModel(shareWatchFaceService: ShareWatchfaceWorker(), watchFaceCustomizationService: WatchFaceCustomizationWorker()))
            .accentColor(Color(.systemOrange))
    }
}
