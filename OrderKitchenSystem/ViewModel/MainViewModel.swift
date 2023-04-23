//
//  MainViewModel.swift
//  OrderKitchenSystem
//
//  Created by Hao Yu Yeh on 2023/4/19.
//

import Foundation
import CoreData
import UIKit

class MainViewModel {
    private let persistenceManager = PersistenceManager.shared
    
    private var ordersMade = 0 // number of orders been taken
    private var currentOrder: Order // current order
    private var purchasedItemOnCurrentOrder:[Item] = []
    
    private var catagories: [Catagory] = [] // sorted by name
    private var currentCatagory: Catagory?
    private var options: [Option] = []
    private var commonOptions: [Option] = []
    
    init() {
        currentOrder = Order(context: persistenceManager.context)
        currentOrder.uuid = UUID()
        currentOrder.createdDate = Date()
    }
    
    /// setup data for further use
    func config() {
        let ordersFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Order")
        // use Date() contains YY:MM:DD:HH:SS
        ordersFetch.predicate = NSPredicate(format: "createdDate >= %@", Calendar.current.startOfDay(for: Date()) as CVarArg)
        do {
            let orders = try persistenceManager.context.fetch(ordersFetch)
            ordersMade = orders.count
            // current order already construct in init
            currentOrder.orderNumber = String(ordersMade)
        }catch {
            print("fetch order failed in MainViewModel")
        }
        
        let catagoriesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Catagory")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        catagoriesFetch.sortDescriptors = [sortDescriptor]
        
        do {
            catagories = try persistenceManager.context.fetch(catagoriesFetch) as! [Catagory]
        }catch {
            print("fetch catagory failed in MainViewModel")
        }
    }
    
    func getCurrentOrderNumber() -> String {
        return currentOrder.orderNumber ?? "fetch orders failed"
    }
    
    private func generateNewOrder() {
        currentOrder = Order(context: persistenceManager.context)
        currentOrder.uuid = UUID()
        currentOrder.createdDate = Date()
        purchasedItemOnCurrentOrder = []
    }
}
// setup for all purchased items related
extension MainViewModel {
    
    /// whenever adding a purchased item, this function will update the 'purchasedItemOnCurrentOrder' to the latest
    func updatePurchasedItemList() {
        purchasedItemOnCurrentOrder = []
        purchasedItemOnCurrentOrder = currentOrder.has?.allObjects as! [Item]
    }
    
    /// return the column number for the purchasedItemsTableView
    /// - Returns: Int
    func getPurchasedItemCount() -> Int {
        return purchasedItemOnCurrentOrder.count
    }
    
    /// return purchased items for generate cells of purchasedItemsTableView
    /// - Returns: [Item]
    func getPurchasedItems() -> [Item] {
        return purchasedItemOnCurrentOrder
    }
    
    /// calculate the total price of purchased items
    /// - Returns: String: price in String format
    func getSumOfCurrentOrder() -> String {
        var sum = 0.0
        for item in purchasedItemOnCurrentOrder {
            sum += (Double(item.quantity) * item.unitPrice)
        }
        return String(sum)
    }
    
    /// save all changes of current order and generate next order
    func payBtnPressed() {
        persistenceManager.save()
        ordersMade += 1
        generateNewOrder()
        currentOrder.orderNumber = String(ordersMade)
    }
}
// setup for catagory table view
extension MainViewModel {
    /// return the column number for the catagoriesTableView
    /// - Returns: Int
    func getCatagoriesCount() -> Int {
        return catagories.count
    }
    
    /// return all catagories for generate cells of catagoriesTableView
    /// - Returns: [Item]
    func getCatagories() -> [Catagory] {
        return catagories
    }
}
// setup for menu options
extension MainViewModel {
    
    /// one catagory contains two kinds of options: normal option as dishes and common option for all dishes
    /// therefore, it should be splitted for further display
    /// - Parameter index: indicate which catagory been selected now
    func splitOptionsFromCatagory(at index: Int) {
        currentCatagory = catagories[index]
        options = []
        commonOptions = []
        var unSplitOptions = currentCatagory?.has?.allObjects as! [Option]
        unSplitOptions.sort { o1, o2 in
            if o1.name! < o2.name! {
                return true
            }else {
                return false
            }
        }
        for option in unSplitOptions {
            if option.common {
                commonOptions.append(option)
            }else {
                options.append(option)
            }
        }
    }
    
    /// return the option number for the catagory
    /// - Returns: Int
    func getOptionsCount() -> Int {
        return options.count
    }
    /// return options for generate cells of optionCollectionView
    /// - Returns: [Option]
    func getOptions() -> [Option] {
        return options
    }
    /// return the common option number for the option
    /// - Returns: Int
    func getCommonOptionsCount() -> Int {
        return commonOptions.count
    }
    /// return common options for generate cells of option
    /// - Returns: [Option]
    func getCommonOptions() -> [Option] {
        return commonOptions
    }
}
