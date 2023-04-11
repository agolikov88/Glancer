//
//  SelectCardBackgroundView.swift
//  WatchCards
//
//  Created by Alexander Golikov on 10/12/22.
//  Copyright © 2022 Alexander Golikov. All rights reserved.
//

import SwiftUI

struct SelectCardBackgroundView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    private var backgrounds: [String]
    private var items: [GridItem] = Array(repeating: .init(.adaptive(minimum: 120)), count: 2)
    
    @State private var selectedBackgrounds: [String] = []
    
    let onBackgroundsSelected: (([String]) -> Void)?
    
    init(backgrounds: [String] = [], onBackgroundsSelected: (([String]) -> Void)? = nil) {
        self.backgrounds = backgrounds
        self.onBackgroundsSelected = onBackgroundsSelected
    }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: items, spacing: 24) {
                    ForEach(backgrounds, id: \.self) { background in
                        Button(action: {
                            if selectedBackgrounds.contains(background) {
                                selectedBackgrounds.removeAll { $0 == background}
                            } else {
                                selectedBackgrounds.removeAll()
                                selectedBackgrounds.append(background)
                            }
                        }, label: {
                            Image(background)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 120)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(.systemOrange), lineWidth: selectedBackgrounds.contains(background) ? 4 : 0)
                                )
                        })
                    }
                    .padding(.horizontal)
                }
            }
            .navigationBarTitle(Text("Select backgrounds"), displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button(action: closeWithoutSaving, label: { Text("Cancel") }),
                trailing:
                    HStack {
                        Button(action: returnSelectedBackgrounds, label: { Text("Done") })
                    }
            )
        }
        .accentColor(Color(.systemOrange))
    }
    
    private func closeWithoutSaving() {
        presentationMode.wrappedValue.dismiss()
    }
    
    private func returnSelectedBackgrounds() {
        onBackgroundsSelected?(selectedBackgrounds)
        presentationMode.wrappedValue.dismiss()
    }
}

struct SelectCardBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        SelectCardBackgroundView(backgrounds: ["background1", "background2", "background3", "background4", "background5", "background6", "background7", "background8", "background9", "background10"])
    }
}
