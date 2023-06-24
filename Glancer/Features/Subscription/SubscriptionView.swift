//
//  SubscriptionView.swift
//  Watch Cards
//
//  Created by Alexander Golikov on 6/19/23.
//

import SwiftUI

struct SubscriptionView: View {
    var body: some View {
        VStack {
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
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Image(systemName: "sparkles.rectangle.stack")
                        .font(.system(size: 28, design: .default))
                        .foregroundColor(Color(.systemGreen))
                        .padding(.trailing)
                    Text("Create up to 24 cards per watch album")
                        .font(.system(size: 18, design: .default))
                }
                HStack {
                    Image(systemName: "paintbrush.pointed")
                        .font(.system(size: 28, design: .default))
                        .foregroundColor(Color.blue)
                        .padding(.trailing)
                    Text("Use custom fonts, backgrounds and colors for your cards")
                        .font(.system(size: 18, design: .default))
                }
                HStack {
                    Image(systemName: "photo.circle")
                        .font(.system(size: 28, design: .default))
                        .foregroundColor(Color.mint)
                        .padding(.trailing)
                    Text("Choose from a selection of custom app icons")
                        .font(.system(size: 18, design: .default))
                }
            }
            Spacer()
        }
        .padding([.leading, .trailing], 28)
    }
}

struct SubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionView()
    }
}
