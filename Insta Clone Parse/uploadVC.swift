//
//  SecondViewController.swift
//  Insta Clone Parse
//
//  Created by Atil Samancioglu on 21/06/2017.
//  Copyright © 2017 Atil Samancioglu. All rights reserved.
//

import UIKit
import Parse

class uploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postCommentText: UITextView!
    @IBOutlet weak var postButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let keyboardRecognizer = UITapGestureRecognizer(target: self, action: #selector(uploadVC.hideKeyboard))
        self.view.addGestureRecognizer(keyboardRecognizer)
        
        postImage.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(uploadVC.choosePhoto))
        postImage.addGestureRecognizer(gestureRecognizer)
        
        postButton.isEnabled = false
        
    }
    
    @objc func hideKeyboard() {
        
        self.view.endEditing(true)
        
    }
    
    @objc func choosePhoto() {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        pickerController.allowsEditing = true
        present(pickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        postImage.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        postButton.isEnabled = true
        
    }

 
    @IBAction func postButtonClicked(_ sender: Any) {
        
        self.postButton.isEnabled = false
        
        let object = PFObject(className: "Posts")
        
        let data = postImage.image!.jpegData(compressionQuality: 0.5)
        let pfImage = PFFile(name: "image.jpg", data: data!)
        
        object["postimage"] = pfImage
        object["postcomment"] = postCommentText.text
        object["postowner"] = PFUser.current()!.username!
        
        let uuid = UUID().uuidString
        
        object["postuuid"] = "\(uuid) \(PFUser.current()!.username!)"
        
        object.saveInBackground { (success, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            } else {
                self.postCommentText.text = ""
                self.postImage.image = UIImage(named: "select.png")
                self.tabBarController?.selectedIndex = 0
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newPost"), object: nil)
                
            }
        }
        
    }
    

}

