//
//  Basket.swift
//  Market
//
//  Created by mac retina on 3/27/20.
//  Copyright © 2020 Omi Khan. All rights reserved.
//

import Foundation
class Basket {
    var id : String!
    var ownerId : String!
    var itemIds : [String]!
    
    init() {
        
    }
    
    init(_dictionary: NSDictionary){
        
        id = _dictionary[kOBJECTID] as? String
        ownerId = _dictionary[KOWNERID] as? String
        itemIds = _dictionary[KITEMIDS] as? [String]
        
        
    }
}
//MARK: Download from Firestore

func downloadBasketFromFireStore(_ ownerId: String, completion: @escaping (_ basket: Basket?)-> Void){
    
    FireBaseReference(.Basket).whereField(KOWNERID, isEqualTo: ownerId).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else {
            completion(nil)
            return
        }
        
        if !snapshot.isEmpty && snapshot.documents.count > 0 {
            let basket = Basket(_dictionary: snapshot.documents.first!.data() as NSDictionary)
            completion(basket)
        }else{
            completion(nil)
        }
    }
    
}

//MARK: Save to Firestore
func saveBasketToFirestore(_ bakset : Basket){
    
    FireBaseReference(.Basket).document(bakset.id).setData(basketToDictionary(bakset) as! [String : Any])
}

//MARK: Update Basket

func updateBasketInFireStore(_ basket : Basket, withValues : [String : Any], completion: @escaping (_ error : Error?) -> Void){
    
    FireBaseReference(.Basket).document(basket.id).updateData(withValues) { (error) in
        
       completion(error)
    }
}

//Helpers

func basketToDictionary(_ basket: Basket) -> NSDictionary {
    
    return NSDictionary(objects: [basket.id,basket.ownerId,basket.itemIds], forKeys: [kOBJECTID as NSCopying,KOWNERID as NSCopying, KITEMIDS as NSCopying])
}
