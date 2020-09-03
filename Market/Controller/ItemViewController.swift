//
//  ItemViewController.swift
//  Market
//
//  Created by mac retina on 2/23/20.
//  Copyright © 2020 Omi Khan. All rights reserved.
//

import UIKit
import JGProgressHUD

class ItemViewController: UIViewController {
    
    
    //MARK: IBOutlets
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    @IBOutlet weak var priceTag: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var descriptionTag: UILabel!
    
    @IBOutlet weak var descriptionTxtView: UITextView!
    
    
    //MARK: Vars
    let sectionInsets = UIEdgeInsets(top: 0 , left: 0, bottom: 0, right: 0)
    private let cellHeight : CGFloat = 273.0
    var item : Item!
    var itemImageArray : [UIImage] = []
    let hud = JGProgressHUD(style: .dark)
    
    
    @IBOutlet weak var itemName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.imageCollectionView.isPagingEnabled = true
        setUpUI()
        downloadPictures()
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(self.backAction))]
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named: "addToBasket"), style: .plain, target: self, action: #selector(self.addToBasket))]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //assignValues()
    }
    
    
    //MARK: Setup UI
    
    private func setUpUI() {
        
        if item != nil {
            
            self.title = item.name
            itemName.text = item.name
            priceLabel.text = convertCurrecny(item.price)
            descriptionTxtView.text = item.description
        }
    }
    
    // MARK: Download Images
    
    private func downloadPictures() {
        
        if item != nil && item.imageLinks != nil {
            downloadImages(item.imageLinks) { (allImages) in
                if allImages.count > 0 {
                    self.itemImageArray = allImages as! [UIImage]
                    self.imageCollectionView.reloadData()
                    
                    
                }
            }
        }
    }
  
    
    //MARK: Add to basket functions
    
    private func createNewBasket(){
        
        let newBasket = Basket()
        newBasket.id = UUID().uuidString
        newBasket.ownerId = "1234"
        newBasket.itemIds = [self.item.id]
        
        saveBasketToFirestore(newBasket)
        
        self.hud.textLabel.text = "Added to Basket"
        self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        self.hud.show(in: self.view)
        self.hud.dismiss(afterDelay: 2.0)
    }
    
    private func updateBasket(basket: Basket, withValues: [String : Any]){
        
        updateBasketInFireStore(basket, withValues: withValues) { (error) in
            
            if error != nil {
                self.hud.textLabel.text = "\(error?.localizedDescription)"
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }else{
                self.hud.textLabel.text = "Added to Basket"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
        }
        
    }
        //MARK: IBActions
        @objc func backAction(){
            
            self.navigationController?.popViewController(animated: true)
        }
        
        @objc func addToBasket() {
            
//            downloadBasketFromFireStore("1234") { (basket) in
//
//                //TODO: Check if user is logged in or show login view
//                if basket == nil {
//                    self.createNewBasket()
//                }else{
//                    basket!.itemIds.append(self.item.id)
//                    self.updateBasket(basket: basket!, withValues: [KITEMIDS : basket!.itemIds])
//                }
//            }
            showLoginView()
        }
    
    func showLoginView(){
        
        let loginView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "loginView")
        self.present(loginView, animated: true, completion: nil)
    }
    
    }


extension ItemViewController : UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return itemImageArray.count == 0 ? 1 : itemImageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell
        
        if itemImageArray.count > 0 {
            
            cell.setUpImage(itemImage: itemImageArray[indexPath.row])
        }
        
        return cell
    }
}


extension ItemViewController : UICollectionViewDelegateFlowLayout {
    
   
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let availabelWidth = collectionView.frame.width - sectionInsets.left
               
              return CGSize(width: availabelWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.left
    }
}

