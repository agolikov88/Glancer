//
//  Store.swift
//  Watch Cards
//
//  Created by Alexander Golikov on 10/10/23.
//

import StoreKit

@MainActor final class Store: ObservableObject {
    
    @Published private(set) var products: [Product] = []
    
    func fetchProducts() async {
        do {
            products = try await Product.products(
                for: ["WatchCards_Monthly"]
            )
        } catch {
            products = []
        }
    }
}
