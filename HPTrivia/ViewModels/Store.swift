//
//  Store.swift
//  HPTrivia
//
//  Created by Ferenc Batorligeti on 2026. 02. 21..
//
import StoreKit

@MainActor
@Observable
class Store {
    var products: [Product] = []
    var purchasedProducts: Set<String> = []

    private var updates: Task<Void, Never>? = nil

    //Load available products
    func loadProducts() async {
        do {
            products = try await Product.products(for: ["hp4", "hp5", "hp6", "hp7"])
            products.sort { $0.displayName < $1.displayName }
        } catch {
            print ("Error loading products: \(error)")
        }
    }

    //Purchase a product
    func purchase(_ product: Product) async {
        do {
            let result = try await product.purchase()

            switch result {
            case .success(let verificationResult):
                switch verificationResult {
                case .unverified(let signedType, let verificationError):
                    print("Purchase unverified. Signed type: \(signedType). Error: \(verificationError)")
                case .verified(let signedType) :
                    purchasedProducts.insert(product.id)
                    await signedType.finish()
                }
            case .userCancelled: break
            case .pending: break
            @unknown default: break
            }
        } catch {
            print("Error purchasing product: \(error)")
        }
    }

    // Check for purchased products

    // Connect with App Store to watch for purchase and transaction updates
}
