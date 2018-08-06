//
//  LoginViewController.swift
//  Instagram
//
//  Created by ミップ on 2018/06/28.
//  Copyright © 2018年 株式会社ミップ. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD



class LoginViewController: UIViewController {
    @IBOutlet weak var mailAddressTextField: UITextField!   //メールアドレスBOX
    @IBOutlet weak var passwordTextField: UITextField!      //パスワードBOX
    @IBOutlet weak var displayNameTextField: UITextField!   //表示名BOX
    
    //----ログインボタンタップ--------------------------------
    
    @IBAction func handleLoginButton(_ sender: Any) {
        if let address = mailAddressTextField.text, let password = passwordTextField.text {
            if address.isEmpty || password.isEmpty{
                SVProgressHUD.showError(withStatus: "必要な項目を入力してしてください")
                return
            }
            //HUDで処理中を表示
            SVProgressHUD.show()
            
            Auth.auth().signIn(withEmail: address, password: password) { user , error in //⑥ログインして
                if let error = error {
                    print("DEBUG_PRINT:" + error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "サイインに失敗しました")
                    return
                }
                else{
                    print("DEBUG_PRINT: ログイン成功")
                    //HUDをとじる
                    SVProgressHUD.dismiss()
                    //画面を閉じてVIewControllerに戻る
                    self.dismiss(animated: true , completion: nil)
                }
            }
        }
    }

    //-----アカウント作成ボタンタップ--------------------------------
    @IBAction func handleCreateAccountButton(_ sender: Any) {
        if let address = mailAddressTextField.text, let password = passwordTextField.text, let displayName = displayNameTextField.text {  // ① if文で変数設定？
            //address password dispNameいずれかが未入力である
            if address.isEmpty || password.isEmpty || displayName.isEmpty {
                print("DEBUG_PRINT:何かが空文字です")
                SVProgressHUD.showError(withStatus: "必要項目を入力してください")
                return
                    //HUDで処理中表示
                    SVProgressHUD.show()
            }
            //成功時：address passwordでUser作成する。自働ログイン
            Auth.auth().createUser(withEmail: address , password: password) { user, error in   // ② クロージャ completion （名前は決まっているのか）
                if let error = error {  //③ error が　nilかどうかの判断
                    print("DEBUG_PRINT: " + error.localizedDescription) //errorがあったら原因を表示
                    SVProgressHUD.showError(withStatus: "ユーザ作成に失敗したしました")
                    return  //次に進まない
                }
                print("DEBUG_PRINT: ユーザー作成に成功しました。")
                
                // 表示名を設定する
                let user = Auth.auth().currentUser
                if let user = user {  //③ error が　nilかどうかの判断
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = displayName
                    changeRequest.commitChanges { error in   //④クロージャ completion
                        if let error = error {
                            //プロフィール更新でエラー
                            print("DEBUG_PRINT: " + error.localizedDescription) //errorがあったら原因を表示
                            SVProgressHUD.showError(withStatus: "表示名の設定に失敗してしました")
                            return
                        }
                        print("DEBUG_PRINT: displayName = (user.displayName!)の設定に成功したしました")
                        //HUDを閉じる
                        SVProgressHUD.dismiss()
                        //画面を閉じる
                        self.dismiss(animated: true, completion: nil) // ⑤クロージャ completion nil設定
                    }
                }
            }
        }
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
