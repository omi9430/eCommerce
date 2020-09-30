//
//  AddItemViewController.swift
//  Market
//
//  Created by mac retina on 2/16/20.
//  Copyright © 2020 Omi Khan. All rights reserved.
//

import UIKit
import Gallery
import JGProgressHUD
import NVActivityIndicatorView

class AddItemViewController: UIViewController {
    
    
    //MARK: IBOutlets

    @IBOutlet weak var titleTxtField: UITextField!
    @IBOutlet weak var priceTxtField: UITextField!
    @IBOutlet weak var descriptionTxtView: UITextView!
    
    //MARK: Vars
    var category : Category!
    var imageArray : [UIImage?] = []
    var gallery : GalleryController!
    var hud = JGProgressHUD(style: .dark)
    
    var activityIndicator : NVActivityIndicatorView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print( category.id)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60, height: 60), type: .ballPulse, color: #colorLiteral(red: 1.0, green: 0.50, blue: 0.95, alpha: 1.0), padding: nil)
    }
    //MARK: IBActions
    @IBAction func doneBtnPressed(_ sender: Any) {
        
        dissmissKeyBoard()
        
        if allFieldsCompleted() {
            saveItemsToFireStore()
             popUpView()
            print("We have values")
        }else{
            self.hud.textLabel.text = "All fields are required"
            self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
            self.hud.show(in: self.view)
            self.hud.dismiss(afterDelay: 2.0)
        }
      
    }
    
    //Mark : Action func
    
    @IBAction func cameraBtnPressed(_ sender: Any) {
        imageArray = []
      showGallery()
    }
    
    @IBAction func backGroundTapped(_ sender: Any) {
        dissmissKeyBoard()
    }
    
    //Mark : Helpers function
    
  private func allFieldsCompleted() -> Bool {
        
        return(titleTxtField.text != "" && priceTxtField.text != "" && descriptionTxtView.text != "")
    }
    
  private func dissmissKeyBoard() {
        self.view.endEditing(false)
    }
    
    //Mark: Save New item function
    
     func saveItemsToFireStore() {
        
        showActivityIndicator()
        
        let item = Item()
        item.categoryId = category.id
        item.id = UUID().uuidString
        print(titleTxtField.text)
        item.name = self.titleTxtField.text!
        item.description = self.descriptionTxtView.text!
        item.price = Double(self.priceTxtField.text!)
        
       
        
        if imageArray.count > 0 {
            uploadImages(images: imageArray, itemId: item.id) { (imageLinks) in
                item.imageLinks = imageLinks
                
                saveItemToFireStore(item)
                saveItemToAlgolia(item: item)
            }
        }else{
            saveItemToAlgolia(item: item)
            saveItemToFireStore(item)
            popUpView()
        }
    }
    
    //MARK: Helper function
    
    private func popUpView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Show Gallery
    
    func showGallery() {
        gallery = GalleryController()
        gallery.delegate = self
        Config.tabsToShow = [.cameraTab,.imageTab]
        Config.Camera.imageLimit = 6
        
        present(gallery, animated: true, completion: nil)
    }
    
    //MARK: Activity Indicator
    
    private func showActivityIndicator() {
        if activityIndicator != nil {
        self.view.addSubview(activityIndicator!)
            activityIndicator?.startAnimating()
        }
    }
    
    private func hideActivityIndicator(){
        if activityIndicator != nil {
            activityIndicator!.removeFromSuperview()
            activityIndicator!.startAnimating()
        }
    }
}

extension AddItemViewController: GalleryControllerDelegate {
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        if images.count > 0 {
            Image.resolve(images: images) { (resolveImages) in
                self.imageArray = resolveImages
            }
        }
      controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
