//
//  GlancerApp.swift
//  Glancer
//
//  Created by Alexander Golikov on 3/12/23.
//

import SwiftUI
import RevenueCat

@main
struct GlancerApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @Environment(\.scenePhase) private var scenePhase
    
    @StateObject private var store = Store()
    @StateObject private var eventKitStore = EventKitStore()
    
    let viewModel = MainViewModel(shareWatchFaceService: ShareWatchfaceWorker(), watchFaceCustomizationService: WatchFaceCustomizationWorker())
    
    init() {
        Logger.configure()
        Logger.info("Logging configured")
        
        Purchases.logLevel = .debug // For testing only...
        Purchases.configure(withAPIKey: "appl_cQtUGYdPjGsJllVoEIqNtsdoMgj")
    }
    
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: viewModel)
                .environmentObject(store)
                .environmentObject(eventKitStore)
                .task(id: scenePhase) {
                    if scenePhase == .active {
                        await store.fetchActiveTransactions()
                    }
                }
        }
    }
}
