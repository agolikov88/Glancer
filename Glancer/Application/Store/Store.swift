//
//  Store.swift
//  Watch Cards
//
//  Created by Alexander Golikov on 10/10/23.
//

import StoreKit

@MainActor final class Store: ObservableObject {
    
    @Published private(set) var products: [Product] = []
    @Published private(set) var activeTransactions: Set<StoreKit.Transaction> = []
    
    private var updates: Task<Void, Never>?
    
    init() {
        updates = Task {
            for await update in StoreKit.Transaction.updates {
                if let transaction = try? update.payloadValue {
                    activeTransactions.insert(transaction)
                    await transaction.finish()
                }
            }
        }
    }
    
    deinit {
        updates?.cancel()
    }
    
    func fetchProducts() async {
        do {
            products = try await Product.products(
                for: ["WatchCards_Monthly"]
            )
        } catch {
            products = []
        }
    }
    
    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()
        switch result {
        case .success(let verificationResult):
            if let transaction = try? verificationResult.payloadValue {
                activeTransactions.insert(transaction)
                await transaction.finish()
            }
        case .userCancelled:
            break
        case .pending:
            break
        @unknown default:
            break
        }
    }
    
    func fetchActiveTransactions() async {
        var activeTransactions: Set<StoreKit.Transaction> = []
        
        for await entitlement in StoreKit.Transaction.currentEntitlements {
            if let transaction = try? entitlement.payloadValue {
                activeTransactions.insert(transaction)
            }
        }
        
        self.activeTransactions = activeTransactions
    }
}
