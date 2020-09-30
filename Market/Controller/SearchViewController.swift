//
//  SearchViewController.swift
//  Market
//
//  Created by omair khan on 12/02/1442 AH.
//  Copyright © 1442 Omi Khan. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import EmptyDataSet_Swift

class SearchViewController: UIViewController {

//    MARK: Vars
    var searchResult : [Item] = []
    var activityIndicator : NVActivityIndicatorView?
    
//    MARK: IBOutlets
    @IBOutlet weak var searchOptionView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
//   MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.tableFooterView = UIView()
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Initializing activity indicator view
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60, height: 60), type: .ballPulse, color: #colorLiteral(red: 1.0, green: 0.50, blue: 0.95, alpha: 1.0), padding: nil)
    }
    
// MARK: IBActions
    @IBAction func searchOptionBtnPressed(_ sender: Any) {
        dismissKeyboard()
        emptyTxtField()
        showSearchField()
    }
    
    @IBAction func searchBtnPressed(_ sender: Any) {
        if searchTextField.text != nil {
            // when the user click on search button we will hide the search fields and show results
            searchInFirebase(forname: searchTextField.text!)
            emptyTxtField()
            showSearchField()
            dismissKeyboard()
        }
    }
//    MARK: Search Database
    
    func searchInFirebase(forname: String){
        showLoadingIndicator()
        
        searchAlgolia(searchString: forname) { (itemIds) in
            
            downloadItems(itemIds) { (allItems) in
                
                self.searchResult = allItems
                self.tableView.reloadData()
                
                self.hideLoadingIndicator()
            }
        }
    }
    
//    MARK: Helper Functions
    
    private func emptyTxtField(){
        searchTextField.text = ""
    }
    
    private func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    @objc func textFieldDidChange(_ textField : UITextField){
        print("search field is being edited")
        searchBtn.isEnabled = textField.text != ""
        
        if searchBtn.isEnabled {
            searchBtn.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        }else{
            disableSearchBtn()
        }
    }
    
    private func disableSearchBtn(){
        searchBtn.isEnabled = false
        searchBtn.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
  
//    MARK: Animation functions
    private func showSearchField(){
        UIView.animate(withDuration: 0.5) {
            self.searchOptionView.isHidden = !self.searchOptionView.isHidden
        }
    }
    
//    MARK: Activity Indicator
    
    private func showLoadingIndicator(){
        
        if activityIndicator != nil {
            self.view.addSubview(activityIndicator!)
            activityIndicator!.startAnimating()
        }
    }
    
    private func hideLoadingIndicator(){
    
        if activityIndicator != nil {
            activityIndicator!.removeFromSuperview()
            activityIndicator!.stopAnimating()
        }
    }
    
    func showItem(withItem : Item){
        
        let itemVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "ItemVC") as! ItemViewController
        itemVC.item = withItem
        
        self.navigationController?.pushViewController(itemVC, animated: true)
    }
}

extension SearchViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell
        print(searchResult[indexPath.row].name)
        cell.generateCell(searchResult[indexPath.row])
        return cell
    }
    
//    MARK: TableView Delegates
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showItem(withItem: searchResult[indexPath.row])
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}

extension SearchViewController: EmptyDataSetSource,EmptyDataSetDelegate{
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        return NSAttributedString(string: "No items to display")
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "Please check back later")
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "emptyData")
    }
    
    func buttonImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage? {
        return UIImage(named: "search")
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString? {
        return NSAttributedString(string: "Start searching...")
    }
    
    func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton) {
        showSearchField()
    }
}
