//
//  ContentView.swift
//  Glancer
//
//  Created by Alexander Golikov on 3/12/23.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var viewModel: MainViewModel
    
    @FocusState var isInputActive: Bool
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack {
                CardsPreviewView(topic: Topic(), topicCards: [viewModel.topicCard], currentBackgroundIndex: 0)
                    .padding(.top)
                Spacer()
                TextField("Type your text here", text: $viewModel.cardText, axis: .vertical)
                    .lineLimit(2, reservesSpace: true)
                    .padding(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                    .focused($isInputActive)
            }
            .padding()
            .navigationBarTitle("GLANCER", displayMode: .inline)
            .navigationBarItems(
                trailing:
                    HStack {
                        Button(action: {}, label: { Image(systemName: "info.circle")
                        })
                        if isInputActive {
                            Button(action: {isInputActive = false}, label: { Text("Done") })
                        }
                    }
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
