//
//  MainViewController.swift
//  OrderKitchenSystem
//
//  Created by Hao Yu Yeh on 2023/4/18.
//

import UIKit

enum CellID: String {
    case PurchasedItem = "PurchasedItemCell"
    case Catagory = "CatagoryCell"
    case Option = "OptionCell"
    case SubOption = "SubOptionCell"
}


class MainViewController: UIViewController {
    
    private let mainViewModel = MainViewModel()

    @IBOutlet weak var purchasedItemsTableView: UITableView!
    
    @IBOutlet weak var totalPrice: UILabel!
    
    @IBAction func payBtnPressed(_ sender: UIButton) {
        mainViewModel.payBtnPressed()
        self.navigationItem.title = "#\(mainViewModel.getNextOrderNumber())"
        purchasedItemsTableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }

    func config() {
        mainViewModel.config()
        self.navigationItem.title = "#\(mainViewModel.getNextOrderNumber())"
        totalPrice.text = mainViewModel.getSumOfNextOrder()
    }

}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainViewModel.getPurchasedItemCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case purchasedItemsTableView:
            let purchasedItems = mainViewModel.getPurchasedItem()
            let cell = tableView.dequeueReusableCell(withIdentifier: CellID.PurchasedItem.rawValue, for: indexPath) as! PurchasedItemCell
            cell.name.text = purchasedItems[indexPath.row].name!
            cell.quantity.text = String(purchasedItems[indexPath.row].quantity)
            totalPrice.text = mainViewModel.getSumOfNextOrder()
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    
}
