//
//  PurchaseManager.swift
//  My Score
//
//  Created by Air One on 6/25/24.
//

import UIKit
import StoreKit

class PurchaseManager: NSObject, SKPaymentTransactionObserver{
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        return true
    }
    
    
    static let shared = PurchaseManager()
    
    private  let productIds = ["week_main", "month_main", "year_main"]
    private(set)  var purchasedProductIDs = Set<String>()
    private var updates: Task<Void, Never>? = nil
    
    var products: [Product] = []
    
    private override init() {
        super.init()
        updates = observeTransactionUpdates()
        SKPaymentQueue.default().add(self)
    }
    
    
    
    deinit {
        updates?.cancel()
    }
    
    func setUp(){
        checkTransaction()
        getPurchases()
    }
    
    private func getPurchases(){
        Task {
            do {
                self.products = try await Product.products(for: self.productIds)
            }catch{
                print("error \(error.localizedDescription)")
            }
            
        }
    }
    
    
    static func hasPremium() -> Bool{
        //        return true
        return UserDefaults.standard.bool(forKey: "HAS_PREMIUM")
    }
    
    private func checkTransaction(){
        Task{
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
            UserDefaults.standard.set(!purchasedProductIDs.isEmpty, forKey: "HAS_PREMIUM")
        }
        
    }
    
    func getWeek(_ handler: @escaping((_ product: Product) -> Void)){
        if products.count != 0 {
            DispatchQueue.main.async {
                for product in self.products {
                    if product.id == self.productIds[0]{
                        handler(product)
                        break
                    }
                }
                
            }
        }else{
            Task {
                var counter = 0
                while true {
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                    if products.count != 0 {
                        DispatchQueue.main.async {
                            for product in self.products {
                                if product.id == self.productIds[0]{
                                    handler(product)
                                    break
                                }
                            }
                        }
                        break
                    }
                    counter+=1
                    if counter == 10 {
                        print("no data")
                        break
                    }
                }
            }
        }
        
    }
    
    func getMonth(_ handler: @escaping((_ product: Product) -> Void)){
        if products.count != 0 {
            DispatchQueue.main.async {
                for product in self.products {
                    if product.id == self.productIds[1]{
                        handler(product)
                        break
                    }
                }
                
            }
        }else{
            Task {
                var counter = 0
                while true {
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                    if products.count != 0 {
                        DispatchQueue.main.async {
                            for product in self.products {
                                if product.id == self.productIds[1]{
                                    handler(product)
                                    break
                                }
                                
                            }
                        }
                        break
                    }
                    counter+=1
                    if counter == 10 {
                        break
                    }
                }
            }
        }
        
    }
    
    func getYear(_ handler: @escaping((_ product: Product) -> Void)){
        if products.count != 0 {
            DispatchQueue.main.async {
                for product in self.products {
                    if product.id == self.productIds[2]{
                        handler(product)
                        break
                    }
                }
            }
        }else{
            Task {
                var counter = 0
                while true {
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                    if products.count != 0 {
                        DispatchQueue.main.async {
                            for product in self.products {
                                if product.id == self.productIds[2]{
                                    handler(product)
                                    break
                                }
                            }
                        }
                        break
                    }
                    counter+=1
                    if counter == 10 {
                        break
                    }
                }
            }
        }
        
    }
    
   
    
    func purchase(_ product: Product, _ handler: @escaping((_ result: Bool) -> Void)){
        if purchasedProductIDs.count < 3 {
            if products.count != 0 {
                Task{
                    do {
                        let result = try await product.purchase()
                        
                        switch result {
                        case let .success(.verified(transaction)):
                            print("Success")
                            await transaction.finish()
                            checkTransaction()
                            await handleSuccessfulTransaction(transaction)
                            break
                        case .success(.unverified(_, _)):
                           
                            print("Success unverified")
                            break
                        case .pending:
                           
                            break
                        case .userCancelled:
                            print("Cancel")
                            //
                            // ^^^
                            break
                        @unknown default:
                            break
                        }
                        DispatchQueue.main.async {
                            handler(true)
                        }
                    }catch{
                                handler(false)
                        print(error)
                    }
                }
            }else{
                    handler(false)
                
            }
        }else{
            handler(true)
        }
    }
    
    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) { [unowned self] in
            for await verificationResult in Transaction.updates {
                checkTransaction()
            }
        }
    }
    
    private func handleSuccessfulTransaction(_ transaction: Transaction) async {
        
        
    }
    
    
    
}
