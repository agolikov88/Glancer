//
//  CustomizationView.swift
//  Glancer
//
//  Created by Alexander Golikov on 4/6/23.
//

import SwiftUI
import StoreKit

struct CustomizationView: View {
    
    @EnvironmentObject private var store: Store
    
    @ObservedObject var viewModel: MainViewModel
    
    @State private var font = "Avenir Next Condensed"
    @State private var fontStyle: Float = 0
    @State private var fontColor = Color.white
    
    @State private var showSelectBackgroundView = false
    @State private var enableImageOverlay = true
    @State private var textOnTop = true
    @State private var showSubscriptionView = false
    @State private var showFontPickerView = false
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        _enableImageOverlay = State(initialValue: viewModel.topicCards[viewModel.currentPageIndex].overlay)
        _textOnTop = State(initialValue: viewModel.topicCards[viewModel.currentPageIndex].textOnTop)
        _font = State(initialValue: viewModel.topicCards[viewModel.currentPageIndex].fontName)
        _fontStyle = State(initialValue: Float(viewModel.customizationConfiguration.supportedFonts[viewModel.topicCards[viewModel.currentPageIndex].fontName]!.first(where: { $1 == viewModel.topicCards[viewModel.currentPageIndex].fontStyle })!.key))
        _fontColor = State(initialValue: Color(hex: viewModel.topicCards[viewModel.currentPageIndex].fontColor) ?? Color.white)
    }
    
    var body: some View {
        VStack {
            Text("Customize")
            HStack {
                Button(action: {AnalyticsManager.selectBackgroundViewOpened(); showSelectBackgroundView = true}, label: {
                    HStack {
                        Image(systemName: "photo")
                            .font(.system(size: 28, design: .default))
                            .foregroundColor(Color(.systemOrange))
                    }
                    .frame(height: 32)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray5))
                    .cornerRadius(16)
                    .foregroundColor(.white)
                })
                Button(action: {
                    AnalyticsManager.overlayChanged()
                    enableImageOverlay.toggle()
                    viewModel.topicCards[viewModel.currentPageIndex].overlay = enableImageOverlay
                }, label: {
                    HStack {
                        Image(systemName: enableImageOverlay ? "square.2.layers.3d.top.filled" : "square.2.layers.3d")
                            .font(.system(size: 28, design: .default))
                            .foregroundColor(Color(.systemOrange))
                    }
                    .frame(height: 32)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray5))
                    .cornerRadius(16)
                    .foregroundColor(.white)
                })
                .frame(height: 32)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.systemGray5))
                .cornerRadius(16)
                .foregroundColor(.white)
                Button(action: {
                    AnalyticsManager.textPositionChanged()
                    textOnTop.toggle()
                    viewModel.topicCards[viewModel.currentPageIndex].textOnTop = textOnTop
                }, label: {
                    HStack {
                        Image(systemName: textOnTop ? "text.line.first.and.arrowtriangle.forward" : "text.line.last.and.arrowtriangle.forward")
                            .font(.system(size: 28, design: .default))
                            .foregroundColor(Color(.systemOrange))
                    }
                    .frame(height: 32)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray5))
                    .cornerRadius(16)
                    .foregroundColor(.white)
                })
                .frame(height: 32)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.systemGray5))
                .cornerRadius(16)
                .foregroundColor(.white)
            }
            .accentColor(.white)
            .sheet(isPresented: $showSelectBackgroundView) {
                SelectCardBackgroundView(backgrounds: viewModel.customizationConfiguration.supportedBackgrounds) { selectedBackgrounds in
                    if !selectedBackgrounds.isEmpty {
                        AnalyticsManager.backgroundChanged()
                        viewModel.topicCards[viewModel.currentPageIndex].background = selectedBackgrounds[0]
                    }
                }
            }
            if store.isPaidSubscription {
                Button(action: { showFontPickerView = true }, label: {
                    HStack(alignment: .lastTextBaseline) {
                        Image(systemName: "textformat")
                            .font(.system(size: 24, design: .default))
                            .foregroundColor(.white)
                            .padding(.trailing, 32)
                        if let fontStyle = viewModel.customizationConfiguration.supportedFonts[font]![Int(fontStyle)] {
                            Text(font).font(.custom(fontStyle.isEmpty ? "\(font)" : "\(font)-\(fontStyle)", size: 18)).animation(nil)
                        } else {
                            Text(font).animation(nil)
                        }
                        Spacer()
                    }
                })
                .frame(height: 32)
                .frame(maxWidth: .infinity)
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
            } else {
                Button(action: {showSubscriptionView = true}, label: {
                    Text("Unlock All")
                        .font(.custom("Cookie-Regular", size: 36))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.orange, .red, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                })
            }
        }
        .sheet(isPresented: $showFontPickerView) {
            FontPickerView(fonts: viewModel.customizationConfiguration.supportedFonts) { selectedFont in
                if !selectedFont.isEmpty {
                    font = selectedFont
                }
            }
        }
        .sheet(isPresented: $showSubscriptionView) {
            SubscriptionView(isShowing: $showSubscriptionView)
        }
        .onChange(of: font, perform: {fontValue in
            if let fontStyle = viewModel.customizationConfiguration.supportedFonts[fontValue]![Int(fontStyle)] {
                AnalyticsManager.fontChanged()
                viewModel.topicCards[viewModel.currentPageIndex].fontName = fontValue
                viewModel.topicCards[viewModel.currentPageIndex].fontStyle = fontStyle
            }
        })
        .onChange(of: fontStyle, perform: {fontStyleValue in
            if let fontStyle = viewModel.customizationConfiguration.supportedFonts[font]![Int(fontStyleValue)] {
                AnalyticsManager.fontSizeChanged()
                viewModel.topicCards[viewModel.currentPageIndex].fontStyle = fontStyle
            }
        })
        .onChange(of: fontColor, perform: {fontColorValue in
            AnalyticsManager.textColorChanged()
            viewModel.topicCards[viewModel.currentPageIndex].fontColor =  fontColorValue.toHex() ?? "0xFFFFFF"
        })
        .accentColor(Color(.systemOrange))
    }
}

struct CustomizationView_Previews: PreviewProvider {
    static var previews: some View {
        CustomizationView(viewModel: MainViewModel(shareWatchFaceService: ShareWatchfaceWorker(), watchFaceCustomizationService: WatchFaceCustomizationWorker()))
    }
}
