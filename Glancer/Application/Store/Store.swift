//
//  Store.swift
//  Watch Cards
//
//  Created by Alexander Golikov on 10/10/23.
//

import StoreKit

@MainActor final class Store: ObservableObject {
    
    @Published private(set) var products: [Product] = []
    @Published private(set) var purchasedProductIDs = Set<String>()
    @Published var isUserCancelled = false
    
    private let productIds = ["WatchCards_Monthly"]
    
    private var updates: Task<Void, Never>?
    
    var isPaidSubscription: Bool {
        return !self.purchasedProductIDs.isEmpty
    }
    
    init() {
        updates = observeTransactionUpdates()
    }
    
    deinit {
        updates?.cancel()
    }
    
    func fetchProducts() async {
        do {
            products = try await Product.products(
                for: productIds
            )
        } catch {
            print("Unable to fetch products!")
            products = []
        }
    }
    
    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()
        switch result {
        case .success(let verificationResult):
            if let transaction = try? verificationResult.payloadValue {
                await transaction.finish()
                await self.fetchActiveTransactions()
            }
        case .userCancelled:
            print("user cancelled")
            isUserCancelled = true
            break
        case .pending:
            print("pending")
            break
        @unknown default:
            break
        }
    }
    
    func fetchActiveTransactions() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }
            
            if transaction.revocationDate == nil {
                self.purchasedProductIDs.insert(transaction.productID)
            } else {
                self.purchasedProductIDs.remove(transaction.productID)
            }
        }
    }
    
    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) { [unowned self] in
            for await update in Transaction.updates {
                if let transaction = try? update.payloadValue {
                    await transaction.finish()
                }
                await self.fetchActiveTransactions()
            }
        }
    }
}
