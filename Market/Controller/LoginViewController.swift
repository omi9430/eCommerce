//
//  LoginViewController.swift
//  Market
//
//  Created by mac retina on 3/29/20.
//  Copyright © 2020 Omi Khan. All rights reserved.
//

import UIKit
import JGProgressHUD
import NVActivityIndicatorView

class LoginViewController: UIViewController {
    
    //MARK: IBOutlets
    
    @IBOutlet weak var emailTxtField: UITextField!
    
    @IBOutlet weak var passwordTxtField: UITextField!
    
    @IBOutlet weak var resendEmailBtnOutlet: UIButton!
    //MARK: Vars
    let hud = JGProgressHUD(style: .dark)
    var activityIndicator : NVActivityIndicatorView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        resendEmailBtnOutlet.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width/2 - 30, y: self.view.frame.height/2 - 30, width: 60.0, height: 60.0), type: .ballPulse, color: #colorLiteral(red: 0.9998469949, green: 0.4941213727, blue: 0.4734867811, alpha: 1.0), padding: nil)
    }
    //MARK: IBActions
    @IBAction func cancelBtn(_ sender: Any) {
        dismissView()
    }

    @IBAction func forgotPasswordBtn(_ sender: Any) {
        
        if emailTxtField.text != "" {
            resetPass()
        }else{
            hud.textLabel.text = "Please insert Email"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
        }
    }
    
    @IBAction func resendEmailBtn(_ sender: Any) {
        
        MUser.resendVerification(email: emailTxtField.text!) { (error) in
            
            print("Error resending email: ", error!.localizedDescription)
        }
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        signInUser()
        
    }
    
    @IBAction func registerBtn(_ sender: Any) {
        
        if textFieldsHaveText() {
            registerUser()
        }else{
            hud.textLabel.text = "All fields are required"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
        }
    }
    
    
    //MARK : funcitions
    
    private func dissmiss(){
        self.dismiss(animated: true, completion: nil)
    }
    
    private func textFieldsHaveText() -> Bool {
        return ( emailTxtField.text != "" && passwordTxtField.text != "")
    }
    
    private func showLoadingIndicator() {
        if activityIndicator == nil {
            self.view.addSubview(activityIndicator!)
            activityIndicator!.startAnimating()
        }
    }
    
    private func stopLoadingIndicator() {
        if activityIndicator != nil {
            activityIndicator!.removeFromSuperview()
            activityIndicator?.startAnimating()
        }
    }
    
    private func signInUser() {
        
        showLoadingIndicator()
        
        MUser.login(email: emailTxtField.text!, password: passwordTxtField.text!) { (error, isEmailVerified) in
            
            if error == nil {
                if isEmailVerified{
                    self.dismissView()
                    print("Email is Verified")
                }else {
                    self.hud.textLabel.text = "Please verify your email"
                    self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                    self.resendEmailBtnOutlet.isHidden = false
                    
                }
            }else{
                print("I am Login Error",error?.localizedDescription)
                self.hud.textLabel.text = "\(error?.localizedDescription)"
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
        }
        
        stopLoadingIndicator()
    }
    
    private func resetPass(){
        
        MUser.forgotPassword(email: emailTxtField.text!) { (error)  in
            
            if error == nil {
                self.hud.textLabel.text = "Email Sent"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }else {
                self.hud.textLabel.text = "\(error!.localizedDescription)"
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
        }
    }
    
    private func registerUser() {
        showLoadingIndicator()
        
        MUser.registerUser(_email: emailTxtField.text!, _password: passwordTxtField.text!) { (error) in
            
            if error == nil {
                
                self.hud.textLabel.text = "Verification Email sent"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
                
            }else {
                print("I am registration Error",error?.localizedDescription)
                self.hud.textLabel.text = "\(error?.localizedDescription)"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
            self.stopLoadingIndicator()
        }
    }
    
    //MARK: Helper funcs
    
    func dismissView(){
        self.dismiss(animated: true, completion: nil)
    }
}
