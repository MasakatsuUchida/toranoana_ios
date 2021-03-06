//
//  FavoriteViewController.swift
//  MySearchApp
//
//  Created by systena on 2018/07/22.
//  Copyright © 2018年 Mao Nishi. All rights reserved.
//

import Foundation
import UIKit

class FavoriteViewController: UITableViewController {
    
    var favoriteItemList = [FavoriteData]()
    
    var imageCache = NSCache<AnyObject, UIImage>()
    
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
        
        // テーブルの描画処理を実施
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // ビューが表示される直前に呼ばれる
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    // セルが編集可能であるかどうかを返却する
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // セルを削除したときの処理
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // 削除処理かどうか
        if editingStyle == UITableViewCellEditingStyle.delete {
            // リストから削除
            favoriteItemList.remove(at: indexPath.row)
            // セルを削除
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            // データを保存
            let archiveData: Data = NSKeyedArchiver.archivedData(withRootObject: favoriteItemList)
            let userDefaults = UserDefaults.standard
            userDefaults.set(archiveData, forKey: "favorite")
            userDefaults.synchronize()
        }
    }
    
    // セクション内の商品数を取得
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteItemList.count
    }
    
    // MARK: - Table view data source
    // テーブルセルの取得処理
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:
            "favoriteItemCell", for: indexPath) as? ItemTableViewCell else {
                return UITableViewCell()
        }
        let favoriteItem = favoriteItemList[indexPath.row]
        // 商品のタイトル設定
        cell.favoriteItemTitleLabel.text = favoriteItem.name
        // 商品価格設定処理（日本通貨の形式で設定する）
        let number = NSNumber(integerLiteral: Int(favoriteItem.price!)!)
        cell.favoriteItemPriceLabel.text = priceFormat.string(from: number)
        // 商品のURL設定
        cell.favoriteItemUrl = favoriteItem.url
        // 画像の設定処理
        // すでにセルに設定されている画像と同じかどうかチェックする
        // 画像がまだ設定されていない場合に処理を行う
        guard let itemImageUrl = favoriteItem.image else {
            // 画像なし商品
            return cell
        }
        // キャッシュの画像を取り出す
        if let cacheImage = imageCache.object(forKey: itemImageUrl as
            AnyObject) {
            // キャッシュ画像の設定
            cell.favoriteItemImageView.image = cacheImage
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
                cell.favoriteItemImageView.image = image
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
                webViewController.itemUrl = cell.favoriteItemUrl
            }
        }
    }
    
}
