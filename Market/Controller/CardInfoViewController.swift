//
//  CardInfoViewController.swift
//  Market
//
//  Created by omair khan on 17/02/1442 AH.
//  Copyright © 1442 Omi Khan. All rights reserved.
//

import UIKit
import Stripe

protocol CardInfoViewControllerDelegate {
    
    func didClickDone(_ token: STPToken)
    func didClickCancel()
}

class CardInfoViewController: UIViewController {

//    MARK: IBOutlets
    @IBOutlet weak var doneBtn: UIButton!
    let paymentCardTextField = STPPaymentCardTextField()
    var delegate : CardInfoViewControllerDelegate?

//    MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        paymentCardTextField.delegate = self
        view.addSubview(paymentCardTextField)
        paymentCardTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: paymentCardTextField, attribute: .top, relatedBy: .equal, toItem: doneBtn, attribute: .bottom, multiplier: 1, constant: 30))
        view.addConstraint(NSLayoutConstraint(item: paymentCardTextField, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20))
        view.addConstraint(NSLayoutConstraint(item: paymentCardTextField, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20))
    }
    
    
//    MARK: IBActions
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        self.delegate?.didClickCancel()
        self.dismissView()
    }
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        processCard()
        self.dismissView()
    }
    
    
//     MARK: Helper function
    
    func dismissView(){
        self.dismiss(animated: true, completion: nil)
    }

    func processCard(){
        
        let cardParams = STPCardParams()
        cardParams.number = paymentCardTextField.cardNumber
        cardParams.expMonth = paymentCardTextField.expirationMonth
        cardParams.expYear  = paymentCardTextField.expirationYear
        cardParams.cvc  = paymentCardTextField.cvc
        
        STPAPIClient.shared().createToken(withCard: cardParams) { (token, error) in
            
            if error == nil {
                self.delegate?.didClickDone(token!)
            }else{
                print("Error processisng payment with card", error?.localizedDescription)
                
            }
        }
        
    }
}

extension CardInfoViewController: STPPaymentCardTextFieldDelegate{
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        
        self.doneBtn.isEnabled = textField.isValid
    }
}
