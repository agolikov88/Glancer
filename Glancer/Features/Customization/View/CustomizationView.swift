//
//  CustomizationView.swift
//  Glancer
//
//  Created by Alexander Golikov on 4/6/23.
//

import SwiftUI

struct CustomizationView: View {
    
    @State private var font = "Avenir"
    @State private var fontStyle: Float = 0
    @State private var fontColor = Color.white
    
    var body: some View {
        VStack {
            Text("Customize")
            Button(action: {}, label: {
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
            HStack {
                Image(systemName: "textformat")
                    .font(.system(size: 24, design: .default))
                    .foregroundColor(Color(.systemOrange))
                Text("Font")
                Spacer()
                Picker("Font", selection: $font) {
                    Text("Avenir")
                    Text("Courier")
                    Text("Chalkboard")
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 32)
            .padding()
            .background(Color(.systemGray5))
            .cornerRadius(16)
            Slider(value: $fontStyle, in: 0...2, step: 1)
                .frame(maxWidth: .infinity)
                .frame(height: 32)
                .padding()
                .background(Color(.systemGray5))
                .cornerRadius(16)
            ColorPicker("Font color", selection: $fontColor, supportsOpacity: false)
                .frame(maxWidth: .infinity)
                .frame(height: 32)
                .padding()
                .background(Color(.systemGray5))
                .cornerRadius(16)
        }
        .accentColor(Color(.systemOrange))
    }
}

struct CustomizationView_Previews: PreviewProvider {
    static var previews: some View {
        CustomizationView()
    }
}
