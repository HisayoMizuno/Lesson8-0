//
//  ViewController.swift
//  Instagram
//
//  Created by ミップ on 2018/06/28.
//  Copyright © 2018年 株式会社ミップ. All rights reserved.
//
import UIKit
import ESTabBarController
import Firebase // 先頭でFirebaseをimportしておく
import FirebaseAuth

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTab()  //setupTab メソッド
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //setupTab
    func setupTab() {
        //1.画像のガイル名を指定してESTabBarControllerを作成する
        let tabBarController: ESTabBarController! = ESTabBarController(tabIconNames: ["home", "camera", "setting"])
        //let tabBarController: ESTabBarController! = ESTabBarController(tabIconNames: ["home", "camera", "setting", "History"])

        //2.選択ボタンの色 背景色、選択時の色を設定する
        tabBarController.selectedColor = UIColor(red: 1.0, green: 0.44, blue: 0.11, alpha: 1)
        tabBarController.buttonsBackgroundColor = UIColor(red: 0.96, green: 0.91, blue: 0.87, alpha: 1)
        tabBarController.selectionIndicatorHeight = 4
    
        //3.作成したESTabBarControllerを親のViewController（＝self）に追加する
        addChildViewController(tabBarController)
        let tabBarView = tabBarController.view!
        tabBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tabBarView)
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tabBarView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tabBarView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tabBarView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tabBarView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            ])
        tabBarController.didMove(toParentViewController: self)
    
        //４.タブをタップした時に表示するViewControllerを設定する
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: "Home")
        let settingViewController = storyboard?.instantiateViewController(withIdentifier: "Setting")
        //let PostTableViewCell = storyboard?.instantiateViewController(withIdentifier: "History")


    
        tabBarController.setView(homeViewController, at: 0)
        tabBarController.setView(settingViewController, at: 2)
    
        //5.highlightButton(at:)メソッドで真ん中のタブはボタンとして扱う.setAction(_:at:)メソッドでタップされたときの処理を記述
        tabBarController.highlightButton(at: 1)
        tabBarController.setAction({
            // ボタンが押されたらImageViewControllerをモーダルで表示する
            let imageViewController = self.storyboard?.instantiateViewController(withIdentifier: "ImageSelect")
            self.present(imageViewController!, animated: true, completion: nil)
        }, at: 1)
    }
    //ーーーーー画面呼ばれたとき、ログイン確認ーーーーーー
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // currentUserがnilならログインしていない
        if Auth.auth().currentUser == nil {
            // ログインしていない場合の処理
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login") //ストーリボードIDを与えてViewControllerを得る
            self.present(loginViewController!, animated: true, completion: nil)  //モーダル表示
            
        }
    }
    
    

}

