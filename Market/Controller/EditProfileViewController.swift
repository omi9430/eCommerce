//
//  EditProfileViewController.swift
//  Market
//
//  Created by mac retina on 4/20/20.
//  Copyright © 2020 Omi Khan. All rights reserved.
//

import UIKit
import JGProgressHUD

class EditProfileViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var surNameTxtField: UITextField!
    @IBOutlet weak var addressTxtField: UITextField!
    
    //MARK: Vars
    let hud = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

   //MARK: IBActions
    
    @IBAction func logOutBtnPressed(_ sender: Any) {
        
        MUser.logOutCurrentUser { (Error) in
            
            if Error == nil {
                print("logged out")
                self.navigationController?.popViewController(animated: true)
            }else{
                self.hud.textLabel.text = Error?.localizedDescription
                               self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                               self.hud.show(in: self.view)
                               self.hud.dismiss(afterDelay: 2.0)
            }
        }
        
    }
    @IBAction func saveBtnPressed(_ sender: Any) {
        
        if textFieldHaveText() {
                
        }else{
            
            self.hud.textLabel.text = "Error updating your profile "
            self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
            self.hud.show(in: self.view)
            self.hud.dismiss(afterDelay: 4.0)
            
        }
    }
    
    
    //MARK: Update UI
    
    func loadUserInfor() {
        
        if MUser.currentUser() != nil {
            
            let currentUser = MUser.currentUser()
            
            nameTxtField.text = MUser.currentUser()?.firstName
            surNameTxtField.text = MUser.currentUser()?.LastName
            addressTxtField.text = MUser.currentUser()?.fullAddress
        }
    }
    
    //MARK: Helpers
    
    func textFieldHaveText() -> Bool{
        
        return nameTxtField.text != "" && surNameTxtField.text != "" && addressTxtField.text != ""
    }
    
    private func logOutUser(){
        MUser.logOutCurrentUser { (error) in
            if error == nil {
                print("Logged out")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
