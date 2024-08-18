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
    @State private var selectedReminders: [Reminder] = []
    
    let onRemindersSelected: (([Reminder]) -> Void)?
    
    var body: some View {
        NavigationView {
            VStack {
                if showActivityIndicator {
                    ProgressView().padding()
                } else if viewModel.remindersState == .accessDenied {
                    Text("Please allow access to reminders!")
                        .padding()
                    Image(systemName: "exclamationmark.octagon")
                        .font(.system(size: 96, weight: .bold, design: .default))
                        .foregroundColor(Color(.systemOrange))
                        .padding()
                    Button(action: {
                        if let url = URL(string:UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }) {
                        Text("Open app settings")
                            .fontWeight(.bold)
                    }
                } else if viewModel.reminders.isEmpty {
                    Text("There are no recent reminders:(")
                        .padding()
                    Image(systemName: "checklist.unchecked")
                        .font(.system(size: 96, weight: .bold, design: .default))
                        .foregroundColor(Color(.systemOrange))
                } else {
                    List(viewModel.reminders) { reminder in
                        Button(action: {
                            if selectedReminders.contains(reminder) {
                                selectedReminders.removeAll { $0 == reminder}
                            } else {
                                selectedReminders.append(reminder)
                            }
                        }, label: {
                            HStack {
                                Image(systemName: selectedReminders.contains(reminder) ? "circle.fill" : "circle")
                                    .foregroundColor(selectedReminders.contains(reminder) ? Color(.systemOrange) : Color(.white))
                                VStack(alignment: .leading) {
                                    Text(reminder.title)
                                        .foregroundColor(Color(.white))
                                    if let dueDate = reminder.dueDate {
                                        Text(UniversalDateFormatter.formatDateBasedOnLocale(date: dueDate))
                                            .foregroundColor(Color(.systemOrange))
                                    }
                                }
                                Spacer()
                            }
                            .padding()
                        })
                    }
                }
            }
            .navigationBarTitle(Text("Select reminders"), displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: closeWithoutSaving, label: { Text("Cancel") }),
                trailing: Button(action: {
                    onRemindersSelected?(selectedReminders)
                    presentationMode.wrappedValue.dismiss()
                }, label: { Text("Done") })
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
    RemindersView(viewModel: RemindersViewModel(eventStore: EventKitStore()), onRemindersSelected: nil)
}
