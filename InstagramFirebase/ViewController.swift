//
//  ViewController.swift
//  InstagramFirebase
//
//  Created by Lydia Jones on 29/03/2017.
//  Copyright © 2017 Lydia Jones. All rights reserved.
//

import UIKit
import Firebase


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    // The code for the add profile photo button //
    
    
    
    let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        return button

        
    }()
    
    
    
    func handlePlusPhoto() {
      let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        
        
        imagePickerController.allowsEditing = true
        
        
        present(imagePickerController, animated: true, completion: nil)
   
        
        // This is the code for picking the profile image - opening up the users photo album // 
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        
        if let editedImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
            
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
            
        }
        
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width/2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.black.cgColor
        plusPhotoButton.layer.borderWidth = 3
        
        dismiss(animated: true, completion: nil)  // This line of code closes the view with the selected profile photo //
    }
    
    
    
    // The code for the email text field //
    
    
    let emailTextField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "Email"

        tf.backgroundColor = UIColor(white:0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        
        tf.addTarget(self, action:  #selector(handleTextInputChange), for: .editingChanged)
    return tf
    
    }()
    
    
    
    
    func handleTextInputChange() {
        let isFormValid = emailTextField.text?.characters.count ?? 0 > 0 && usernameTextField.text?.characters.count ?? 0 > 0 && passwordTextField.text?.characters.count ?? 0 > 0
        
        if isFormValid {
            
            
            
           signUpButton.isEnabled = true
           signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
            
            
        } else {
            
            
            
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
            
            
            // Above is the code that determins wether the button will show highlighted depending on wether the user has eneterd text into the text field //
            
            
        }
        
    }
    
    
    
    
    
     // The code for the username text field //
    
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.backgroundColor = UIColor(white:0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action:  #selector(handleTextInputChange), for: .editingChanged)
        return tf
        
    }()
    
    
    
    
    // The code for the password text field //
    
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true // This masks the password when entered
        tf.backgroundColor = UIColor(white:0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action:  #selector(handleTextInputChange), for: .editingChanged)
        return tf
    
        
    }()
    
    
    
    
    
    
    // This is the code for the 'sign up' button //
    
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        
        
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        
        // This ^ is the 'rgb' extension ^ //
        
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        
        
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        
        
        button.isEnabled = false
        
        
        return button

        
        
    }()
    
    
    
    func handleSignUp() {
        guard let email = emailTextField.text, email.characters.count > 0 else { return }
        
        
        
        guard let username = usernameTextField.text, username.characters.count > 0 else { return }
        
        
        
        guard let password = passwordTextField.text, username.characters.count > 0
            else { return }
        
        
        
        //  Above the (.characters.count) phrase means that the characters within the textfeild have to be greater than 0 to create an account matching the stated guard statment //
        
        
        // The lines of code above allow users to enter their email, username and password and those be saved to the Firebase database with their userID number //
        
        
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            
            
            if let err = error {
                print("Faild to create user:", err) // This is the message that will print when the user is missing some data required //
                return
                
            }
        
            print("Successfully create useer:", user?.uid ?? "")
            
            
            
            guard let image = self.plusPhotoButton.imageView?.image else {
            
            return }
            
            
            guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else { return }
            
            let filename = NSUUID().uuidString
            
            FIRStorage.storage().reference().child("profile_images").child(filename).put(uploadData, metadata: nil, completion: { (metadata, err) in
                
                if let err = err {
                    print("Failed to upload profile image:", err)
                    return
                    
                 }
                
                guard let profileImageUrl = metadata?.downloadURL()?.absoluteString else { return }
                
                print("Successfully uploaded profile image:",profileImageUrl)
                
                
                guard let uid = user?.uid else { return }
                
                
                let dictionaryValues = ["username": username, "profileImageUrl": profileImageUrl]
                
                let values = [uid: dictionaryValues]
                
                FIRDatabase.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
                    
                    
                    if let err = err {
                        print("Failed to save user into the db", err)
                        return
                        
                    }
                    
                    print("Successfully saved user info to db")
                    
                    
                })
            
                
            })
            
            
        })
        
    
    }
    
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
        
        view.addSubview(plusPhotoButton)
        
        
        plusPhotoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
  
        
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor) .isActive = true
        
        
        // These are constraints of the plus photo button icon //
        
        
        
        setupInputFields()
        
        
    }
    
    
    fileprivate func setupInputFields() {
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signUpButton])
        
        stackView.distribution = .fillEqually
        
        stackView.axis = .vertical
        
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        stackView.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 200)
        
        
         }

    }



// These are the Anchor Extension needed for all constraints //



extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?,
                bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true

        
        }
        
        
  }
    
    

}

