//
//  BasketViewController.swift
//  Market
//
//  Created by mac retina on 3/28/20.
//  Copyright © 2020 Omi Khan. All rights reserved.
//

import UIKit
import JGProgressHUD

class BasketViewController: UIViewController {

    
    //MARK:IBOutlets
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var itemsInBasketLabel: UILabel!
    
    @IBOutlet weak var checkOutBtnView: UIButton!
    @IBOutlet weak var noOfItemsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var basketTotal: UILabel!
    
    //MARK: Vars
    var basket: Basket?
    var allItems : [Item] = []
    var purchasedItemIds : [String] = []
    
    let hud = JGProgressHUD(style: .dark)
    //MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = footerView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadBasketFromFirebase()
    }

    //MARK: IBAction
    @IBAction func checkOutBtnPressed(_ sender: Any) {
    }
    
    //MARK: Functions
    private func loadBasketFromFirebase(){
        
        downloadBasketFromFireStore("1234") { (basket) in
            
            self.basket = basket
            self.getBasketItems()
        }
    }
    
    private func getBasketItems() {
        
        if basket != nil {
            downloadItems(basket!.itemIds) { (alitems) in
                self.allItems = alitems
                self.updateLabels()
                self.tableView.reloadData()
            }
        }else {
            self.basketTotal.text = "0"
                            self.noOfItemsLabel.text = "0"
                            self.fadeBtn()
        }
    }
    
    private func updateLabels(){
        
        self.noOfItemsLabel.text = "\(allItems.count)"
        self.basketTotal.text = "\(totalPrice())"
    }
    
    private func totalPrice() -> String {
        
        var total = 0.0
        
        for item in allItems {
            
            total += item.price
        }
        
        return "Total price: " + convertCurrecny(total)
    }
    
    private func fadeBtn(){
        
        if allItems.count == 0 {
            
            self.checkOutBtnView.isEnabled = false
            self.checkOutBtnView.alpha = 0.5
        }
    }
    
    private func deleteItemFromBasket(_ itemId : String){
        
        for i in 0..<basket!.itemIds.count {
            
            if itemId == basket!.itemIds[i]{
                basket?.itemIds.remove(at: i)
            }
        }
    }
    
    func showItemView(_ item : Item) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier:"ItemVC") as! ItemViewController
        vc.item = item
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
}

extension BasketViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell
        
        cell.generateCell(allItems[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        showItemView(allItems[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if  editingStyle == .delete {
            
            let itemToDelete = allItems[indexPath.row]
            
            allItems.remove(at: indexPath.row)
            tableView.reloadData()
            
            deleteItemFromBasket(itemToDelete.id)
            
            updateBasketInFireStore(basket!, withValues: [KITEMIDS : basket!.itemIds]) { (error) in
            
                if error != nil {
                    print("error updating the basket",error?.localizedDescription)
                }else{
                    self.getBasketItems()
                }
            }
        }
    }
}
