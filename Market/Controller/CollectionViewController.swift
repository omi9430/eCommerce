//
//  CollectionViewController.swift
//  Market
//
//  Created by mac retina on 2/4/20.
//  Copyright © 2020 Omi Khan. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {
    
    //Mark: Vars
    var categoryArray: [Category] = []
    
    let sectionInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 20.0, right: 10.0)
    let itemsPerRow: CGFloat = 3
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        print(UserDefaults.standard.dictionary(forKey: kCURRENTUSER))
        //createCategorySet()
        //  self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
        
        if let layOut = collectionView.collectionViewLayout as? HiveLayout {
                       layOut.sectionInset = .init(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
                        }
               collectionView.contentInset = UIEdgeInsets(top: 20, left: 10, bottom: 60, right: 10)
                    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(UserDefaults.standard.dictionary(forKey: kCURRENTUSER))
       // createCategorySet()
      //  loadCategories()
    }
    
    // MARK: UICollectionViewDataSource
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        print("I am collectionview count ",categoryArray.count)
        return categoryArray.count
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CategoryCollectionViewCell
        
        cell.generateCell(categoryArray[indexPath.row])
        // Configure the cell
        
        return cell
    }
    
    //Mark: UIcollectionView Delegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cateogryToitems", sender: categoryArray[indexPath.row])
    }
    
    //Mark: Download Categories
    
    private func loadCategories() {
        downloadCategoriesFromFireBase { (allCategories) in
            print("We have", allCategories.count)
            self.categoryArray = allCategories
            print("I am category array from download categories",self.categoryArray.count)

            print("I am category arraycount after reloading", self.categoryArray.count)
            self.collectionView.reloadData()
        }
    }
    
    //Mark: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "cateogryToitems" {
            let vc = segue.destination as! ItemsTableViewController
            vc.category = sender as! Category
            
        }
    }
    
}

extension CollectionViewController : UICollectionViewDelegateFlowLayout {
    
   
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//         let paddingSpace = sectionInsets.left * (itemsPerRow + 2)
//               let availableWidth = view.frame.width - paddingSpace
//               let widthPerItem = availableWidth/itemsPerRow
//
//               return CGSize(width: widthPerItem, height: widthPerItem)
        
            let numberOfColoumns : CGFloat = 2
              let width = self.view.frame.width
              let xInsets : CGFloat = 15
              let cellSpacing : CGFloat = 15
              
              
              return CGSize(width: (width/numberOfColoumns) - (xInsets + cellSpacing + 20), height: (width/numberOfColoumns) - (xInsets + cellSpacing))
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//
//        return sectionInsets
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//
//        return sectionInsets.left
//    }
}
