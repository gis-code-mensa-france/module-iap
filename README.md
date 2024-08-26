# ModuleIAP - Swift 0.0.11


Charger les produits IAP existants :
```swift
loadProducts(identifiers:Set<String>) async throws -> [Product]
```

Acheter un produit :
```swift
public static func purchaseProduct(product:Product) async throws -> Transaction
```

Charger les transactions :
```swift
public static func loadTransactions() async -> [Transaction]
```

Charger les mises à jour de transactions :
```swift
public static func loadTransactionsUpdates(onTransactionUpdate:(Transaction) -> Bool) async
```
Codes erreur : 
```swift
public enum ModuleIAPError:Error {
    case loadingFailed
    case verificationFailed
    case userCancelled
    case pending
    case unknown
}
```


