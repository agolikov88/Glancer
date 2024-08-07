//
//  RemindersView.swift
//  Watch Cards
//
//  Created by Alexander Golikov on 7/31/24.
//

import SwiftUI

struct RemindersView: View {
    
    @EnvironmentObject private var eventKitStore: EventKitStore
    
    @Environment(\.presentationMode) var presentationMode
    
    var viewModel: RemindersViewModel
    
    var body: some View {
        Text("Reminders View")
            .onAppear {
                viewModel.loadReminders()
            }
    }
}

#Preview {
    RemindersView(viewModel: RemindersViewModel(eventStore: EventKitStore()))
}
