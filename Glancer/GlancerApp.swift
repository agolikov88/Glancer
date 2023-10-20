//
//  GlancerApp.swift
//  Glancer
//
//  Created by Alexander Golikov on 3/12/23.
//

import SwiftUI

@main
struct GlancerApp: App {
    
    @StateObject private var store = Store()
    
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: MainViewModel(shareWatchFaceService: ShareWatchfaceWorker(), watchFaceCustomizationService: WatchFaceCustomizationWorker()))
                .environmentObject(store)
                .task {
                    await store.fetchActiveTransactions()
                }
//                .onChange(of: store.activeTransactions, perform: {activeTransactions in
//                    if activeTransactions.isEmpty {
//                        AppSettings.disablePaidSubscription()
//                    } else {
//                        AppSettings.enablePaidSubscription()
//                    }
//                })
        }
    }
}
