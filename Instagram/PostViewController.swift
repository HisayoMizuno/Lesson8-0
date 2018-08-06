//
//  PostViewController.swift
//  Instagram
//
//  Created by ミップ on 2018/06/28.
//  Copyright © 2018年 株式会社ミップ. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SVProgressHUD

class PostViewController: UIViewController {
    var image: UIImage! //ImageSelectViewControllerから受け取るためimageプロパティを定義

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!

    //投稿
    @IBAction func handlePostButton(_ sender: UIButton) {
        //ImageViewから画像を取得
        let imageData = UIImageJPEGRepresentation(imageView.image!, 0.5)  //jpeg形式の Data クラスに変換
        let imageString = imageData!.base64EncodedString(options: .lineLength64Characters) //base64化
        //postdataにセット
        let time = Date.timeIntervalSinceReferenceDate //時間の取得
        let name = Auth.auth().currentUser?.displayName //ログインユーザ名の取得
        //辞書を作成しFirebaseに保存
        let postRef = Database.database().reference().child(Const.PostPath) //Firebaseサーバ上にある保存先をpostRefに代入
        let postDic = ["caption": textField.text!, "image": imageString, "time": String(time), "name": name!] //保存データ
        postRef.childByAutoId().setValue(postDic)

        
        //HUDで投稿完了を表示
        SVProgressHUD.showSuccess(withStatus: "投稿しました")
        //モーダルをとじる
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)

    }
    //キャンセル
    @IBAction func handleCancelButton(sender: AnyObject) {
        //モーダルを閉じる
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //受けとった画像をImageViewに設定
        imageView.image = image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
