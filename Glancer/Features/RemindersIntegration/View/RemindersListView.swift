//
//  RemindersListView.swift
//  Watch Cards
//
//  Created by Alexander Golikov on 8/10/24.
//

import SwiftUI

struct RemindersListView: View {
    
    var title: String = ""
    var dueDate: Date?
    
    var body: some View {
        HStack {
            Image(systemName: "circle")
            VStack(alignment: .leading) {
                Text(title)
                Text(dueDate == nil ? "--/--/----" : "03/08/2024")
                    .foregroundColor(Color(.systemOrange))
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    RemindersListView(title: "Reminder title")
}
