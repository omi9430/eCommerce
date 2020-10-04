//
//  Constants.swift
//  Market
//
//  Created by mac retina on 2/6/20.
//  Copyright © 2020 Omi Khan. All rights reserved.
//

import Foundation

enum Constants {
    
    static let pubclishablekey = "pk_test_DdJwZzh53d57BpT6NJfeg8if"
    static let baseURLString = "http://localhost:3000"
    static let defaultCurrency = "usd"
    static let defaultDescription = "Purchase from Market" 
}

// Firebase Headers
public let kUSER_PATH = "User"
public let kCATEGORY_PATH = "Category"
public let kITEMS_PATH = "Items"
public let kBASKET_PATH = "Basket"

//MARK: Category
public let kNAME = "name"
public let kIMAGENAME = "imageName"
public let kOBJECTID = "object id"

//MARK: items
public let kCATEGORYID = "categoryId"
public let kDESCRPTION = "description"
public let kPRICE = "pirce"
public let kIMAGELINK = "imageLinks"

//MARK: Keys and ID's
public let kAlgolia_App_Id = "GHT8JLFHWJ"
public let kAloglia_search_Api = "10002ffd6d49819b6e557692c3cd70bc"
public let KAlgolia_Admin_Key = "3d97252f656a6a4bc4929713c6f7338e"
public let kFileReference = "gs://market-2ee8f.appspot.com"

//MARK: Basket :

public let KOWNERID = "ownerId"
public let KITEMIDS = "itemIds"

//MARK: User
public let kEMAIL = "email"
public let kFIRSTNAME = "firstName"
public let kLASTNAME = "lastName"
public let kFULLNAME = "fullName"
public let kCURRENTUSER = "currentUser"
public let kFULLADDRESS = "fullAddress"
public let kONBOARD = "onBoard"
public let kPURCHASEDITEMIDS = "purchasedItemIds"
