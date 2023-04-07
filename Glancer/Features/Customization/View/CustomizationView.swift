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
                Text("Select backgrounds")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray5))
                    .cornerRadius(16)
                    .foregroundColor(.white)
            })
            .accentColor(.white)
            HStack {
                Text("Font")
                Spacer()
                Picker("Font", selection: $font) {
                    Text("Avenir")
                    Text("Courier")
                    Text("Chalkboard")
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemGray5))
            .cornerRadius(16)
            Slider(value: $fontStyle, in: 0...2, step: 1)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.systemGray5))
                .cornerRadius(16)
            ColorPicker("Font color", selection: $fontColor, supportsOpacity: false)
                .frame(maxWidth: .infinity)
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
