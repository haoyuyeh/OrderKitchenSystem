//
//  MainViewController.swift
//  OrderKitchenSystem
//
//  Created by Hao Yu Yeh on 2023/4/18.
//

import UIKit

class MainViewController: UIViewController {
    
    private var mainViewModel = MainViewModel()
    
    @IBOutlet weak var moreBtn: UIButton!
    
    
    @IBOutlet weak var purchasedItemsTableView: UITableView!
    
    @IBOutlet weak var totalPrice: UILabel!
    
    @IBAction func payBtnPressed(_ sender: UIButton) {
        mainViewModel.payBtnPressed()
        self.navigationItem.title = "#\(mainViewModel.getCurrentOrderNumber())"
        purchasedItemsTableView.reloadData()
    }
    
    @IBOutlet weak var catagoryTableView: UITableView!
    
    @IBOutlet weak var optionsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    func config() {
        mainViewModel.config()
        self.navigationItem.title = "#\(mainViewModel.getCurrentOrderNumber())"
        moreBtn.showsMenuAsPrimaryAction = true
        moreBtn.menu = UIMenu(children:[
            UIAction(title: "Menu Edit", handler: { action in
                self.performSegue(withIdentifier: "toMenuEditVC", sender: action)
            }),
            UIAction(title: "Historical Orders", handler: { action in
                print("Historical Orders")
            }),
            UIAction(title: "Settings", handler: { action in
                print("Settings")
            })
        ])
        totalPrice.text = mainViewModel.getSumOfCurrentOrder()
        // make sure showing the first catagory and its options whenever the app runs up.
        catagoryTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: UITableView.ScrollPosition.none)
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case purchasedItemsTableView:
            return mainViewModel.getPurchasedItemCount()
        case catagoryTableView:
            return mainViewModel.getCatagoriesCount()
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case purchasedItemsTableView:
            let purchasedItems = mainViewModel.getPurchasedItems()
            let cell = tableView.dequeueReusableCell(withIdentifier: PurchasedItemCell.identifier, for: indexPath) as! PurchasedItemCell
            cell.name.text = purchasedItems[indexPath.row].name!
            cell.quantity.text = String(purchasedItems[indexPath.row].quantity)
            totalPrice.text = mainViewModel.getSumOfCurrentOrder()
            return cell
        case catagoryTableView:
            let catagory = mainViewModel.getCatagories()
            let cell = tableView.dequeueReusableCell(withIdentifier: CatagoryCell.identifier, for: indexPath) as! CatagoryCell
            cell.name.text = catagory[indexPath.row].name
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch tableView {
        case purchasedItemsTableView:
            // pop up a num pad to change the quantity of the selected purchased item
            
            break
        case catagoryTableView:
            // prepare the data for optionsCollectionView
            mainViewModel.splitOptionsFromCatagory(at: indexPath.row)
            optionsCollectionView.reloadData()
        default:
            break
        }
    }
}

extension MainViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2 // dishes and common options
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return mainViewModel.getOptionsCount()
        case 1:
            return mainViewModel.getCommonOptionsCount()
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let options = mainViewModel.getOptions()
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OptionCell.identifier, for: indexPath) as! OptionCell
            cell.name.text = options[indexPath.row].name
            return cell
        case 1:
            let commonOptions = mainViewModel.getCommonOptions()
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommonOptionCell.identifier, for: indexPath) as! CommonOptionCell
            cell.name.text = commonOptions[indexPath.row].name
            cell.checkMarkImage.image = UIImage(named: "checkmark.square")
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            // header
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                             withReuseIdentifier: HeaderCollectionReusableView.identifier,
                                                                             for: indexPath) as! HeaderCollectionReusableView
            switch indexPath.section {
            case 0:
                headerView.title.text = "Dishes"
                return headerView
            case 1:
                headerView.title.text = "Common Options"
                return headerView
            default:
                return UICollectionReusableView()
            }
        }else {
            return UICollectionReusableView()
        }
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            // add the dish to purchased item or
            // navigate to the view showing sub-options of selected dish, if there are sub-options
            break
        case 1:
            // change the image of selected common option to "checkmark.square.fill" and mark the option checked.
            break
        default:
            break
        }
    }
}
