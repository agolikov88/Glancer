//
//  ContentView.swift
//  Glancer
//
//  Created by Alexander Golikov on 3/12/23.
//

import SwiftUI
import SwiftUIPager

struct MainView: View {
    
    @EnvironmentObject private var store: Store
    
    @ObservedObject var viewModel: MainViewModel
    
    @FocusState var isInputActive: Bool
    
    @State var showCompletionStateView = false
    @State var clearTextFieldRequested = false
    @State var showSettingsView = false
    @State var showTutorialView = !AppSettings.isTutorialViewed()
    @State var showCustomizationView = false
    @State var showCardDeleteConfirmation = false
    @State var showSubscriptionView = false
    
    @StateObject var page: Page = .first()
    
    @State var maxAllowedCardsNumber = 2
    private let maxCardsNumberPerAlbum = 24
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Pager(page: page,
                      data: viewModel.topicCards,
                      id: \.id,
                      content: { _ in
                    VStack {
                        CardsPreviewView(topicCard: viewModel.topicCards[page.index], currentBackgroundIndex: 0)
                            .onTapGesture {
                                if store.isPaidSubscription {
                                    SOCManager.present(isPresented: $showCustomizationView) {
                                        CustomizationView(viewModel: viewModel)
                                    }
                                } else {
                                    showSubscriptionView = true
                                }
                            }
                            .padding(.top)
                        Spacer()
                        TextField("Type your text here", text: $viewModel.topicCards[page.index].cardDefinition, axis: .vertical)
                            .lineLimit(2, reservesSpace: true)
                            .padding(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                            .focused($isInputActive)
                            .padding([.leading, .trailing], 1)
                    }
                })
                .swipeInteractionArea(.allAvailable)
                .itemSpacing(10)
                .onPageWillChange({ pageNumber in
                    viewModel.currentPageIndex = pageNumber
                    isInputActive = false
                })
                if !isInputActive {
                    PagerIndicator(currentPage: viewModel.currentPageIndex, pagesNumber: viewModel.topicCards.count)
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
                    Text("Cards").font(.custom("Cookie-Regular", size: 36))
                }
            }
            .navigationBarItems(
                leading:
                    HStack {
                        if viewModel.topicCards.count > 1 {
                            Button(action: {
                                showCardDeleteConfirmation = true
                            }, label: { Image(systemName: "trash")
                            })
                            .confirmationDialog(
                                "Delete this card?",
                                isPresented: $showCardDeleteConfirmation,
                                titleVisibility: .visible
                            ) {
                                Button("Yes", role: .destructive) {
                                    withAnimation {
                                        if viewModel.currentPageIndex == 0 {
                                            page.update(.moveToFirst)
                                        } else {
                                            page.update(.previous)
                                        }
                                    }
                                    viewModel.topicCards.remove(at: viewModel.currentPageIndex)
                                    if viewModel.currentPageIndex > 0 {
                                        viewModel.currentPageIndex -= 1
                                    }
                                    viewModel.previousCardsNumber = viewModel.topicCards.count
                                }
                            }
                        }
                        Text("\(viewModel.topicCards.count)/\(store.isPaidSubscription ? maxCardsNumberPerAlbum : maxAllowedCardsNumber)")
                            .foregroundColor(Color(.systemOrange))
                    },
                trailing:
                    HStack {
                        Button(action: {
                            if (!store.isPaidSubscription && viewModel.topicCards.count == maxAllowedCardsNumber) {
                                showSubscriptionView = true
                            } else {
                                viewModel.currentPageIndex = viewModel.topicCards.count
                                viewModel.previousCardsNumber = viewModel.topicCards.count
                                viewModel.topicCards.append(TopicCard())
                            }
                        }, label: { Image(systemName: "plus")
                        })
                        .disabled(viewModel.topicCards.count == maxCardsNumberPerAlbum)
                        Button(action: {showSettingsView = true}, label: { Image(systemName: "info.circle")
                        })
                        if isInputActive {
                            Button(action: {isInputActive = false}, label: { Text("Done") })
                        }
                    }
            )
            .disabled(showCustomizationView)
            .onChange(of: viewModel.watchFaceState, perform: { value in
                if (viewModel.watchFaceState == .created || viewModel.watchFaceState == .failed) {
                    showCompletionStateView = true
                }
            })
            .onChange(of: viewModel.topicCards.count, perform: { value in
                withAnimation {
                    if viewModel.previousCardsNumber < viewModel.topicCards.count {
                        page.update(.moveToLast)
                    }
                }
                isInputActive = false
            })
            .sheet(isPresented: $showCompletionStateView) {
                CompletionStateView(viewModel: viewModel, isShowing: $showCompletionStateView, succesful: viewModel.watchFaceState == .created)
            }
            .sheet(isPresented: $showSettingsView) {
                SettingsView()
            }
            .sheet(isPresented: $showTutorialView) {
                TutorialView(isShowing: $showTutorialView)
            }
            .sheet(isPresented: $showSubscriptionView) {
                SubscriptionView(isShowing: $showSubscriptionView)
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
