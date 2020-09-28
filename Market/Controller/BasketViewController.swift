//
//  BasketViewController.swift
//  Market
//
//  Created by mac retina on 3/28/20.
//  Copyright © 2020 Omi Khan. All rights reserved.
//

import UIKit
import JGProgressHUD
import Braintree
import BraintreeDropIn

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
    var envoirment : String = PayPalEnvironmentNoNetwork {
        willSet (newEnvoirment){
            if (newEnvoirment != envoirment){
                PayPalMobile.preconnect(withEnvironment: newEnvoirment)
            }
        }
    }
   
    var braintreeClient: BTAPIClient?
    //MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = footerView
        braintreeClient = BTAPIClient(authorization: "sandbox_rz35t89r_nnfdkk367hn47vrc")!
       
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if MUser.currentUser() != nil {
            loadBasketFromFirebase()
            updateLabels()
        }else{
            self.updateTotalLabels(true)
        }
        
    }

    //MARK: IBAction
    @IBAction func checkOutBtnPressed(_ sender: Any) {
        
        if MUser.currentUser()!.onBoard{
            //Proceed with purchase
            payButtonPressed()
            
        }else{
            self.hud.textLabel.text = "Please  complete your profile!"
            self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
            self.hud.show(in: self.view)
            self.hud.dismiss(afterDelay: 2.0)
        }
    }
    
    //MARK: Functions
    private func loadBasketFromFirebase(){
        
        downloadBasketFromFireStore(MUser.currentID()) { (basket) in
            
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
        }else{
            self.checkOutBtnView.isEnabled = true
            self.checkOutBtnView.alpha = 0.0
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
    
    //MARK: Helper function
    
    func updateTotalLabels(_ isEmpty : Bool){
        
        if isEmpty {
            itemsInBasketLabel.text = "0"
        }else{
            itemsInBasketLabel.text = "\(allItems.count)"
        }
    }

    private func emptyTheBasket(){
        purchasedItemIds.removeAll()
        allItems.removeAll()
        tableView.reloadData()
        basket!.itemIds = []
        updateBasketInFireStore(basket!, withValues: [KITEMIDS : basket!.itemIds]) { (error) in
            
            if error == nil {
                self.getBasketItems()
            }else{
                print(error?.localizedDescription)
            }
        }
    }
    
    private func addItemsToPurchasedHistory(_ itemIds : [String]){
        
        if MUser.currentUser() != nil {
            
            let newItemIds = MUser.currentUser()!.purchasedItemIds + itemIds
            
            updateCurrentUserInFireStore(withValues: [kPURCHASEDITEMIDS : newItemIds]) { (error) in
                
                if error != nil {
                    print("Cannot add items to history ", error?.localizedDescription)
                }
            }
        }
    }
    
//    MARK: PayPal with braintree
 private func payButtonPressed() {
        
       var itemsToBuy :  [BTPayPalLineItem] = []
        var subTotal = 0.0

        for item in allItems {
//
            let tempItem = BTPayPalLineItem(quantity: "1", unitAmount: String(format: "%f", item.price), name: item.name, kind: .debit)
//            purchasedItemIds.append(item.id)
            itemsToBuy.append(tempItem)
//            emptyTheBasket()
//            updateTotalLabels(true)
        }
        
        for items in allItems {
            subTotal += items.price
        }

    // Specify the transaction amount here. "2.32" is used in this example.
        let request = BTPayPalRequest(amount: String(format: "%f", subTotal))
        request.currencyCode = "USD" // Optional; see BTPayPalRequest.h for more options
        request.lineItems = itemsToBuy
        request.isShippingAddressEditable = true
        
        
        let payPalDriver = BTPayPalDriver(apiClient: braintreeClient!)
        payPalDriver.viewControllerPresentingDelegate = self
        payPalDriver.appSwitchDelegate = self
        payPalDriver.requestOneTimePayment(request) { (tokenizedPayPalAccount, error) in
        if let tokenizedPayPalAccount = tokenizedPayPalAccount {
            print("Got a nonce: \(tokenizedPayPalAccount.nonce)")

            // Access additional information
            let email = tokenizedPayPalAccount.email
            let firstName = tokenizedPayPalAccount.firstName
            let lastName = tokenizedPayPalAccount.lastName
            let phone = tokenizedPayPalAccount.phone

            // See BTPostalAddress.h for details
            let billingAddress = tokenizedPayPalAccount.billingAddress
            let shippingAddress = tokenizedPayPalAccount.shippingAddress
            self.addItemsToPurchasedHistory(self.purchasedItemIds)
            self.emptyTheBasket()
            self.fadeBtn()
            
        } else if let error = error {
            // Handle error here...
            
            print("I am error at paypal checkout ", error.localizedDescription)
        }else {
            // Buyer canceled payment approval
            self.dismiss(animated: true, completion: nil)
            }
    }
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

extension BasketViewController: BTViewControllerPresentingDelegate,BTAppSwitchDelegate{

    func paymentDriver(_ driver: Any, requestsPresentationOf viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }

    func paymentDriver(_ driver: Any, requestsDismissalOf viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    func showLoadingUI() {
        // ...
    }
   @objc func hideLoadingUI() {
        NotificationCenter
            .default
            .removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        // ...
    }
    

    // MARK: - BTAppSwitchDelegate


    // Optional - display and hide loading indicator UI
    func appSwitcherWillPerformAppSwitch(_ appSwitcher: Any) {
        showLoadingUI()

        NotificationCenter.default.addObserver(self, selector: #selector(hideLoadingUI), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    func appSwitcherWillProcessPaymentInfo(_ appSwitcher: Any) {
        hideLoadingUI()
    }

    func appSwitcher(_ appSwitcher: Any, didPerformSwitchTo target: BTAppSwitchTarget) {

    }

}
