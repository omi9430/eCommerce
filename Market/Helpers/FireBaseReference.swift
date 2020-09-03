//
//  FireBaseReference.swift
//  Market
//
//  Created by mac retina on 2/4/20.
//  Copyright © 2020 Omi Khan. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum FCollectionReference : String {
    case User
    case Category
    case Items
    case Basket
}

func FireBaseReference(_ collectionReference : FCollectionReference) -> CollectionReference {
    
    return Firestore.firestore().collection(collectionReference.rawValue)
}
