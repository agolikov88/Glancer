//
//  ContentView.swift
//  Glancer
//
//  Created by Alexander Golikov on 3/12/23.
//

import SwiftUI

struct MainView: View {
    
    @State var address = ""
    
    var body: some View {
        NavigationView {
            VStack {
                CardsPreviewView(topic: Topic(), topicCards: [], currentBackgroundIndex: 0)
                    .padding(.top)
                // test...
                TextField("Type your text here", text: $address, axis: .vertical)
                    .lineLimit(6, reservesSpace: true)
                    .padding(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
            }
            .padding()
            .navigationBarTitle("GLANCER", displayMode: .inline)
            .navigationBarItems(
                trailing:
                    Button(action: {}, label: { Image(systemName: "info.circle")
                    })
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .accentColor(Color(.systemOrange))
    }
}
