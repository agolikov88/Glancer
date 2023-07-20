//
//  SelectAppIconView.swift
//  Watch Cards
//
//  Created by Alexander Golikov on 7/18/23.
//

import SwiftUI

struct SelectAppIconView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    private var icons: [String]
    private var items: [GridItem] = Array(repeating: .init(.adaptive(minimum: 120)), count: 3)
    
    @State private var selectedIcon: String = ""
    
    init(watchFaceCustomizationService: WatchFaceCustomizationService) {
        icons = watchFaceCustomizationService.readCustomizationConfiguration().supportedAppIcons
    }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: items, spacing: 24) {
                    ForEach(icons, id: \.self) { icon in
                        Button(action: {
                            selectedIcon = icon
                        }, label: {
                            Image(icon + "_img")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 96)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(.systemOrange), lineWidth: selectedIcon == icon ? 4 : 0)
                                )
                        })
                    }
                    .padding(.horizontal)
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Icons").font(.custom("Cookie-Regular", size: 36))
                }
            }
            .navigationBarItems(
                leading:
                    Button(action: closeWithoutSaving, label: { Text("Cancel") }),
                trailing:
                    HStack {
                        Button(action: activateSelectedIcon, label: { Text("Done") })
                    }
            )
        }
        .accentColor(Color(.systemOrange))
    }
    
    private func closeWithoutSaving() {
        presentationMode.wrappedValue.dismiss()
    }
    
    private func activateSelectedIcon() {
        print(selectedIcon)
        UIApplication.shared.setAlternateIconName(selectedIcon) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Success!")
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct SelectAppIconView_Previews: PreviewProvider {
    static var previews: some View {
        SelectAppIconView(watchFaceCustomizationService: WatchFaceCustomizationWorker())
    }
}
