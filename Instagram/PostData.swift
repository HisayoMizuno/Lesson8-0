//
//  PostData.swift
//  Instagram
//
//  Created by ミップ on 2018/07/07.
//  Copyright © 2018年 株式会社ミップ. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class PostData: NSObject {
    var id:String?
    var image:UIImage?
    var imageString:String?
    var name:String?
    var caption:String?
    var date:Date?
    var likes:[String] = []
    var isLiked:Bool = false
    var comment:[String] = []
    
    init(snapshot: DataSnapshot, myId: String){
        self.id = snapshot.key
        
        let valueDictionary = snapshot.value as! [String:Any]
        
        imageString = valueDictionary["image"] as? String
        image = UIImage(data: Data(base64Encoded: imageString!, options: .ignoreUnknownCharacters)!)
        
        self.name = valueDictionary["name"] as? String
        self.caption = valueDictionary["caption"] as? String
        
        let time = valueDictionary["time"] as? String
        self.date = Date(timeIntervalSinceReferenceDate: TimeInterval(time!)!)
        
        if let likes = valueDictionary["likes"] as? [String]{
            self.likes = likes
        }
        
        if let comment = valueDictionary["comment"] as? [String] {
            self.comment = comment
        }
    
        for LikeId in self.likes {
            if LikeId == myId {
                self.isLiked = true
                break
            }
        }
    }
}
