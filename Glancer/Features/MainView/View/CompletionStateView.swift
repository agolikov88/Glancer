//
//  CompletionStateView.swift
//  Glancer
//
//  Created by Alexander Golikov on 3/28/23.
//

import SwiftUI

struct CompletionStateView: View {
    
    @Binding var isShowing: Bool
    
    var succesful = true
    
    var body: some View {
        VStack {
            Text("Watch face \(succesful ? "created!" : "failed:(")").font(.system(size: 28, weight: .bold))
                .padding(.top)
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 96, weight: .bold, design: .default))
                .foregroundColor(Color(.systemGreen))
                .background(Color(.white))
                .clipShape(Circle())
            Spacer()
            Button(action: {
                
            }) {
                Text("Okay")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.buttonBackgroundOrange)
                    .cornerRadius(16)
                    .foregroundColor(.white)
            }
            .padding(.bottom)
            Button(action: {
                
            }) {
                Text("Clear entered text")
                    .fontWeight(.bold)
            }
        }
        .padding()
        .accentColor(Color(.systemOrange))
    }
}

struct CompletionStateView_Previews: PreviewProvider {
    static var previews: some View {
        CompletionStateView(isShowing: .constant(true), succesful: true)
    }
}
