//
//  ViewController.swift
//  memor
//メモ画面のデータ表示するUIクラス


import UIKit
import RealmSwift

class MemoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UITextFieldDelegate {

    //Realm
    var memoItem: Results<Memo>!

    @IBOutlet weak var InputTextField: UITextField!
    @IBOutlet weak var MemoTableView: UITableView!

    //リターンキー押下判定する
    var textFieldTouchReturnKey = false
    //セル数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoItem.count
    }

    //セル構築
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "memocell", for: indexPath)

        let object: Memo = self.memoItem[(indexPath as NSIndexPath).row]
        //セルにタスク名をset
        cell.textLabel!.text = object.name
        return cell
    }
    //セルが選択(タップ)された時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        textFieldTouchReturnKey = false
        //セル選択後　灰色から白色に自然に変更
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height / 14
    }
    //returnキーが押された時に発動するメソッド
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        //タスク名が入力されていない場合キーボード閉じる
        if (InputTextField.text!.isEmpty == true) {
            textField.resignFirstResponder()
        } else {
            textFieldTouchReturnKey = true
            //キーボード閉じる
            textField.resignFirstResponder()
            //realmへ該当タスク登録
            //    ここでRMに接続し、データの保存を行う
            let newMemo = Memo()
            newMemo.name = InputTextField.text!

            do {
                let realm = try Realm()
                try realm.write({ () -> Void in
                    realm.add(newMemo)
                    print("タスクメモ1件保存完了")
                })
            } catch {
                print("タスクメモ1件保存失敗")
            }
            //テキストフィールドの文字を空にする
            InputTextField.text = ""
            //tableviewの再読み込み
            MemoTableView.reloadData()

        }
        return true
    }

    //画面タッチ判定
    @objc func tapped(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            InputTextField.resignFirstResponder()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //TodaysTaskクラスに永続化されているデータを取りだす
        do {
            let realm = try Realm()
            memoItem = realm.objects(Memo.self)
        } catch {
            print("RealmからMemoのデータを読み込めませんでした")
        }
        //タップでキーボード閉じる
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(MemoViewController.tapped(_:)))
        //tableviewへのtapを検知させる
        tapGesture.cancelsTouchesInView = false

        MemoTableView.delegate = self
        MemoTableView.dataSource = self
        InputTextField.delegate = self
        tapGesture.delegate = self
        InputTextField.borderStyle = .none
        self.view.addGestureRecognizer(tapGesture)
        //textFieldのデザイン
        InputTextField.borderStyle = .none
        InputTextField.layer.cornerRadius = 17
        InputTextField.layer.borderColor = UIColor.lightGray.cgColor
        InputTextField.layer.borderWidth = 1
        InputTextField.layer.masksToBounds = true

        //テーブルビューの枠線
        MemoTableView.separatorColor = .black
    }
}


