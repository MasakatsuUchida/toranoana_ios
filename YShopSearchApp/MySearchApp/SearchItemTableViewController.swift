import UIKit

class SearchItemTableViewController: UITableViewController, UISearchBarDelegate, UIGestureRecognizerDelegate {
    
    var itemDataArray =  [ItemData]()
    // お気に入りデータ
    var favoriteItemList = [FavoriteData]()
    
    var imageCache = NSCache<AnyObject, UIImage>()
    @IBOutlet weak var keywordSearchBar: UISearchBar!
    
    // APIを利用するためのクライアントID
    let appid = "dj00aiZpPWw0SzRCekE2SmJCMSZzPWNvbnN1bWVyc2VjcmV0Jng9ZmY-"
    
    var entryUrl: String = "https://shopping.yahooapis.jp/ShoppingWebService/V1/json/itemSearch"
    
    // 数字を金額の形式に整形するためのフォーマッター
    let priceFormat = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 価格のフォーマット指定
        priceFormat.numberStyle = .currency
        priceFormat.currencyCode = "JPY"
        
        let userDefaults = UserDefaults.standard
        
        // デシリアライズ処理
        if let storedData = userDefaults.object(forKey: "favorite") as? Data {
            if let unarchivedData = NSKeyedUnarchiver.unarchiveObject(with: storedData) as? [FavoriteData] {
                favoriteItemList.append(contentsOf: unarchivedData)
            }
        }
        
