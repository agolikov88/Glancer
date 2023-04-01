//
//  CompletionStateView.swift
//  Glancer
//
//  Created by Alexander Golikov on 3/28/23.
//

import SwiftUI

struct CompletionStateView: View {
    
    @Binding var isShowing: Bool
    @Binding var textField: String
    
    var succesful = true
    
    var body: some View {
        VStack {
            Text("Watch face \(succesful ? "created!" : "failed:(")").font(.system(size: 28, weight: .bold))
                .padding(.top)
            Spacer()
            Image(systemName: succesful ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.system(size: 96, weight: .bold, design: .default))
                .foregroundColor(Color(succesful ? .systemGreen : .systemRed))
                .background(Color(.white))
                .clipShape(Circle())
            Spacer()
            Button(action: {
                isShowing = false
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
                textField = ""
                isShowing = false
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
        CompletionStateView(isShowing: .constant(true), textField: .constant(""), succesful: true)
    }
}
