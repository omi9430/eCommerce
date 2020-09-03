//
//  FinishRegistrationViewController.swift
//  Market
//
//  Created by mac retina on 4/19/20.
//  Copyright © 2020 Omi Khan. All rights reserved.
//

import UIKit
import JGProgressHUD


class FinishRegistrationViewController: UIViewController {

    
    //MARK: IBOutlets

    @IBOutlet weak var doneButtonOutLet: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surNameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    //MARK: Vars
    
    let hud = JGProgressHUD(style: .dark)
    
    //MARK: View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        surNameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        addressTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
//MARK: IBActions
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        
        finishOnBoarding()
        
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange(_ textField : UITextField){
        
        updateDoneButtonStatus()
    }
    
    //MARK: Helpers
    
    private func updateDoneButtonStatus(){
        
        if nameTextField.text != "" && surNameTextField.text != "" && addressTextField.text != "" {
            doneButtonOutLet.backgroundColor = #colorLiteral(red: 1, green: 0.4250939053, blue: 0.1103114298, alpha: 1)
            doneButtonOutLet.isEnabled = true
        }else{
            doneButtonOutLet.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            doneButtonOutLet.isEnabled = false
        }
    }
    
    private func finishOnBoarding(){
        
        let withValues = [kFIRSTNAME : nameTextField.text!, kLASTNAME : surNameTextField.text!, kONBOARD : true, kFULLADDRESS : addressTextField.text!, kFULLNAME : (nameTextField.text! + " " + surNameTextField.text!)] as! [String : Any]
        
        updateCurrentUserInFireStore(withValues: withValues) { (error) in
            
            if error == nil {
                self.hud.textLabel.text = "Updated successfully"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }else{
                
                print("Error updating user : ", error!.localizedDescription)
                self.hud.textLabel.text = "Error updating your profile  : \(error!.localizedDescription) "
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 4.0)
            }
        }
    }
    
}
