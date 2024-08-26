import StoreKit

@available(iOS 15.0, *)
public enum ModuleIAP {
    
    //
    // Load availables products
    //
    public static func loadProducts(identifiers:Set<String>) async throws -> [Product] {
        do {
            /**
             Get store products
             */
            let storeProducts = try await Product.products(for: identifiers)
            return storeProducts
        } catch {
            throw ModuleIAPError.loadingFailed
        }
    }
    
    //
    // Purchase a specific product
    //
    public static func purchaseProduct(product:Product) async throws -> Transaction {
        /**
         Try the purchase
         */
        let result = try await product.purchase()
        
        /**
         Purchase result
         */
        switch result {
        case .success(let verificationResult):
            let transaction = try checkVerified(verificationResult)
            await transaction.finish()
            return transaction
        case .userCancelled:
            throw ModuleIAPError.userCancelled
        case .pending:
            throw ModuleIAPError.pending
        @unknown default:
            throw ModuleIAPError.unknown
        }
    }
    
    //
    // Load transactions
    //
    public static func loadTransactions() async -> [Transaction] {
        var transactions:[Transaction] = []
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                transactions.append(transaction)
            }
        }
        return transactions
    }
    
    //
    // Load transactions update
    //
    public static func loadTransactionsUpdates(onTransactionUpdate:(Transaction) -> Bool) async {
        for await result in Transaction.updates {
            do {
                let transaction = try ModuleIAP.checkVerified(result)
                if onTransactionUpdate(transaction){
                    await transaction.finish()
                }
            } catch {
            }
        }
    }
    
    //
    // Check if transaction is verified
    //
    private static func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw ModuleIAPError.verificationFailed
        case .verified(let safe):
            return safe
        }
    }
}
