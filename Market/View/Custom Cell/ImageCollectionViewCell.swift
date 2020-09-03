//
//  ImageCollectionViewCell.swift
//  Market
//
//  Created by mac retina on 2/23/20.
//  Copyright © 2020 Omi Khan. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageCell: UIImageView!
    
    func setUpImage(itemImage : UIImage) {
        
        imageCell.image = itemImage
    }
}
