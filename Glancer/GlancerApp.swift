//
//  GlancerApp.swift
//  Glancer
//
//  Created by Alexander Golikov on 3/12/23.
//

import SwiftUI

@main
struct GlancerApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @Environment(\.scenePhase) private var scenePhase
    
    @StateObject private var store = Store()
    
    let viewModel = MainViewModel(shareWatchFaceService: ShareWatchfaceWorker(), watchFaceCustomizationService: WatchFaceCustomizationWorker())
    
    init() {
        Logger.configure()
        Logger.info("Logging configured")
    }
    
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: viewModel)
                .environmentObject(store)
                .task(id: scenePhase) {
                    if scenePhase == .active {
                        await store.fetchActiveTransactions()
                    }
                }
        }
    }
}
