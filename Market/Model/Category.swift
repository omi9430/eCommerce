//
//  Category.swift
//  Market
//
//  Created by mac retina on 2/4/20.
//  Copyright © 2020 Omi Khan. All rights reserved.
//

import Foundation
import UIKit

class Category {
    
    var id : String
    var name : String
    var image : UIImage?
    var imageName : String?
    
    init(_name : String, _imageName: String) {
        
        id = ""
        name = _name
        imageName = _imageName
        image = UIImage(named: _imageName)
    }
    
    init(_dictionary: NSDictionary) {
        id = _dictionary[kOBJECTID] as! String
        name = _dictionary[kNAME] as! String
        image = UIImage(named: _dictionary[kIMAGENAME] as? String ?? "")
    }
}

//MARK: Download Categories
func
    downloadCategoriesFromFireBase(completion: @escaping(_ category : [Category]) -> Void) {
    
    var categoryArray: [Category] = []
    
    FireBaseReference(.Category).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else {
            completion(categoryArray)
            return
        }
        if !snapshot.isEmpty{
            
            for categoryDict in snapshot.documents {
                print(categoryDict)
                categoryArray.append(Category(_dictionary: categoryDict.data() as NSDictionary))
            }
        }
        completion(categoryArray)
        
    }
}

//MARK: Save Category function

func saveCategoryToFirebase(_ category : Category){
    let id = UUID().uuidString
    category.id = id
    
FireBaseReference(.Category).document(id).setData(categoryDictionaryForm(category) as! [String : Any])
}

//MARK: Helpers

func categoryDictionaryForm(_ category : Category)-> NSDictionary {
    return NSDictionary(objects: [category.id,category.name,category.imageName], forKeys: [kOBJECTID as NSCopying, kNAME as NSCopying, kIMAGENAME as NSCopying])
}
// MARK: Run one time only

func createCategorySet(){
    
    let womenClothing = Category(_name: "Womens clothing and Accesories", _imageName: "WomenCloth")
    let footwear = Category(_name: "Foot Wear", _imageName: "footWaer")
    let electronic = Category(_name: "Electronic", _imageName: "electronics")
    let menClothing = Category(_name: "Men's Clothing and Accersorices", _imageName: "menCloth")
    let health = Category(_name: "Healt & Beauty", _imageName: "health")
    let baby = Category(_name: "Baby Stuff", _imageName: "baby")
    let home = Category(_name: "Home & Kitchen", _imageName: "home")
    let car = Category(_name: "Automobile & Motorcycles", _imageName: "car")
    let luggage = Category(_name: "Luggage & bags", _imageName: "luggage")
    let jewellery = Category(_name: "Jewelery", _imageName: "jewelery")
    let hobby = Category(_name: "Hobby, Sports, Travelling", _imageName: "hobby")
    let pet = Category(_name: "pet products", _imageName: "pet")
    let industry = Category(_name: "Industry & Business", _imageName: "industry")
    let garden = Category(_name: "Garden & supplies", _imageName: "garden")
    let camera = Category(_name: "Camera & Optics", _imageName: "camera")
    
    let arrayOfCategories = [womenClothing,footwear,electronic,menClothing,health,baby,home,car,luggage,jewellery,hobby,pet,industry,garden,camera]
    
    for category in arrayOfCategories {
        saveCategoryToFirebase(category)
    }
}


