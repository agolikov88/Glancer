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
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Image(systemName: "sparkles.rectangle.stack")
                        .font(.system(size: 28, design: .default))
                        .foregroundColor(Color(.systemOrange))
                        .padding(.trailing)
                    Text("Create up to 24 cards per watch album")
                        .font(.system(size: 22, design: .default))
                }
                HStack {
                    Image(systemName: "paintbrush.pointed")
                        .font(.system(size: 28, design: .default))
                        .foregroundColor(Color(.systemOrange))
                        .padding(.trailing)
                    Text("Use custom fonts, backgrounds and colors for your cards")
                        .font(.system(size: 22, design: .default))
                }
                HStack {
                    Image(systemName: "photo.circle")
                        .font(.system(size: 28, design: .default))
                        .foregroundColor(Color(.systemOrange))
                        .padding(.trailing)
                    Text("Choose from a selection of custom app icons")
                        .font(.system(size: 22, design: .default))
                }
            }
            Spacer()
        }
    }
}

struct SubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionView()
    }
}
