//
//  GlancerApp.swift
//  Glancer
//
//  Created by Alexander Golikov on 3/12/23.
//

import SwiftUI

@main
struct GlancerApp: App {
    
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var store = Store()
    
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: MainViewModel(shareWatchFaceService: ShareWatchfaceWorker(), watchFaceCustomizationService: WatchFaceCustomizationWorker()))
                .environmentObject(store)
                .task(id: scenePhase) {
                    if scenePhase == .active {
                        await store.fetchActiveTransactions()
                    }
                }
        }
    }
}
