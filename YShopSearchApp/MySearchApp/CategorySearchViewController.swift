//
//  CategorySearchViewController.swift
//  MySearchApp
//
//  Created by systena on 2018/07/14.
//  Copyright © 2018年 Mao Nishi. All rights reserved.
//

import UIKit

class CategorySearchViewController: UITableViewController {
    
    var categoryDataArray =  [ItemData]()
    
    // APIを利用するためのクライアントID
    let appid = "dj00aiZpPWw0SzRCekE2SmJCMSZzPWNvbnN1bWVyc2VjcmV0Jng9ZmY-"
    
    let entryUrl = "https://shopping.yahooapis.jp/ShoppingWebService/V1/json/categorySearch"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let userDefaults = UserDefaults.standard
        
        categoryDataArray.removeAll()
        // カテゴリ検索フラグ
        userDefaults.set("category", forKey: "search")
        
        // パラメータを指定する
        let parameter = ["appid": appid, "category_id": "1"]
        
        // パラメータをエンコードしたURLを作成する
        let requestUrl = createRequestUrl(parameter: parameter)
        
        // APIをリクエストする
        request(requestUrl: requestUrl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // パラメータのURLエンコード処理
    func encodeParameter(key: String, value: String) -> String? {
        // 値をエンコードする
        guard let escapedValue = value.addingPercentEncoding(
            withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
                // エンコード失敗
                return nil
        }
        // エンコードした値をkey=valueの形式で返却する
        return "\(key)=\(escapedValue)"
    }
    
    // URL作成処理
    func createRequestUrl(parameter: [String: String]) -> String {
        var parameterString = ""
        for key in parameter.keys {
            // 値の取り出し
            guard let value = parameter[key] else {
                // 値なし。次のfor文の処理を行う
                continue
            }
            // すでにパラメータが設定されていた場合
            if parameterString.lengthOfBytes(using: String.Encoding.utf8) > 0 {
                // パラメータ同士のセパレータである&を追加する
                parameterString += "&"
            }
            // 値をエンコードする
            guard let encodeValue = encodeParameter(key: key, value: value)
                else {
                    // エンコード失敗。次のfor文の処理を行う
                    continue
            }
            // エンコードした値をパラメータとして追加する
            parameterString += encodeValue
        }
        let requestUrl = entryUrl + "?" + parameterString
        print("requestURL:" + requestUrl)
        return requestUrl
    }
    
    // リクエストを行う
    func request(requestUrl: String) {
        // URL生成
        guard let url = URL(string: requestUrl) else {
            // URL生成失敗
            return
        }
        // リクエスト生成
        let request = URLRequest(url: url)
        // 商品検索APIをコールして商品検索を行う
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data:Data?,
            response:URLResponse?, error:Error?) in
            // 通信完了後の処理
            // エラーチェック
            guard error == nil else {
                // エラー表示
                let alert = UIAlertController(title: "エラー",
                                              message: error?.localizedDescription,
                                              preferredStyle: UIAlertControllerStyle.alert)
                // UIに関する処理はメインスレッド上で行う
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
                return
            }
            // JSONで返却されたデータをパースして格納する
            guard let data = data else {
                // データなし
                return
            }
            
            do {
                // パース実施
                let resultSet = try JSONDecoder().decode(ItemSearchResultSet.self, from: data)
                // 商品のリストに追加
                self.categoryDataArray.append(contentsOf: resultSet.resultSet.firstObject.result.items)
                
            } catch let error {
                print("## error: \(error)")
            }
            
            // テーブルの描画処理を実施
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        // 通信開始
        task.resume()
    }

    // MARK: - Table view data source
    // テーブルのセクション数を取得
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // セクション内の商品数を取得
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryDataArray.count
    }
    
    // MARK: - Table view data source
    // テーブルセルの取得処理
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:
            "categoryCell", for: indexPath) as? CategoryTableViewCell else {
                return UITableViewCell()
        }
        let categoryData = categoryDataArray[indexPath.row]
        // カテゴリのlabel設定
        cell.categoryLabel.text = categoryData.name
        
        return cell
    }
    
    // 商品をタップして次の画面に遷移する前の処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? CategoryTableViewCell {
            // TODO 処理追加
            
        }
    }

}
