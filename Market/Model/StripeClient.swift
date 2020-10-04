//
//  StripeClient.swift
//  Market
//
//  Created by omair khan on 14/02/1442 AH.
//  Copyright © 1442 Omi Khan. All rights reserved.
//

import Foundation
import Stripe
import Alamofire

class StripeClient {
    
    static let sharedClient = StripeClient()
    var baseURLString : String? = nil
    
    var baseURL : URL {
        if let urlString = self.baseURLString, let url = URL(string: urlString){
            return url
        }else{
            fatalError()
        }
    }
    
    // Take the payment and pass it to our backend using the below function
    
    func createAndConfirmThePayment(_ token : STPToken, Amount: Int, completion: @escaping(_ error : Error?) -> Void){
        
        let url = self.baseURL.appendingPathComponent("Charge")
        
        let params: [String: Any] =  ["stripeToken": token.tokenId, "amount": Amount, "description" : Constants.defaultDescription, "currency" : Constants.defaultCurrency]
        
        Alamofire.AF.request(url, method: .post, parameters: params).validate(statusCode : 200..<300).responseData { (response) in
            
            switch response.result{
            case.success( _):
                print("Payment successfull with stripe")
                completion(nil)
            case.failure(let error):
                print("Error with pyament", error.localizedDescription)
                completion(error)
                
            }
        }
    }
    
}
