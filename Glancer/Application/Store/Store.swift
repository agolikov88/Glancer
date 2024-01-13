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
    
    private let productIds = ["WatchCards_Lifetime"]
    
    private var updates: Task<Void, Never>?
    
    var isPaidSubscription: Bool {
        let isPaidSubscription = !self.purchasedProductIDs.isEmpty
        Logger.info("isPaidSubscription: \(isPaidSubscription)")
        return isPaidSubscription
    }
    
    init() {
        updates = observeTransactionUpdates()
        Logger.info("Store initialized")
    }
    
    deinit {
        updates?.cancel()
        Logger.info("Store deinitialized")
    }
    
    func fetchProducts() async {
        do {
            products = try await Product.products(
                for: productIds
            )
        } catch {
            Logger.error("Unable to fetch products!")
            products = []
        }
    }
    
    func purchase(_ product: Product) async throws {
        Logger.info("Purchase initiated")
        let result = try await product.purchase()
        switch result {
        case .success(let verificationResult):
            Logger.info("Purchase success")
            if let transaction = try? verificationResult.payloadValue {
                await transaction.finish()
                Logger.info("Purchase transaction finished")
                await self.fetchActiveTransactions()
            }
        case .userCancelled:
            Logger.info("user cancelled purchase")
            isUserCancelled = true
            break
        case .pending:
            Logger.info("purchase pending")
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
                Logger.info("Added active transaction: productID: \(transaction.productID) transactionID: \(transaction.id)")
                self.purchasedProductIDs.insert(transaction.productID)
            } else {
                Logger.info("Transaction revocation date is past due: productID: \(transaction.productID) transactionID: \(transaction.id)")
                self.purchasedProductIDs.remove(transaction.productID)
            }
        }
    }
    
    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) { [unowned self] in
            for await update in Transaction.updates {
                Logger.info("Transaction update detected")
                if let transaction = try? update.payloadValue {
                    Logger.info("calling transaction finish(): productID: \(transaction.productID) transactionID: \(transaction.id)")
                    await transaction.finish()
                }
                await self.fetchActiveTransactions()
            }
        }
    }
}
