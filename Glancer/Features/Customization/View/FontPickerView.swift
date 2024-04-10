//
//  FontPickerView.swift
//  Watch Cards
//
//  Created by Alexander Golikov on 4/9/24.
//

import SwiftUI

struct FontPickerView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    let fonts: [String: [Int: String]]
    
    let onFontSelected: ((String) -> Void)?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Array(fonts.keys).sorted(), id: \.self) { font in
                    if let fontStyles = fonts[font], let fontStyle = fontStyles[0] {
                        Button(action: {returnSelectedFont(font: font)}, label: {
                            Text(font).font(.custom(fontStyle.isEmpty ? "\(font)" : "\(font)-\(fontStyle)", size: 24))
                        })
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle(Text("Choose font"), displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: closeWithoutSaving, label: { Text("Cancel") })
            )
        }
        .accentColor(Color(.systemOrange))
    }
    
    private func closeWithoutSaving() {
        presentationMode.wrappedValue.dismiss()
    }
    
    private func returnSelectedFont(font: String) {
        onFontSelected?(font)
        presentationMode.wrappedValue.dismiss()
    }
}
