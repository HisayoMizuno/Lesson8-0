//
//  InputViewController.swift
//  Instagram
//
//  Created by ミップ on 2018/07/16.
//  Copyright © 2018年 株式会社ミップ. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class InputViewController: UIViewController {
    var postdata: PostData!
   

    @IBOutlet weak var commentField: UITextField!
    
    @IBAction func commentSend(_ sender: UIButton) {
        print("DEBUG_PRINT: コメント送信がタップされました")
        print("print == \(postdata)")   //postdataの内容確認済
        
        //let postRef = Database.database().reference().child(Const.PostPath)
        let postRef = Database.database().reference().child(Const.PostPath).child(postdata.id!)
        postdata.comment.append(commentField.text!)
        let comment = ["comment" : postdata.comment]
        postRef.updateChildValues(comment)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
