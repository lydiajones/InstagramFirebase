//
//  UserProfileHeader.swift
//  InstagramFirebase
//
//  Created by Lydia Jones on 15/04/2017.
//  Copyright © 2017 Lydia Jones. All rights reserved.
//

import UIKit
import Firebase

class UserProfileHeader: UICollectionViewCell {
    

    let profileImageView: UIImageView = { // This is the code for the profile photo //
    
    let iv = UIImageView() // "iv" stands for image view //
        
    iv.backgroundColor = .red
        
    return iv
  
    
        }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .blue

        addSubview(profileImageView)
        
        profileImageView.anchor(top: topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        profileImageView.clipsToBounds = true
        
        setupProfileImage()
        
  }
    
    fileprivate func setupProfileImage() {
            
    guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
            
    FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                print(snapshot.value ?? "")
                
                
                guard let dictionary = snapshot.value as? [String: Any] else {
                    return }
        
                guard let profileImageUrl = dictionary["ProfileImageUrl"]
        
                let url = URL(string: profileImageUrl)
        
        
                URLSession.shared.dataTask(with: profileImageUrl) { (data, response, err)  in
            
               }.resume()
        
            }) { (err) in
                print("Failed to fetch user:", err)
        
          }
        
        
    }

    required init?(coder aDecoder: NSCoder) {
     fatalError("init(code:) has not been implemented")
  }

}
