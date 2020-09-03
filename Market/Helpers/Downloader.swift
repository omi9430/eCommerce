//
//  Downloader.swift
//  Market
//
//  Created by mac retina on 2/19/20.
//  Copyright © 2020 Omi Khan. All rights reserved.
//

import Foundation
import FirebaseStorage

let storage = Storage.storage()

func uploadImages(images : [UIImage?], itemId: String, completion: @escaping(_ imagesLink : [String]) -> Void){
    
    if Reachabilty.HasConnection() {
    
    var uploadImagesCount = 0
    var imageLinkAray : [String] = []
    var nameSuffix = 0
    
    for image in images {
        
        let fileName = "ItemImages/" + itemId + "/" + "\(nameSuffix)" + ".jpg "
        let imageData = image?.jpegData(compressionQuality: 0.5)
        
        saveImageToFirebase(image: imageData!, fileName: fileName) { (imageLink) in
            
            if imageLink != nil {
                imageLinkAray.append(imageLink!)
                uploadImagesCount += 1
                
                if uploadImagesCount == images.count {
                    
                    completion(imageLinkAray)
                }
            }
        }
        
        nameSuffix += 1
        
        }
    }else{
        print("No internet connection")
    }
    
}

//Mark : Save images to Firebase

func saveImageToFirebase(image : Data, fileName : String, completion: @escaping(_ imageLink : String?) -> Void){
    var task : StorageUploadTask!
    
    let storageRef = storage.reference(forURL: kFileReference).child(fileName)
    
    task = storageRef.putData(image, metadata: nil, completion: { (metadata, error) in
        task.removeAllObservers()
        
        if error != nil {
            print("Error uploading image", error!.localizedDescription)
            completion(nil)
            return
        }
        storageRef.downloadURL { (url, error) in
            guard let downloadUrl = url else {
                completion(nil)
                return
            }
            
            completion(downloadUrl.absoluteString)
        }
    })
}

func downloadImages(_ imagesUrl : [String],  completion: @escaping (_ images: [UIImage?]) -> Void) {
    
    var imageArray : [UIImage] = []
    
    var downloadCounter = 0
    
    for link in imagesUrl {
        
        let url = URL(string: link)
        
        let downloadQueue = DispatchQueue(label: "DownloadQueue")
        
        downloadQueue.async {
            downloadCounter += 1
            
            let data = NSData(contentsOf: url! as URL)
            
            if data != nil {
                imageArray.append(UIImage(data: data! as Data)!)
                
                if downloadCounter == imageArray.count {
                    
                    DispatchQueue.main.async {
                        completion(imageArray)
                    }
                }
            }else {
                print("couldn't download image")
                completion(imageArray)
                return
            }
        }
    }
    
}

