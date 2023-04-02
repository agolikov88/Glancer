//
//  TutorialView.swift
//  Glancer
//
//  Created by Alexander Golikov on 4/1/23.
//

import SwiftUI

struct TutorialView: View {
    
    @Binding var isShowing: Bool
    
    var body: some View {
        VStack {
            Text("Tutorial")
                .font(.system(size: 28, weight: .bold, design: .default))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
            
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Image(systemName: "character.cursor.ibeam")
                        .font(.system(size: 28, design: .default))
                        .foregroundColor(Color(.systemOrange))
                        .padding(.trailing)
                    Text("Enter text you want to appear on your watch")
                        .font(.system(size: 22, design: .default))
                }
                VStack {
                    Image(systemName: "arrow.down")
                        .font(.system(size: 28, design: .default))
                        .foregroundColor(Color(.systemGray))
                }
                .frame(maxWidth: .infinity)
                HStack {
                    Image(systemName: "hand.tap")
                        .font(.system(size: 28, design: .default))
                        .foregroundColor(Color(.systemOrange))
                        .padding(.trailing)
                    Text("Hit “Send to Watch” button")
                        .font(.system(size: 22, design: .default))
                }
                VStack {
                    Image(systemName: "arrow.down")
                        .font(.system(size: 28, design: .default))
                        .foregroundColor(Color(.systemGray))
                }
                .frame(maxWidth: .infinity)
                HStack {
                    Image(systemName: "applewatch.watchface")
                        .font(.system(size: 28, design: .default))
                        .foregroundColor(Color(.systemOrange))
                        .padding(.trailing)
                    Text("Add new watch face to your watch")
                        .font(.system(size: 22, design: .default))
                }
                VStack {
                    Image(systemName: "arrow.down")
                        .font(.system(size: 28, design: .default))
                        .foregroundColor(Color(.systemGray))
                }
                .frame(maxWidth: .infinity)
                HStack {
                    Image(systemName: "arrow.clockwise.circle")
                        .font(.system(size: 28, design: .default))
                        .foregroundColor(Color(.systemOrange))
                        .padding(.trailing)
                    Text("Repeat:)")
                        .font(.system(size: 22, design: .default))
                }
                Spacer()
                Button(action: {
                    isShowing = false
                }) {
                    Text("Got it!")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.buttonBackgroundOrange)
                        .cornerRadius(16)
                        .foregroundColor(.white)
                }
            }
        }
        .padding(28)
        .onAppear {
            AppSettings.markTutorialViewed()
        }
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView(isShowing: .constant(true))
    }
}
