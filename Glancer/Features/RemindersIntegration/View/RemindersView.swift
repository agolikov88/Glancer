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
    
    @StateObject var viewModel: RemindersViewModel
    
    @State private var showActivityIndicator = true
    @State private var multiSelection = Set<UUID>()
    
    var body: some View {
        NavigationView {
            VStack {
                if showActivityIndicator {
                    ProgressView().padding()
                } else if viewModel.remindersState == .accessDenied {
                    Text("Please allow access to reminders!")
                } else if viewModel.reminders.isEmpty {
                    Text("There are no recent reminders:(")
                } else {
                    List(viewModel.reminders, selection: $multiSelection) { reminder in
                        Text(reminder.title)
                    }
                }
            }
            .navigationBarTitle(Text("Select reminders"), displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: closeWithoutSaving, label: { Text("Cancel") }),
                trailing: Button(action: {}, label: { Text("Done") })
            )
        }
        .accentColor(Color(.systemOrange))
        .onAppear {
            viewModel.loadReminders()
        }
        .onChange(of: viewModel.remindersState, perform: {state in
            if state != .initial {
                showActivityIndicator = false
            }
        })
    }
    
    private func closeWithoutSaving() {
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    RemindersView(viewModel: RemindersViewModel(eventStore: EventKitStore()))
}
