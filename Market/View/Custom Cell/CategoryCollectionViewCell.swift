//
//  CategoryCollectionViewCell.swift
//  Market
//
//  Created by mac retina on 2/4/20.
//  Copyright © 2020 Omi Khan. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    
    func generateCell(_ category : Category){
        imageView.image = category.image
        label.text = category.name
    }
}
