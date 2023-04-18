//
//  CustomizationView.swift
//  Glancer
//
//  Created by Alexander Golikov on 4/6/23.
//

import SwiftUI

struct CustomizationView: View {
    
    @ObservedObject var viewModel: MainViewModel
    
    @State private var font = "Avenir Next Condensed"
    @State private var fontStyle: Float = 0
    @State private var fontColor = Color.white
    
    @State private var showSelectBackgroundView = false
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Text("Customize")
            Button(action: {showSelectBackgroundView = true}, label: {
                HStack {
                    Image(systemName: "photo")
                        .font(.system(size: 24, design: .default))
                        .foregroundColor(Color(.systemOrange))
                    Text("Select backgrounds")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(height: 32)
                .padding()
                .background(Color(.systemGray5))
                .cornerRadius(16)
                .foregroundColor(.white)
            })
            .accentColor(.white)
            .sheet(isPresented: $showSelectBackgroundView) {
                SelectCardBackgroundView(backgrounds: viewModel.customizationConfiguration.supportedBackgrounds) { selectedBackgrounds in
                    if !selectedBackgrounds.isEmpty {
                        viewModel.topicCard.background = selectedBackgrounds[0]
                    }
                }
            }
            HStack {
                Image(systemName: "textformat")
                    .font(.system(size: 24, design: .default))
                    .foregroundColor(Color(.systemOrange))
                Text("Font")
                Spacer()
                Picker("Font", selection: $font) {
                    ForEach(Array(viewModel.customizationConfiguration.supportedFonts.keys).sorted(), id: \.self) {
                        Text($0)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 32)
            .padding()
            .background(Color(.systemGray5))
            .cornerRadius(16)
            Slider(value: $fontStyle, in: 0...2, step: 1)   // TODO: use actual number of supported styles depending on selected font...
                .frame(maxWidth: .infinity)
                .frame(height: 32)
                .padding()
                .background(Color(.systemGray5))
                .cornerRadius(16)
            HorizontalColorPicker(selectedColor: $fontColor)
                .frame(maxWidth: .infinity)
                .frame(height: 32)
                .padding([.top, .bottom])
                .background(Color(.systemGray5))
                .cornerRadius(16)
        }
        .onChange(of: font, perform: {fontValue in
            if let fontStyle = viewModel.customizationConfiguration.supportedFonts[fontValue]![Int(fontStyle)] {
                viewModel.topicCard.fontName = fontValue
                viewModel.topicCard.fontStyle = fontStyle
            }
        })
        .onChange(of: fontStyle, perform: {fontStyleValue in
            if let fontStyle = viewModel.customizationConfiguration.supportedFonts[font]![Int(fontStyleValue)] {
                viewModel.topicCard.fontStyle = fontStyle
            }
        })
        .onChange(of: fontColor, perform: {fontColorValue in
            viewModel.topicCard.fontColor =  fontColorValue.toHex() ?? "0xFFFFFF"
        })
        .accentColor(Color(.systemOrange))
    }
}

struct CustomizationView_Previews: PreviewProvider {
    static var previews: some View {
        CustomizationView(viewModel: MainViewModel(shareWatchFaceService: ShareWatchfaceWorker(), watchFaceCustomizationService: WatchFaceCustomizationWorker()))
    }
}
