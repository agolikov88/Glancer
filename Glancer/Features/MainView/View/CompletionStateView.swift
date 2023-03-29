//
//  CompletionStateView.swift
//  Glancer
//
//  Created by Alexander Golikov on 3/28/23.
//

import SwiftUI

struct CompletionStateView: View {
    
    @Binding var isShowing: Bool
    
    var body: some View {
        Text("Watch face created!")
    }
}

struct CompletionStateView_Previews: PreviewProvider {
    static var previews: some View {
        CompletionStateView(isShowing: .constant(true))
    }
}
