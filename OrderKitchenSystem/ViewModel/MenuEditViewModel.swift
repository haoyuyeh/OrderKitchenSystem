//
//  MenuEditViewModel.swift
//  OrderKitchenSystem
//
//  Created by Hao Yu Yeh on 2023/4/23.
//

import Foundation
import CoreData

class MenuEditViewModel{
    private let persistenceManager = PersistenceManager.shared
    
    private var catagories: [Catagory] = []
    private var currentCatagory: Catagory?
    private var options: [Option] = []
    private var commonOptions: [Option] = []
    
}
// funcs for catagories table view
extension MenuEditViewModel {
    /// whenever adding a catagory, this function will update the 'catagories' to the latest
    func updateCatagoryList() {
        let catagoryFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Catagory")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        catagoryFetch.sortDescriptors = [sortDescriptor]
        
        do {
            catagories = try persistenceManager.context.fetch(catagoryFetch) as! [Catagory]
        }catch {
            print("fetch Catagory failed in MenuEditViewController")
        }
    }
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

extension MenuEditViewModel {
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
