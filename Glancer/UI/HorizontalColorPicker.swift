//
//  HorizontalColorPicker.swift
//  Glancer
//
//  Created by Alexander Golikov on 4/8/23.
//

import SwiftUI

struct HorizontalColorPicker: View {
    
    @Binding var selectedColor: Color
    private let colors:[Color] = [.white, .black, .yellow, .green, .purple, .cyan, .mint, .red, .orange, .blue]
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(colors, id: \.self) { color in
                    Circle()
                        .foregroundColor(color)
                        .frame(width: 45, height: 45)
                        .opacity(color == selectedColor ? 0.5 : 1.0)
                        .scaleEffect(color == selectedColor ? 1.1 : 1.0)
                        .onTapGesture {
                            selectedColor = color
                        }
                }
            }
            .padding()
        }
    }
}

struct HorizontalColorPicker_Previews: PreviewProvider {
    
    static var previews: some View {
        HorizontalColorPicker(selectedColor: .constant(.blue))
    }
}
