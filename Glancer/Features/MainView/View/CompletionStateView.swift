//
//  CompletionStateView.swift
//  Glancer
//
//  Created by Alexander Golikov on 3/28/23.
//

import SwiftUI

struct CompletionStateView: View {
    
    @Environment(\.requestReview) private var requestReview
    
    @ObservedObject var viewModel: MainViewModel
    
    @Binding var isShowing: Bool
    
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
                if succesful {
                    presentReviewRequest()
                }
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
                viewModel.clearCards()
                isShowing = false
                if succesful {
                    presentReviewRequest()
                }
            }) {
                Text("Start fresh")
                    .fontWeight(.bold)
            }
        }
        .padding()
        .accentColor(Color(.systemOrange))
    }
    
    private func presentReviewRequest() {
        guard let currentAppVersion = Bundle.currentAppVersion else {
            return
        }
        if currentAppVersion != AppSettings.getLastVersionReviewRequested() {
            Task {
                // Delay for two seconds to avoid interrupting the person using the app.
                try await Task.sleep(for: .seconds(2))
                requestReview()
                AnalyticsManager.reviewRequestShown()
            }
            AppSettings.setLastVersionReviewRequested(updatedVersionReviewRequested: currentAppVersion)
        }
    }
}

struct CompletionStateView_Previews: PreviewProvider {
    static var previews: some View {
        CompletionStateView(viewModel: MainViewModel(shareWatchFaceService: ShareWatchfaceWorker(), watchFaceCustomizationService: WatchFaceCustomizationWorker()), isShowing: .constant(true), succesful: true)
    }
}
