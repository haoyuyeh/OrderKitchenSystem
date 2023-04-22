//
//  MainViewModel.swift
//  OrderKitchenSystem
//
//  Created by Hao Yu Yeh on 2023/4/19.
//

import Foundation
import CoreData

class MainViewModel {
    private let persistenceManager = PersistenceManager.shared
    
    private var currentOrderNumber = 0 // numbers of all processed orders
    private var nextOrder: Order // current order
    private var purchasedItemOnNextOrder:[Item] = []
    
    private var catagories: [Catagory] = [] // sorted by name
    
    
    init() {
        nextOrder = Order(context: persistenceManager.context)
        nextOrder.uuid = UUID()
        nextOrder.createdDate = Date()
    }
    
    /// setup data for further use
    func config() {
        let ordersFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Order")
        // use Date() contains YY:MM:DD:HH:SS
        ordersFetch.predicate = NSPredicate(format: "createdDate >= %@", Calendar.current.startOfDay(for: Date()) as CVarArg)
        do {
            let orders = try persistenceManager.context.fetch(ordersFetch)
            currentOrderNumber = orders.count
            nextOrder.orderNumber = String(currentOrderNumber)
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
    
    func getNextOrderNumber() -> String {
        return nextOrder.orderNumber ?? "fetch orders failed"
    }
    
    private func generateNextOrder() {
        nextOrder = Order(context: persistenceManager.context)
        nextOrder.uuid = UUID()
        nextOrder.createdDate = Date()
        purchasedItemOnNextOrder = []
    }
}
// setup for all purchased items related
extension MainViewModel {
    
    /// return the column number for the purchasedItemsTableView
    /// - Returns: Int
    func getPurchasedItemCount() -> Int {
        print("getPurchasedItemCount called. --------------------------------------------------")
        purchasedItemOnNextOrder = nextOrder.has?.allObjects as! [Item]
        return purchasedItemOnNextOrder.count
    }
    
    /// return purchased items for generate cells of purchasedItemsTableView
    /// - Returns: [Item]
    func getPurchasedItem() -> [Item] {
        print("getPurchasedItem called. --------------------------------------------------")
        return purchasedItemOnNextOrder
    }
    
    /// calculate the total price of purchased items
    /// - Returns: String: price in String format
    func getSumOfNextOrder() -> String {
        var sum = 0.0
        for item in purchasedItemOnNextOrder {
            sum += (Double(item.quantity) * item.unitPrice)
        }
        return String(sum)
    }
    
    /// save all changes of current order and generate next order
    func payBtnPressed() {
        persistenceManager.save()
        currentOrderNumber += 1
        generateNextOrder()
        nextOrder.orderNumber = String(currentOrderNumber)
    }
}
// setup for catagory table view
extension MainViewModel {
    /// return the column number for the catagoriesTableView
    /// - Returns: Int
    func getCatagoriesCount() -> Int {
        return catagories.count
    }
    /// return purchased items for generate cells of purchasedItemsTableView
    /// - Returns: [Item]
    func getCatagories() -> [Catagory] {
        return catagories
    }
}
// setup for menu options
extension MainViewModel {
    /// return the option number for the catagory
    /// - Returns: Int
    func getOptionsCount(at catagoryIndex: Int) -> Int {
        return catagories[catagoryIndex].has?.allObjects.count ?? 0
    }
    /// return options for generate cells of optionCollectionView
    /// - Returns: [Option]
    func getOptions(at catagoryIndex: Int) -> [Option] {
        var options = catagories[catagoryIndex].has?.allObjects as! [Option]
        options.sort { o1, o2 in
            return o1.name! < o2.name! ? true : false
        }
        return options
    }
    /// return the sub-option number for the option
    /// - Returns: Int
    func getSubOptionsCount(of option: Option) -> Int {
        return option.next?.allObjects.count ?? 0
    }
    /// return sub-options for generate cells of option
    /// - Returns: [Option]
    func getSubOptions(of option: Option) -> [Option] {
        return option.next?.allObjects as! [Option]
    }
}
