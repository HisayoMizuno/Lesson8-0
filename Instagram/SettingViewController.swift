//
//  SettingViewController.swift
//  Instagram
//
//  Created by ミップ on 2018/06/28.
//  Copyright © 2018年 株式会社ミップ. All rights reserved.
//

import UIKit
import ESTabBarController
import Firebase
import FirebaseAuth
import SVProgressHUD

class SettingViewController: UIViewController {
    @IBOutlet weak var displayNameTextField: UITextField!
    
    @IBAction func handleChangeButton(_ sender: Any) {
        if let displayName = displayNameTextField.text{  //⑦
            //表示名欄空白の時、HUDを表示
            if displayName.isEmpty {
                SVProgressHUD.showError(withStatus: "表示名を入力するしてください")
                return
            }
            //表示名を設定する
            let user = Auth.auth().currentUser
            if let user  = user {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = displayName
                changeRequest.commitChanges { error in
                    if let error = error {
                        SVProgressHUD.showError(withStatus: "表示名変更に失敗しました")
                        print("DEBUG_PRINT: " + error.localizedDescription)
                        return
                    }
                    print("DEBUG_PRINT: [displayName = ¥(user.displayName!)]の設定してに成功しました" )
                    //HUDで完了を報せる
                    SVProgressHUD.showSuccess(withStatus: "表示名を変更しました")
                }
            }
            self.view.endEditing(true)
        }

        
    }

    //ログアウト-->fireBaseログアウト処理
    @IBAction func handleLogoutButton(_ sender: Any) {
        //ログアウト
        try! Auth.auth().signOut()
        //ログイン画面表示
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login") // ⑧
        self.present(loginViewController!, animated: true, completion: nil)
        //ログイン画面表示から戻ってきた時のためにホーム画面（index=0)を選択している状態にする
        let tabBarController = parent as! ESTabBarController
        tabBarController.setSelectedIndex(0, animated: false)
        
    }


    //表示名（ログインユーザー名）の表示
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //表示名を取得するしてTextFieldに設定
        let user = Auth.auth().currentUser
        if let user = user {
            displayNameTextField.text = user.displayName
            
        }
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    



}
