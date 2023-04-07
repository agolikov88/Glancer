//
//  SendFeedbackView.swift
//  WatchCards
//
//  Created by Alexander Golikov on 12/30/22.
//  Copyright © 2022 Alexander Golikov. All rights reserved.
//

import Foundation
import SwiftUI
import MessageUI

struct SendFeedbackView: UIViewControllerRepresentable {

    @Binding var isShowing: Bool
    @Binding var result: Result<MFMailComposeResult, MFMailComposeError>?

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {

        @Binding var isShowing: Bool
        @Binding var mailSendResult: Result<MFMailComposeResult, MFMailComposeError>?

        init(isShowing: Binding<Bool>, result: Binding<Result<MFMailComposeResult, MFMailComposeError>?>) {
            _isShowing = isShowing
            _mailSendResult = result
        }

        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            defer {
                isShowing = false
            }
            guard error == nil else {
                mailSendResult = .failure(MFMailComposeError(_nsError: NSError()))
                return
            }
            mailSendResult = .success(result)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(isShowing: $isShowing,
                           result: $result)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<SendFeedbackView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients([Bundle.main.object(forInfoDictionaryKey: "Feedback email") as? String ?? "watchcardsfeedback@gmail.com"])
        vc.setSubject("WatchCards Feedback")
        vc.setMessageBody("Please write your feedback below. Please feel free to attach any screenshots or any other information that will help us to improve the app!", isHTML: false)
        
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<SendFeedbackView>) {
    }
}
