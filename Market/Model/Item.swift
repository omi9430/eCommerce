//
//  Item.swift
//  Market
//
//  Created by mac retina on 2/12/20.
//  Copyright © 2020 Omi Khan. All rights reserved.
//

import Foundation
import UIKit


class Item {
    
    var id : String!
    var categoryId : String!
    var name : String!
    var description : String!
    var price : Double!
    var imageLinks : [String]!
    
    init() {
    }
    
    init(_dictionary: NSDictionary) {
        id = _dictionary[kOBJECTID] as? String
        categoryId = _dictionary[kCATEGORYID] as? String
        name = _dictionary[kNAME] as? String
        description = _dictionary[kDESCRPTION] as? String
        price = _dictionary[kPRICE] as? Double
        imageLinks = _dictionary[kIMAGELINK] as? [String]
    }
}
    //Mark : Save Data to Firestore
    
    func saveItemToFireStore(_ item: Item){
        FireBaseReference(.Items).document(item.id).setData(itemDictionaryFrom(item) as! [String : Any])
    }
    
    //Mark : Helpers
    
    func itemDictionaryFrom(_ item: Item) -> NSDictionary{
        
        return NSDictionary(objects: [item.categoryId,item.id,item.name,item.description,item.price,item.imageLinks], forKeys: [kCATEGORYID as NSCopying, kOBJECTID as NSCopying,kNAME as NSCopying,kDESCRPTION as NSCopying,kPRICE as NSCopying,kIMAGELINK as NSCopying])
    }

// Mark: Download Items from firebase

func downloadItemsFromFirebase(_ withCategoryId: String, completion: @escaping (_ itemArray : [Item]) -> Void){
    
    var itemArray : [Item] = []
    
    FireBaseReference(.Items).whereField(kCATEGORYID, isEqualTo: withCategoryId).getDocuments { (Snapshot, Error) in
        
        guard let snapshot = Snapshot else {
            completion(itemArray)
            return
        }
        
        if !snapshot.isEmpty {
            
            for item in snapshot.documents {
                
                itemArray.append(Item(_dictionary: item.data() as NSDictionary))
            }
        }
        
        completion(itemArray)
    }
    
}

func downloadItems(_ withIds : [String], completion: @escaping (_ itemArray: [Item]) -> Void){
    
    var count = 0
    var itemArray: [Item] = []
    
    if withIds.count > 0 {
        
        for itemId in withIds {
            
            FireBaseReference(.Items).document(itemId).getDocument { (snapshot, error) in
                
                guard let snapshot = snapshot else {
                    completion(itemArray)
                    return
                }
                
                if snapshot.exists {
                    itemArray.append(Item(_dictionary: snapshot.data()! as NSDictionary))
                    count += 1
                }else {
                    
                    completion(itemArray)
                }
                if count == withIds.count {
                    completion(itemArray)
                }
            }
        }
    }else{
        completion(itemArray)
    }
}

//MARK: Algolia Funcs

func saveItemToAlgolia(item: Item){
    
    let index = AlgoliaService.shared.index
    let itemToSave = itemDictionaryFrom(item) as! [String : Any]
    
    index.addObject(itemToSave, withID: item.id, requestOptions: nil) { (result, error) in
        
        if error != nil {
            print("Cannot save to algolia ",error?.localizedDescription)
        }else{
            print("Added to algolia successfully")
        }
    }
    
}
