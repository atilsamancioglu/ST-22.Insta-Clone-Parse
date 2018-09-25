//
//  feedCell.swift
//  Insta Clone Parse
//
//  Created by Atil Samancioglu on 21/06/2017.
//  Copyright © 2017 Atil Samancioglu. All rights reserved.
//

import UIKit
import Parse
import OneSignal

class feedCell: UITableViewCell {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postCommentText: UITextView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var postUuidLabel: UILabel!
    
    var playerIDArray = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        postUuidLabel.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func likeClicked(_ sender: Any) {
        
        let likeObject = PFObject(className: "Likes")
        likeObject["from"] = PFUser.current()!.username!
        likeObject["to"] = postUuidLabel.text
        
        likeObject.saveInBackground { (success, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            } else {
                
               let query = PFQuery(className: "PlayerID")
                query.whereKey("username", equalTo: self.userNameLabel.text!)
                query.limit = 1
                query.findObjectsInBackground(block: { (objects, error) in
                    if error != nil {
                        let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
                        alert.addAction(okButton)
                        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                    } else {
                        
                        self.playerIDArray.removeAll(keepingCapacity: false)
                        
                        for object in objects! {
                            
                            self.playerIDArray.append(object.object(forKey: "playerID") as! String)
                            
                            OneSignal.postNotification(["contents": ["en": "\(PFUser.current()!.username!) has liked your post"], "include_player_ids": ["\(self.playerIDArray.last!)"]])
                            
                        }
                        
                        
                    }
                })
            }
        }
        
    }
    
    @IBAction func commentClicked(_ sender: Any) {
        
        let commentObject = PFObject(className: "Comments")
        commentObject["from"] = PFUser.current()!.username!
        commentObject["to"] = postUuidLabel.text
        
        commentObject.saveInBackground { (success, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            } else {
                
                let query = PFQuery(className: "PlayerID")
                query.whereKey("username", equalTo: self.userNameLabel.text!)
                query.limit = 1
                query.findObjectsInBackground(block: { (objects, error) in
                    if error != nil {
                        let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
                        alert.addAction(okButton)
                        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                    } else {
                        
                        self.playerIDArray.removeAll(keepingCapacity: false)
                        
                        for object in objects! {
                            
                            self.playerIDArray.append(object.object(forKey: "playerID") as! String)
                            
                            OneSignal.postNotification(["contents": ["en": "\(PFUser.current()!.username!) has commented on your post"], "include_player_ids": ["\(self.playerIDArray.last!)"], "ios_badgeType" : "Increase", "ios_badgeCount" : "1"])
                            
                        }
                        
                        
                    }
                })
                
            }
        }
        
    }
    
}
