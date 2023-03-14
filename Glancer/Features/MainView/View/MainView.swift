//
//  ContentView.swift
//  Glancer
//
//  Created by Alexander Golikov on 3/12/23.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var viewModel: MainViewModel
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack {
                CardsPreviewView(topic: Topic(), topicCards: [viewModel.topicCard], currentBackgroundIndex: 0)
                    .padding(.top)
                TextField("Type your text here", text: $viewModel.cardText, axis: .vertical)
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
        MainView(viewModel: MainViewModel())
            .accentColor(Color(.systemOrange))
    }
}
