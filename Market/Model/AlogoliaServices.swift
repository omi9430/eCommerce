//
//  AlogoliaServices.swift
//  Market
//
//  Created by omair khan on 12/02/1442 AH.
//  Copyright © 1442 Omi Khan. All rights reserved.
//

import Foundation
import InstantSearchClient

class AlgoliaService {
    static let shared = AlgoliaService()
    
    let client = Client(appID: kAlgolia_App_Id, apiKey: KAlgolia_Admin_Key)
    let index = Client(appID: kAlgolia_App_Id, apiKey: KAlgolia_Admin_Key).index(withName: "item_Name")
    
    public init() {}
    
}
