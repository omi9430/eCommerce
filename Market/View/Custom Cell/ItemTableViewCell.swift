//
//  ItemTableViewCell.swift
//  Market
//
//  Created by mac retina on 2/20/20.
//  Copyright © 2020 Omi Khan. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var itemImage: UIImageView!
    
    @IBOutlet weak var itemTitle: UILabel!
    
    @IBOutlet weak var itemDescription: UILabel!
    
    @IBOutlet weak var itemPrice: UILabel!
    
    func generateCell(_ item : Item) {
        
        
        itemTitle.text = item.name
        itemDescription.text = item.description
        itemPrice.text = convertCurrecny (item.price)
        itemPrice.adjustsFontSizeToFitWidth = true
        
        if item.imageLinks != nil && item.imageLinks.count > 0 {
            
            downloadImages([item.imageLinks.first!]) { (images) in
                self.itemImage.image = images.first as! UIImage
            }
        }
    }
    



}
