//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
var button = UIButton()

//var(変数)とlet(定数)
var kahen = "変数"
let fuhen = "定数"


//タプル
//1.型を混在して使用できる
//2.宣言せずに使用できる

func requestMinAndMax() -> (min: Int, max: Int) {
    //値はタプルで返却する
    return (min: 1, max: 100)
}
let minAndMax = requestMinAndMax()
let minValue = minAndMax.min //最小値を取り出す。minAndMax.0でも取り出し可能
let maxValue = minAndMax.max //最大値を取り出す。minAndMax.1でも取り出し可能

var test = (a: 1, b: "", c: 0.0)
test.a //Int
test.b //String
test.c //Double

var person = (neme: "太郎", age: 20)
person.age
person.neme

let  item = ("ジュース", 100, 0.08, 108)
//print("商品名＝\(item.0), 税抜き価格=\(item.1)円, 消費税\(item.2 * 100) ")

//オプショナル
//Swiftでnilを代入可能にする
//メモリ空間のみ確保する alloc(メモリ確保)に近しいもの
//nil(swift) = null(java)
//""(空文字)とは異なる
//ラッピング(中身が見えないようにする)⇄アンラッピング(中身が見えるようにする)
var value : String?         //OptionalのString型変数の宣言
value = "こんにちは"          //値の設定
//print(value)                //「Optional（"こんにちは"）」というアンラップ前の値が出力されてしまう
if let value = value {  //アンラップ処理
    //print(value)            //「こんにちは」というアンラップ後の値が出力される
}

//変数の省略バージョン
if let _ = value {
    //print("valueはnilではない")
}

if let unwrappedValue = value {
    //print(unwrappedValue)
}

//関数
//func 関数名(引数) -> 戻り値の定義 {}
func showTestScore(mathTestScore: Int) -> String {
    return "数学の点数は\(mathTestScore)点"
}

//print(showTestScore(mathTestScore: 98))

//引数名の省略
func addValue(_ mathTestScore: Int) -> String {
    return "数学の点数は\(mathTestScore)点"
}

//print(addValue(98))

//エラーの宣言
enum MyError: Error {
    case InvalidValue
}

//エラーをthrowする可能性のある関数
func doubleUp(value: Int) throws -> Int {
    if value < 0 {
        throw MyError.InvalidValue
    }
    return value * 2
}

do {
    var doubleResultValue = try doubleUp(value: 10)
    //print("")
} catch MyError.InvalidValue {
    //print("")
}

//クラス
//クラスのメンバ変数→プロパティ
var radio = UISwitch()
radio.isOn = true

class Dog{
    var name = ""
    func bark(){
        //print("私は\(name)です")
    }
}

var dog = Dog()
dog.name = "イヌ"
dog.bark()

class GuideDog: Dog {
    override func bark() {
        //継承元のクラスのbarkメソッドが呼び出される
        super.bark()
        //print("ワンワン")
    }
}

var guideDog = GuideDog()
guideDog.name = "盲導犬"
guideDog.bark()

//構造体
//構造体の定義
struct MyStruct {
    //構造体内での変数宣言
    var value: String?
    //構造体内でのメソッド宣言
    func method(value: Int) -> Int {
        let  resultValue: Int = 0
        return resultValue
        
    }
}

//enumの定義
enum Fluit {
    case Apple
    case Orange
}

//dictionary
var dic1: [String:String] = [String:String]()
dic1["りんご"] = "1個"
dic1["ごりら"] = "1匹"
//イミュータブルな辞書
let dic2: [String:String] = [String:String]()
//dic2["りんご"] = "1個" 要素を追加できない
//イミュータブルの宣言
let dic3: [String:String] = ["りんご":"1個", "ごりら":"1匹"]

var nameOfIntegers = [Int:String]()



/// 課題（4/21）

class Pair {
    
    /// letは定数、varは変数
    let fuhen = "定数"
    
    //let items = [0:"零", 1:"壱", 2:"弐"]
    var items = [Int:String]()
    
    /// 対応する漢数字を返すメソッド
    ///
    /// - Parameter value: 数字
    /// - Returns: 漢数字
    func getPair(_ value: Int) -> String {
        for (intValue, strValue) in items {
            if value == intValue {
                return strValue
            }
        }
        return "該当なし"
    }
    
    /// タプルを返すメソッド
    /// タプル：色々な型の複数の値を一つとしてまとめられる
    /// 使い方：関数の戻り値として使用することが多い
    ///
    /// - Returns: 名前、年齢、身長
    func getTuple() -> (name: String, age: Int, height: Float) {
        return (name: "name", age: 20, height: 180.25)
    }
    
    
    ///
    /// Optional型：変数にnilの代入を許容する
    ///
    func isOptional() {
        var optValue: Int?
//        optValue = 0
        if let _ = optValue {
            print("not nil")
        } else {
            optValue!
            optValue = 0
        }
    }
    
}

var p = Pair()
p.items[0] = "零"
p.items[1] = "壱"
p.items[2] = "弐"

print(p.getPair(1))
print(p.getTuple().name)
print(p.getTuple().age)
print(p.getTuple().height)