        // ロングプレス
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(SearchItemTableViewController.longPress(_:)))
        
        longPressGesture.delegate = self
        
        // Viewに追加.
        self.view.addGestureRecognizer(longPressGesture)
    }
    
    // ビューが表示される直前に呼ばれる
    override func viewWillAppear(_ animated: Bool) {
        let userDefaults = UserDefaults.standard
        
        if let value = userDefaults.string(forKey: "search") {
            if value == "detail" {
                // 詳細検索の開始
                
                // 保持している商品をいったん削除
                itemDataArray.removeAll()
                
                var inputText: String = ""
                
                if let value = userDefaults.string(forKey: "query") {
                    if !value.isEmpty {
                        inputText = value
                        keywordSearchBar.text = value
                    }
                }
                
                // パラメータを指定する
                var parameter = ["appid": appid, "query": inputText]
                
                // 価格指定（最低価格）した価格以上を検索
                if let value = userDefaults.string(forKey: "priceFrom") {
                    if !value.isEmpty {
                        parameter.updateValue(value, forKey: "price_from")
                    }
                }
                // 価格指定（最高価格）した価格未満を検索
                if let value = userDefaults.string(forKey: "priceTo") {
                    if !value.isEmpty {
                        parameter.updateValue(value, forKey: "price_to")
                    }
                }
                
                // 在庫ありのみ表示：1, 全て表示：設定なし
                if let value = userDefaults.string(forKey: "availability") {
                    if !value.isEmpty {
                        parameter.updateValue(value, forKey: "availability")
                    }
                }
                
                // 送料無料：1, 全て表示：設定なし
                if let value = userDefaults.string(forKey: "shipping") {
                    if !value.isEmpty {
                        parameter.updateValue(value, forKey: "shipping")
                    }
                }
                
                // パラメータをエンコードしたURLを作成する
                let requestUrl = createRequestUrl(parameter: parameter)
                
                // APIをリクエストする
                request(requestUrl: requestUrl)
                
            } else if value == "category" {
                // 保持している商品をいったん削除
                itemDataArray.removeAll()
                
                // パラメータを指定する
                var parameter = ["appid": appid]
                
                if let value = userDefaults.string(forKey: "c_id") {
                    if value.isEmpty {
                        return
                    } else {
                        parameter.updateValue(value, forKey: "category_id")
                    }
                }
                
                // パラメータをエンコードしたURLを作成する
                let requestUrl = createRequestUrl(parameter: parameter)
                
                // APIをリクエストする
                request(requestUrl: requestUrl)
            }
        }
        // 検索条件のクリア
        userDefaults.set("", forKey: "search")
        userDefaults.set("", forKey: "category")
        userDefaults.synchronize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // キーボードのsearchボタンがタップされたときに呼び出される
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // 入力された文字の取り出し
        guard let inputText = searchBar.text else {
            // 入力文字なし
            return
        }
        
        // 入力文字数が0文字より多いかどうかチェックする
        guard inputText.lengthOfBytes(using: String.Encoding.utf8) > 0 else {
            // 0文字より多くはなかった
            return
        }
        
        // 保持している商品をいったん削除
        itemDataArray.removeAll()
        
        // パラメータを指定する
        let parameter = ["appid": appid, "query": inputText]
        
        // パラメータをエンコードしたURLを作成する
        let requestUrl = createRequestUrl(parameter: parameter)
        
        // APIをリクエストする
        request(requestUrl: requestUrl)
        
        // キーボードを閉じる
        searchBar.resignFirstResponder()
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
                self.itemDataArray.append(contentsOf: resultSet.resultSet.firstObject.result.items)
                
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
        return itemDataArray.count
    }
    
    // MARK: - Table view data source
    // テーブルセルの取得処理
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:
            "itemCell", for: indexPath) as? ItemTableViewCell else {
                return UITableViewCell()
        }
        let itemData = itemDataArray[indexPath.row]
        // 商品のタイトル設定
        cell.itemTitleLabel.text = itemData.name
        // 商品価格設定処理（日本通貨の形式で設定する）
        let number = NSNumber(integerLiteral: Int(itemData.priceInfo.price!)!)
        cell.itemPriceLabel.text = priceFormat.string(from: number)
        // 商品のURL設定
        cell.itemUrl = itemData.url
        // 画像の設定処理
        // すでにセルに設定されている画像と同じかどうかチェックする
        // 画像がまだ設定されていない場合に処理を行う
        guard let itemImageUrl = itemData.imageInfo.medium else {
            // 画像なし商品
            return cell
        }
        // キャッシュの画像を取り出す
        if let cacheImage = imageCache.object(forKey: itemImageUrl as
            AnyObject) {
            // キャッシュ画像の設定
            cell.itemImageView.image = cacheImage
            return cell
        }
        // キャッシュの画像がないためダウンロードする
        guard let url = URL(string: itemImageUrl) else {
            // urlが生成できなかった
            return cell
        }
        
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data:Data?,
            response:URLResponse?, error:Error?) in
            guard error == nil else {
                // エラーあり
                return
            }
            guard let data = data else {
                // データが存在しない
                return
            }
            guard let image = UIImage(data: data) else {
                // imageが生成できなかった
                return
            }
            // ダウンロードした画像をキャッシュに登録しておく
            self.imageCache.setObject(image, forKey: itemImageUrl as AnyObject)
            // 画像はメインスレッド上で設定する
            DispatchQueue.main.async {
                cell.itemImageView.image = image
            }
        }
        // 画像の読み込み処理開始
        task.resume()
        
        return cell
    }
    
    // 商品をタップして次の画面に遷移する前の処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? ItemTableViewCell {
            if let webViewController =
                segue.destination as? WebViewController {
                // 商品ページのURLを設定する
                webViewController.itemUrl = cell.itemUrl
            }
        }
    }
    
    // Long Press イベント
    @objc func longPress(_ sender: UILongPressGestureRecognizer){
        // 押された位置でcellのPathを取得
        let point = sender.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        if indexPath == nil {
            
        } else if sender.state == UIGestureRecognizerState.began  {
            // 長押しされた場合の処理
            
            let userDefaults = UserDefaults.standard
            
            if let row = indexPath?.row {
                let itemData = itemDataArray[row]
                let favoriteData = FavoriteData()
                favoriteData.name = itemData.name
                favoriteData.image = itemData.imageInfo.medium
                favoriteData.price = itemData.priceInfo.price
                favoriteData.url = itemData.url
                print("長押しされたcellのindexPath:\(row)")
                
                self.favoriteItemList.insert(favoriteData, at: 0)
                
            }
            
            let archiveData = NSKeyedArchiver.archivedData(withRootObject: favoriteItemList)
            userDefaults.set(archiveData, forKey: "favorite")
            userDefaults.synchronize()
            
            // アラートダイアログを生成
            let alertController = UIAlertController(title: "お気に入り", message: "お気に入りに追加しました", preferredStyle: UIAlertControllerStyle.alert)
            
            // OKボタンがタップされたときの処理
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alertController.addAction(okAction)
            // アラートダイアログを表示
            present(alertController, animated: true, completion: nil)
            
        }
    }
}
