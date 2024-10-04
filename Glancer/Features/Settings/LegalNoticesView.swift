//
//  LegalNoticesView.swift
//  Watch Cards
//
//  Created by Alexander Golikov on 7/22/23.
//

import SwiftUI

enum NoticeType {
    case termsOfService
    case thirdParty
}

struct LegalNoticesView: View {
    
    @State var noticeType: NoticeType = .termsOfService
    
    init(noticeType: NoticeType) {
        _noticeType = State(initialValue: noticeType)
    }
    
    var body: some View {
        WCWebView(url: Bundle.main.url(forResource: noticeType == .termsOfService ? "terms_of_service" : "third_party", withExtension: "html")!)
            .ignoresSafeArea()
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct LegalNoticesView_Previews: PreviewProvider {
    static var previews: some View {
        LegalNoticesView(noticeType: .termsOfService)
    }
}
