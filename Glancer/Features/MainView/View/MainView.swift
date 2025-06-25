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
    @EnvironmentObject private var eventKitStore: EventKitStore
    @Environment(\.requestReview) private var requestReview
    
    @ObservedObject var viewModel: MainViewModel
    
    @FocusState var isInputActive: Bool
    
    @State var showCompletionStateView = false
    @State var clearTextFieldRequested = false
    @State var showSettingsView = false
    @State var showTutorialView = !AppSettings.isTutorialViewed()
    @State var showCustomizationView = false
    @State var showCardDeleteConfirmation = false
    @State var showSubscriptionView = false
    @State var showRemindersView = false
    @State var showNewFeatureTutorialView = !AppSettings.isNewFeatureViewed()
    @State var showInAppEventView = false
    
    @StateObject var page: Page = .first()
    
    @State var maxAllowedCardsNumber = 2
    @State private var cardsImages: [Int: UIImage] = [:]
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
                      content: { currentTopicCard in
                    VStack {
                        withAnimation {
                            CardsPreviewView(cardImage: generateCardImage(topicCard: currentTopicCard, pageIndex: viewModel.topicCards.firstIndex(of: currentTopicCard) ?? page.index, override: false))
                                .onTapGesture {
                                    AnalyticsManager.customizationViewOpened()
                                    SOCManager.present(isPresented: $showCustomizationView) {
                                        CustomizationView(viewModel: viewModel)
                                            .environmentObject(store)
                                    }
                                }
                                .padding(.top)
                        }
                        Spacer()
                        TextField("Type your text here", text: $viewModel.topicCards[viewModel.topicCards.firstIndex(of: currentTopicCard) ?? page.index].cardDefinition, axis: .vertical)
                            .lineLimit(2, reservesSpace: true)
                            .padding(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                            .focused($isInputActive)
                            .padding([.leading, .trailing], 1)
                    }
                    .onChange(of: viewModel.topicCards[page.index]) { _, value in
                        _ = generateCardImage(topicCard: value, pageIndex: page.index)
                    }
                })
                .swipeInteractionArea(.allAvailable)
                .itemSpacing(10)
                .onPageWillChange({ pageNumber in
                    isInputActive = false
                })
                .onPageChanged({pageNumber in
                    viewModel.currentPageIndex = pageNumber
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
                        AnalyticsManager.manageWatchfacesTapped()
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
                                    AnalyticsManager.cardRemoved(cardsNumber: viewModel.topicCards.count)
                                }
                            }
                        }
                        Text("\(viewModel.topicCards.count)/\(store.isPaidSubscription ? maxCardsNumberPerAlbum : maxAllowedCardsNumber)")
                            .foregroundColor(Color(.systemOrange))
                        Button(action: {
                            if !store.isPaidSubscription {
                                showSubscriptionView = true
                            } else {
                                AnalyticsManager.selectRemindersViewOpened()
                                showRemindersView = true
                            }
                        }, label: { Image(systemName: "calendar.badge.plus")
                        })
                    },
                trailing:
                    HStack {
                        Button(action: {
                            if (!store.isPaidSubscription && viewModel.topicCards.count == maxAllowedCardsNumber) {
                                showSubscriptionView = true
                            } else {
                                addNewCard()
                            }
                        }, label: { Image(systemName: "plus")
                        })
                        .disabled(viewModel.topicCards.count == maxCardsNumberPerAlbum)
                        Button(action: {showSettingsView = true}, label: { Image(systemName: "gear")
                        })
                        if isInputActive {
                            Button(action: {isInputActive = false}, label: { Text("Done") })
                        }
                    }
            )
            .disabled(showCustomizationView)
            .onChange(of: viewModel.watchFaceState) {  _, value in
                if (viewModel.watchFaceState == .created || viewModel.watchFaceState == .failed) {
                    showCompletionStateView = true
                }
            }
            .onChange(of: viewModel.topicCards.count) {  _, value in
                withAnimation {
                    if viewModel.previousCardsNumber < viewModel.topicCards.count {
                        page.update(.moveToLast)
                    }
                }
                isInputActive = false
            }
            .onChange(of: viewModel.clearImagesCache) {  _, _ in
                cardsImages.removeAll()
            }
            .onChange(of: showTutorialView) {  _, value in
                if !value {
                    presentReviewRequest()
                }
            }
            .onOpenURL {url in
                handleInAppEventURL(url: url)
            }
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
            .sheet(isPresented: $showRemindersView) {
                RemindersView(viewModel: RemindersViewModel(eventStore: eventKitStore)) { selectedReminders in
                    if !selectedReminders.isEmpty {
                        viewModel.topicCards[viewModel.currentPageIndex].cardDefinition = formatRemindersText(reminders: selectedReminders)
                    }
                }
            }
            .sheet(isPresented: $showNewFeatureTutorialView) {
                ImagePlaygroundTutorialView(isShowing: $showNewFeatureTutorialView)
            }
            .sheet(isPresented: $showInAppEventView) {
                InAppEventView(isShowing: $showInAppEventView)
            }
            .accentColor(Color(.systemOrange))
        }
    }
    
    private func launchWatchApp() {
        var url = URL(string: "itms-watchs://bridge:root=GENERAL_LINK")
        if #available(iOS 17, *) {
            url = URL(string: "itms-watchs://")
        }
        if let url = url {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    private func generateCardImage(topicCard: TopicCard, pageIndex: Int, override: Bool = true) -> UIImage {
        if override == false, let cardImage = cardsImages[pageIndex] {
            return cardImage
        } else {
            let backgroundImage = topicCard.background.contains("/") ? UIImage(contentsOfFile: topicCard.background) : UIImage(named: topicCard.background)
            let cardImage = backgroundImage?.waterMarkedImage(text: topicCard.cardDefinition.isEmpty ? "Tap on this preview to customize appearance" : topicCard.cardDefinition, color: topicCard.fontColor, font: topicCard.completeFontName(), overlay: topicCard.overlay, textOnTop: topicCard.textOnTop) ?? UIImage()
            cardsImages[pageIndex] = cardImage
            return cardImage
        }
    }
    
    private func presentReviewRequest() {
        guard let currentAppVersion = Bundle.currentAppVersion else {
            return
        }
        if currentAppVersion != AppSettings.getLastVersionReviewRequested() {
            Task {
                // Delay for two seconds to avoid interrupting the person using the app.
                try await Task.sleep(for: .seconds(2))
                requestReview()
                AnalyticsManager.reviewRequestShown()
            }
            AppSettings.setLastVersionReviewRequested(updatedVersionReviewRequested: currentAppVersion)
        }
    }
    
    private func addNewCard() {
        viewModel.currentPageIndex = viewModel.topicCards.count
        viewModel.previousCardsNumber = viewModel.topicCards.count
        viewModel.topicCards.append(TopicCard())
        AnalyticsManager.cardAdded(cardsNumber: viewModel.topicCards.count)
    }
    
    private func formatRemindersText(reminders: [Reminder]) -> String {
        var formattedText = ""
        for i in 0..<reminders.count {
            formattedText.append("\u{2022}\(reminders[i].title)" + (i == reminders.count - 1 ? "" : "\n"))
        }
        
        return formattedText
    }
    
    private func handleInAppEventURL(url: URL) {
        switch url.host {
        case "event":
            showInAppEventView = true
        default:
            break
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewModel(shareWatchFaceService: ShareWatchfaceWorker(), watchFaceCustomizationService: WatchFaceCustomizationWorker()))
            .accentColor(Color(.systemOrange))
    }
}
