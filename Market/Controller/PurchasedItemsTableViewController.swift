//
//  PurchasedItemsTableViewController.swift
//  Market
//
//  Created by omair khan on 10/02/1442 AH.
//  Copyright © 1442 Omi Khan. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift
class PurchasedItemsTableViewController: UITableViewController {

    //MARK: Vars
    
    var itemArray = [Item]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell
        cell.generateCell(itemArray[indexPath.row])
        return cell
    }

    private func loadItems() {
        
        downloadItems(MUser.currentUser()!.purchasedItemIds) { (allItems) in
            self.itemArray = allItems
            self.tableView.reloadData()
        }
    }
}

extension PurchasedItemsTableViewController: EmptyDataSetSource,EmptyDataSetDelegate{

func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
    
    return NSAttributedString(string: "You haven't bought anything.")
}

func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
    return NSAttributedString(string: "Start shopping now..")
}

func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
    return UIImage(named: "emptyData")
}
}
