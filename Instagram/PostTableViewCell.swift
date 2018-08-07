//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by ミップ on 2018/07/10.
//  Copyright © 2018年 株式会社ミップ. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase


class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var commentButton: UIButton!
    
    @IBOutlet weak var likeButton: UIButton!
    //@IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var commentlist: UILabel! //list用ラベル
   

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setPostData(_ postData: PostData){
        //イメージ表示
        self.postImageView.image = postData.image
        //キャプション表示
        self.captionLabel.text = "\(postData.name!) : \(postData.caption!)"
        //いいね表示
        let likeNumber = postData.likes.count
        likeLabel.text = "\(likeNumber)"
        //日付表示
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = formatter.string(from: postData.date!)
        self.dateLabel.text = dateString
        //いいね
        if postData.isLiked {
            let buttonImage = UIImage(named: "like_exist")
            self.likeButton.setImage(buttonImage, for: .normal)
        }
        else{
            let buttonImage = UIImage(named: "like_none")
            self.likeButton.setImage(buttonImage, for: .normal)
        }

        let num  = postData.comment.count
        if num != 0  || postData.comment != nil {
            var cmntlists = ""
            var accountname = postData.name
            for count in 0..<num {
                cmntlists =  cmntlists + postData.comment[count] + "\n"
                //cmntlists =  cmntlists + accountname! + ": " + postData.comment[count] + "\n"


            }
            self.commentlist.text = cmntlists
        }
        else{
            self.commentlist.isHidden = false
        }
      
        
    }
}
