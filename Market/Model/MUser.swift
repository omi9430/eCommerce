//
//  MUser.swift
//  Market
//
//  Created by mac retina on 3/29/20.
//  Copyright © 2020 Omi Khan. All rights reserved.
//

import Foundation
import FirebaseAuth

class MUser {
    
    var objectId : String
    var email : String
    var firstName : String
    var LastName : String
    var fullName : String
    var purchasedItemIds: [String]
    
    var fullAddress: String?
    var onBoard: Bool
    
    init(_objectId: String,_email:String,_firstName: String,_LastName: String){
        
        objectId = _objectId
        email = _email
        firstName = _firstName
        LastName = _LastName
        fullName = _firstName + " " + _LastName
        onBoard = false
        purchasedItemIds =  []
    }
    
    init(_dictionary : NSDictionary) {
        
            objectId = _dictionary[kOBJECTID] as! String
        
        if let mail = _dictionary[kEMAIL]{
            email = mail as! String
        }else{
            email = ""
        }
        if let fname = _dictionary[kFIRSTNAME]{
            firstName = fname as! String
        }else{
            firstName = ""
        }
        if let lname = _dictionary[kLASTNAME]{
            LastName = lname as! String
        }else{
            LastName = ""
        }
     fullName = firstName + " " + LastName
        
        if let faddress = _dictionary[kFULLADDRESS]{
            fullAddress = faddress as! String
        }else{
            fullAddress = ""
        }
        
        if let onB = _dictionary[kONBOARD]{
            onBoard = onB as! Bool
        }else{
            onBoard = false
        }
        
        if let kpurchasedItemIds = _dictionary[kPURCHASEDITEMIDS]{
            purchasedItemIds = kpurchasedItemIds as! [String]
        }else{
            purchasedItemIds = []
        }
    }
    
    
    //MARK: Resturn current user
    
    class func currentID() -> String{
        return Auth.auth().currentUser?.uid ?? "no user id"
    }
    
    class func currentUser() -> MUser? {
        
        if Auth.auth().currentUser != nil {
            
            if  let dictionary = UserDefaults.standard.value(forKey: kCURRENTUSER){
                return MUser.init(_dictionary: dictionary as! NSDictionary)
        }
    }
        return nil
    }
    
    //MARK: login func
    
   class func login(email : String, password : String, completion: @escaping(_ error:Error?, _ isEmailVerified : Bool) -> Void){
        
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            
            if error == nil {
                if authDataResult!.user.isEmailVerified{
                    
                    downloadUserFromFirestore(userId: (authDataResult?.user.uid)!, email: email)
                        print(email)
                    completion(error,true)
                    
                 

                }else{
                    print("Email is not verified")
                    completion(error,false)
                }
            }else{
                completion(error,false)
            }
        }
       
    }
    
    //MARK: Register user
    
    class func registerUser(_email: String, _password : String, completion: @escaping(_ error:Error?) -> Void){
        
        Auth.auth().createUser(withEmail: _email, password: _password) { (authDataResult, error) in
            
            completion(error)
            
            if error == nil {
                //send verification email
                authDataResult?.user.sendEmailVerification(completion: { (error) in
                    print("Email verifcation error", error?.localizedDescription)
                })
            }
        }
    }
    
    class func forgotPassword(email:String, completion: @escaping(_ error : Error?) -> Void ){
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            completion(error)
        }
    }
    
    class func resendVerification(email: String, completion: @escaping(_ error : Error?) -> Void){
        
        Auth.auth().currentUser?.reload(completion: { (error) in
            
            Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                
                print("Error resending verification email: ", error!.localizedDescription)
                completion(error)
            })
        })
    }
    
    class func logOutCurrentUser(completion: @escaping(_ error : Error?) -> Void){
    
        
        do{
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: kCURRENTUSER)
            UserDefaults.standard.synchronize()
            completion(nil)
         }catch  let error as NSError{
            completion(error)
            print(error)
         }
    }
    
 
}
//End of class

//MARK: Download user from Firestore

func downloadUserFromFirestore(userId : String, email: String){
    
    FireBaseReference(.User).document(userId).getDocument { (snapshot, error) in
        
        guard let snapshot = snapshot else {
            return
        }
        
        if snapshot.exists {
            print("user is existing in firestore")
            saveUserToUserDefaults(mUserDictionary: snapshot.data() as! NSDictionary)
            print(snapshot.data() as! NSDictionary)
            
        }else {
           let user =  MUser(_objectId: userId, _email: email, _firstName: "", _LastName: "")
            saveUserToUserDefaults(mUserDictionary: userDictionary(user: user))
            saveUserToFirestore(mUser:user)
        }
    }
}

//MARK: Save user to Firestore
func saveUserToFirestore(mUser : MUser){
    
    print("I am mUser.ObjectId : ",userDictionary(user: mUser))
    print(mUser.self)
    FireBaseReference(.User).document(mUser.objectId).setData(userDictionary(user: mUser) as! [String : Any]) { (error) in
        if error != nil {
            print("Error saving the user ", error!.localizedDescription)
        }
    }
}
//MARK: Save user to userDefaults

func saveUserToUserDefaults(mUserDictionary : NSDictionary){
    
    UserDefaults.standard.set(mUserDictionary, forKey: kCURRENTUSER)
    UserDefaults.standard.synchronize()
    print("User is saved in user defaults")
    print("Current User Dictionary",UserDefaults.standard.value(forKey: kCURRENTUSER) )
    print("Current User user defaults ID", MUser.currentID())
}


//MARK: Helpers

func userDictionary(user : MUser) -> NSDictionary{

    return NSDictionary(objects: [user.objectId,user.email,user.firstName,user.LastName,user.fullName,user.fullAddress ?? "",user.onBoard,user.purchasedItemIds], forKeys: [kOBJECTID as NSCopying,kEMAIL as NSCopying,kFIRSTNAME as NSCopying, kLASTNAME as NSCopying, kFULLNAME as NSCopying, kFULLADDRESS as NSCopying, kONBOARD as NSCopying,kPURCHASEDITEMIDS as NSCopying ])
}
//kPURCHASEDITEMIDS as NSCopying
//,user.purchasedItemIds
//MARK: update user

func updateCurrentUserInFireStore(withValues: [String:Any], completion: @escaping(_ error : Error?) -> Void){
    
    if let dictionary = UserDefaults.standard.object(forKey: kCURRENTUSER){
        let userObject = (dictionary as! NSDictionary).mutableCopy() as! NSMutableDictionary
        userObject.setDictionary(withValues)
        
        FireBaseReference(.User).document(MUser.currentID()).updateData(withValues) { (error) in
            
            completion(error)
            
            if error == nil {
                saveUserToUserDefaults(mUserDictionary: userObject)
            }
        }
        
    }
}
