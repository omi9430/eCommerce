//
//  ItemsTableViewController.swift
//  Market
//
//  Created by mac retina on 2/12/20.
//  Copyright © 2020 Omi Khan. All rights reserved.
//

import UIKit

class ItemsTableViewController: UITableViewController {
    
    //Mark: vars
    var category : Category?
    var itemArray : [Item] = []
    var heightForRow = 100
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        self.navigationItem.title = category?.name
        self.view.backgroundColor = UIColor.white
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell
        
        
        cell.layer.shadowOffset = .zero
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 1
        cell.layer.shadowRadius = 10
        
        cell.backgroundColor = UIColor.clear
       
        cell.generateCell(itemArray[indexPath.row])
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        showItemView(itemArray[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "itemsToAddItem" {
            let vc = segue.destination as! AddItemViewController
            vc.category = category!
        }
    }
    
    //MARK: Retrieve data from database
    
    func loadItems() {
        
        downloadItemsFromFirebase(category!.id) { (allItems) in
            self.itemArray = allItems
            self.tableView.reloadData()
        }
        
    }
    
    //MARK: Show Item
    
    func showItemView(_ item : Item) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier:"ItemVC") as! ItemViewController
        vc.item = item
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
