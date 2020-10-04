//
//  ProfileTableViewController.swift
//  Market
//
//  Created by mac retina on 4/11/20.
//  Copyright © 2020 Omi Khan. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    //MARK: IBOutlets
    @IBOutlet weak var finishRegistrationOutLet: UIButton!
    
    @IBOutlet weak var purchaseHistoryBtnOutlet: UIButton!
    
    var editBtnOutlet : UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("I am user dictionary ", UserDefaults.standard.dictionary(forKey: kCURRENTUSER))
        checkLoginStatus()
        checkOnBoardingStatus()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
         
        return 3
    }
    
    //MARK: TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: Helpers
    func checkLoginStatus(){
        if MUser.currentUser() == nil {
            print("Under login status current user", MUser.currentID())

            createRighBarBtn(title: "Login")
            
        }else{
            createRighBarBtn(title: "Edit")
        }
    }
    
    private func createRighBarBtn(title : String){
        
        editBtnOutlet = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(rightBarButtonItemPressed))
        
        self.navigationItem.rightBarButtonItem = editBtnOutlet
    }
    
    private func showLoginView(){
        
        let loginView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "loginView")
        loginView.modalPresentationStyle = .fullScreen
        self.present(loginView, animated: true, completion: nil)
    }
    
    private func goToEditProfile(){
        
        self.performSegue(withIdentifier: "profileEditing", sender: self)
    }
    
    private func checkOnBoardingStatus() {
        
        if MUser.currentUser() != nil {
            if MUser.currentUser()!.onBoard{
                finishRegistrationOutLet.setTitle("Account is active", for: .normal)
                finishRegistrationOutLet.isEnabled = false
                purchaseHistoryBtnOutlet.isEnabled = true
            }else{
                finishRegistrationOutLet.setTitle("Finish Registration", for: .normal)
                finishRegistrationOutLet.isEnabled = true
                finishRegistrationOutLet.tintColor = .red
            }
        }else{
            finishRegistrationOutLet.setTitle("Loged Out", for: .normal)
            finishRegistrationOutLet.isEnabled  = false
            purchaseHistoryBtnOutlet.isEnabled = false
        }
    }
    
    //MARK: IBActions
    
    @objc func rightBarButtonItemPressed(){
        
        if editBtnOutlet.title == "Login"{
            //show login view
            showLoginView()
        }else{
            // go to profile
            goToEditProfile()
        }
    }
}
