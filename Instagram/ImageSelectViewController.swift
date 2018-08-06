//
//  ImageSelectViewController.swift
//  Instagram
//
//  Created by ミップ on 2018/06/28.
//  Copyright © 2018年 株式会社ミップ. All rights reserved.
//

import UIKit
import CLImageEditor

class ImageSelectViewController: UIViewController, UIImagePickerControllerDelegate,  UINavigationControllerDelegate, CLImageEditorDelegate {
    //ライブラリボタン　---> カメラロールをしていいしてピッカーを開く
    @IBAction func handleLibraryButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let pickerController = UIImagePickerController() //写真選択のオプジェクトを作成し、変数に格納
            pickerController.delegate = self //写真選択などのアクションを受け取る設定
            pickerController.sourceType = .photoLibrary //写真選択モードはカメラロールとする
            self.present(pickerController,animated: true,completion: nil) //状況の作成オブジェクトをPickerControllerを表示
        }
    }
    //カメラボタン
    @IBAction func handleCameraButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .camera
            self.present(pickerController, animated: true, completion: nil)

        }
    }
    //キャンセルボタン
    @IBAction func handleCancelButton(_ sender: Any) {
        //画面を閉じる
        self.dismiss(animated: true, completion: nil)
    }
    
    //写真の撮影・選択したときに呼ばれるメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if info[UIImagePickerControllerOriginalImage]  != nil { //撮影された画像
            //画像を取得する
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            //CLIImageEditorで加工する
            print("DEBUG_PRINT: image =  \(image)")
            let editor = CLImageEditor(image: image)!
            editor.delegate = self
            picker.pushViewController(editor, animated: true)
        }
    }
    //CLIImageEditorで加工終了後に呼ばれる
    func imageEditor(_ editor: CLImageEditor!, didFinishEditingWith image: UIImage!) {
        //投稿画面表示
        let postViewController = self.storyboard?.instantiateViewController(withIdentifier: "Post") as! PostViewController
        postViewController.image = image!
        editor.present(postViewController, animated: true, completion: nil)
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
