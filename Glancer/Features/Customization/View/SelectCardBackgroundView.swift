//
//  SelectCardBackgroundView.swift
//  WatchCards
//
//  Created by Alexander Golikov on 10/12/22.
//  Copyright © 2022 Alexander Golikov. All rights reserved.
//

import SwiftUI
import PhotosUI

struct SelectCardBackgroundView: View {
    
    @EnvironmentObject private var store: Store
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel = SelectCustomBackgroundViewModel()
    
    private var backgrounds: [String]
    private var items: [GridItem] = Array(repeating: .init(.adaptive(minimum: 120)), count: 2)
    
    @State private var showPhotosPicker = false
    @State private var showImagePlayground = false
    @State private var showErrorAlert = false
    @State private var selectedBackgrounds: [String] = []
    @State private var showSubscriptionView = false
    
    let onBackgroundsSelected: (([String]) -> Void)?
    
    init(backgrounds: [String] = [], onBackgroundsSelected: (([String]) -> Void)? = nil) {
        self.backgrounds = backgrounds
        self.onBackgroundsSelected = onBackgroundsSelected
    }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: items, spacing: 24) {
                    Button(action: {
                        if store.isPaidSubscription {
                            showPhotosPicker = true
                        } else {
                            showSubscriptionView = true
                        }
                    }, label: {
                        ZStack {
                            Image("camera_icon")
                                .frame(width: 120, height: 147)
                                .background(.black)
                                .cornerRadius(8)
                        }
                    })
                    if #available(iOS 18.1, *) {
                        Button(action: {
                            if store.isPaidSubscription {
                                showImagePlayground = true
                            } else {
                                showSubscriptionView = true
                            }
                        }, label: {
                            ZStack {
                                Image("generate_image_icon")
                                    .frame(width: 120, height: 147)
                                    .background(.black)
                                    .cornerRadius(8)
                            }
                        })
                        .disabled(!ImagePlaygroundAvailability.imagePlaygroundSupported())
                        .imagePlaygroundSheet(
                                    isPresented: $showImagePlayground,
                                    concepts: [
                                    ],
                                    //sourceImage: Image("image"),
                                    onCompletion: { url in
                                        //resultImage = Image(uiImage: UIImage(contentsOfFile: url.relativePath)!)
                                    },
                                    onCancellation: {}
                                )
                    }
                    ForEach(backgrounds, id: \.self) { background in
                        Button(action: {
                            if selectedBackgrounds.contains(background) {
                                selectedBackgrounds.removeAll { $0 == background}
                            } else {
                                selectedBackgrounds.removeAll()
                                selectedBackgrounds.append(background)
                            }
                            returnSelectedBackgrounds()
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
            .sheet(isPresented: $showSubscriptionView) {
                SubscriptionView(isShowing: $showSubscriptionView)
            }
            .photosPicker(isPresented: $showPhotosPicker, selection: $viewModel.selectedPhotos, maxSelectionCount: 1, matching: .images)
            .navigationBarTitle(Text("Select backgrounds"), displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: closeWithoutSaving, label: { Text("Cancel") })
            )
        }
        .accentColor(Color(.systemOrange))
        .onChange(of: viewModel.selectedPhotos, perform: { _ in
            Logger.info("Selected photo from PhotoLibrary")
            viewModel.convertDataToImageFile()
        })
        .onChange(of: viewModel.backgroundImageUrl, perform: { value in
            if let backgroundImageUrl = value {
                if !backgroundImageUrl.isEmpty {
                    Logger.info("Background image url: \(backgroundImageUrl)")
                    selectedBackgrounds.append(backgroundImageUrl)
                    returnSelectedBackgrounds()
                } else {
                    Logger.warning("Image url is empty!")
                    showErrorAlert = true
                }
            }
            viewModel.backgroundImageUrl = nil
        })
        .alert("Something went wrong! Please try again or select another photo", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) { }
        }
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
