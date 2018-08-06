//
//  HomeViewController.swift
//  Instagram
//
//  Created by ミップ on 2018/06/28.
//  Copyright © 2018年 株式会社ミップ. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var postArray: [PostData] = []
    //var tonextData:[String] = []
    //databaseのobservEventの登録状況
    var observing = false
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // テーブルセルのタップを無効にする
        tableView.allowsSelection = false
        //PostTableViewCell.xibに作成したセルの定義内容を取得
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
        //table行の高さをAutolayoutに任せる
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //テーブル行の高佐の概算値を設定　高さ＝縦横比1:1のUIImageViewの高さ＋いいね・キャプション・余白の合計 （100pt)
        tableView.estimatedRowHeight = UIScreen.main.bounds.width + 100
    }
    //--------------------------------------------------------------------------------------------------------
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")

        if Auth.auth().currentUser != nil { //ログインしていたら
            if self.observing == false { //DatabaseのobserveEventの登録状態が
                print(postArray)
                print("DEBUG====>\(postArray)")
                // 要素が追加されたらpostArrayに追加してTableViewを再表示する
                let postsRef = Database.database().reference().child(Const.PostPath)
                //
                postsRef.observe(.childAdded, with: { snapshot in  //クロージャ開始
                    print("DEBUG_PRINT: .childAddイベントが発生するしました")
                    //PostDataクラスを生成して受け取ったdataを設定したする
                    if let uid = Auth.auth().currentUser?.uid {
                        let postData = PostData(snapshot: snapshot, myId:uid)
                        self.postArray.insert(postData, at: 0)
                        //TableViewを再表示
                        self.tableView.reloadData()
                    }//end Uid
                }) //クロージャend
                //要素が変更されたら該当のデータをpostArrayから一度削除した後に"新しいデータを追加"してTableViewを再表示する
                postsRef.observe(.childChanged,with: { snapshot in //クロージャ開始
                    print("DEBUG_PRINT: .childChangeイベントが発生するしました")
                    if let uid = Auth.auth().currentUser?.uid {
                        //POstDataクラスを生成して受け取ったデータを設定したする
                        let postData = PostData(snapshot: snapshot , myId: uid)
                        //配列からidが同じものを探す
                        var index: Int = 0
                        for post in self.postArray {
                            if post.id ==  postData.id {
                                index = self.postArray.index(of:post)!
                                break
                            } //end if
                        } //end for
                        // 差し替えるため一度削除する
                        self.postArray.remove(at: index)
                        // 削除したところに更新済みのデータを追加する
                        self.postArray.insert(postData, at: index)
                        // TableViewを再表示する
                        self.tableView.reloadData()
                     }
                }) //endクロージャ
                // DatabaseのobserveEventが上記コードにより登録されたため trueとする
                observing = true
                }
            } //ovserving ==false END
            else {
                if observing == true {
                    print("PRINT_DEBUG:true==>" , postArray)
                    // ログアウトを検出したら、一旦テーブルをクリアしてオブザーバーを削除する。// テーブルをクリアする
                    postArray = []
                    tableView.reloadData()
                    //オプサーバを削除
                    Database.database().reference().removeAllObservers()
                    // DatabaseのobserveEventが上記コードにより解除されたため
                    // falseとする
                    observing = false
                } //end if ovserving
            } //end else
        } //  Auth.auth().currentUser != nil
    
        //行の数 //-------------------------------------------------------------------
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            print("DEBUG------>\(postArray.count)")
            return postArray.count
        }
 
        //セルの数だけ呼び出//----------------------------------------------------------
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            // セルを取得してデータを設定する
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
            cell.setPostData(postArray[indexPath.row])
            //コメント
            cell.commentButton.addTarget(self, action: #selector(inputButton(_ : forEvent:)), for: .touchUpInside)
            // セル内のボタンのアクションをソースコードで設定する
            cell.likeButton.addTarget(self, action: #selector(handleButton(_ : forEvent:)), for: .touchUpInside)
            return cell
        }
        //タップされた時に呼び出し//----------------------------------------------------------
        //func tableView(_ table: UITableView,didSelectRowAt indexPath: IndexPath) {
            // 配列からタップされたインデックスのデータを取り出す
            //let postData = postArray[indexPath.row]
            //var tonextData = postArray[indexPath.row]
            //performSegue(withIdentifier: "comment", sender: nil)
        //}
        //#section commentボタン-----------------------------------------------------------------
        @objc func inputButton(_ sender: UIButton, forEvent event: UIEvent) {
            print("DEBUG_PRINT: コメントボタンがタップされました")
            // タップされたセルのインデックスを求める
            let touch = event.allTouches?.first
            let point = touch!.location(in: self.tableView)
            let indexPath = tableView.indexPathForRow(at: point)
            // 配列からタップされたインデックスのデータを取り出す
            let postData = postArray[indexPath!.row]
            //
            
            
            let inputViewController = self.storyboard?.instantiateViewController(withIdentifier: "coment") as! InputViewController

            inputViewController.postdata = postData
            present(inputViewController, animated: true, completion: nil)
            //performSegue(withIdentifier: "tocomment", sender: nil)
       }
        //override func prepare(for segue:UIStoryboardSegue, sender:Any?) {
        //    if segue.identifier == "comment" {
        //       let inputViewController = segue.destination as! InputViewController
        //        //inputViewController.postdata = postData!
        //        inputViewController.postdata = tonextData
        //    }
        //}
        //#section lIKEボタン-----------------------------------------------------------------
        @objc func handleButton(_ sender: UIButton, forEvent event: UIEvent) {
            print("DEBUG_PRINT: likeボタンがタップされました。")
            
            // タップされたセルのインデックスを求める
            let touch = event.allTouches?.first
            let point = touch!.location(in: self.tableView)
            let indexPath = tableView.indexPathForRow(at: point)
            // 配列からタップされたインデックスのデータを取り出す
            let postData = postArray[indexPath!.row]
            
            // Firebaseに保存するデータの準備
            if let uid = Auth.auth().currentUser?.uid {
                
                if postData.isLiked {
                    // すでにいいねをしていた場合ー→いいねを解除するためIDを取り除く
                    var index = -1
                    for likeId in postData.likes {
                        if likeId == uid {
                            // 削除するためにインデックスを保持しておく
                            index = postData.likes.index(of: likeId)!
                            break
                        }
                    }
                    postData.likes.remove(at: index)
                //自分がいいねしていない場合-->そのまま登録する
                } else {
                    postData.likes.append(uid)
                }
                // 増えたlikesをFirebaseに保存する
                let postRef = Database.database().reference().child(Const.PostPath).child(postData.id!)
                let likes = ["likes": postData.likes]
                postRef.updateChildValues(likes)
                
            }
        }
        @IBAction func unwind(_ segue: UIStoryboardSegue) {
            // 他の画面から segue を使って戻ってきた時に呼ばれる
        }
    }

//-------------------------------------------------------------------

   // func didReceiveMemoryWarning() {
       // super.didReceiveMemoryWarning()
        //// Dispose of any resources that can be recreated.
   // }
    



