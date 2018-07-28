//
//  CategorySearchResultSet.swift
//  MySearchApp
//
//  Created by systena on 2018/07/27.
//  Copyright © 2018年 Mao Nishi. All rights reserved.
//

import Foundation

// 検索結果全体を格納するクラス
class CategorySearchResultSet: Codable {
    var resultSet2: ResultSet2!
    
    private enum CodingKeys: String, CodingKey {
        case resultSet2 = "ResultSet"
    }
}

// カテゴリ検索結果セット格納クラス
class ResultSet2: Codable {
    var firstObject2: FirstObject2!
    private enum CodingKeys: String, CodingKey {
        case firstObject2 = "0"
    }
}

class FirstObject2: Codable {
    var result2: Categories!
    private enum CodingKeys: String, CodingKey {
        case result2 = "Result"
    }
}

class Categories: Codable {
    var categories: Children!
    private enum CodingKeys: String, CodingKey {
        case categories = "Categories"
    }
}

class Children: Codable {
    var children: Result2!
    private enum CodingKeys: String, CodingKey {
        case children = "Children"
    }
}

// カテゴリ検索結果格納クラス
class Result2: Codable {
    var categories: [CategoryData] = [CategoryData]()
    required init(from decoder: Decoder) throws {
        // デコードのためのコンテナを取得
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // コンテナ内のキーを取得。キーが文字列であるため、数値の昇順でソートも行う
        let keys = container.allKeys.sorted {
            Int($0.rawValue)! < Int($1.rawValue)!
        }
        // キーを使用して検索結果を一件ずつ取り出す
        for key in keys {
            // 検索結果一件に対するデコード処理
            let category = try container.decode(CategoryData.self, forKey: key)
            // デコード処理できたら検索結果の一覧に追加
            categories.append(category)
        }
    }
    
    // エンコード処理
    func encode(to encoder: Encoder) throws {
        // レスポンスを解析するだけなので、実装不要
    }
    
    // Result2クラスが持つ値を取得するためのキー
    private enum CodingKeys: String, CodingKey {
        case hit0 = "0"
        case hit1 = "1"
        case hit2 = "2"
        case hit3 = "3"
        case hit4 = "4"
        case hit5 = "5"
        case hit6 = "6"
        case hit7 = "7"
        case hit8 = "8"
        case hit9 = "9"
        case hit10 = "10"
        case hit11 = "11"
        case hit12 = "12"
        case hit13 = "13"
        case hit14 = "14"
        case hit15 = "15"
        case hit16 = "16"
        case hit17 = "17"
        case hit18 = "18"
        case hit19 = "19"
        case hit20 = "20"
    }
}

// カテゴリ情報格納クラス
class CategoryData: Codable {
    
    // カテゴリ情報
    class TitleInfo: Codable {
        // Titleクラスが持つ値を取得するためのキー
        private enum CodingKeys: String, CodingKey {
            case short = "Short"
        }
        
        // カテゴリ名
        var short: String?
    }
    
    // カテゴリ名
    var titleInfo: TitleInfo = TitleInfo()
    
    // id
    var id: String = ""
    
    private enum CodingKeys: String, CodingKey {
        case id = "Id"
        case titleInfo = "Title"
    }
}
