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
print("商品名＝\(item.0), 税抜き価格=\(item.1)円, 消費税\(item.2 * 100) ")

//オプショナル
//Swiftでnilを代入可能にする
//メモリ空間のみ確保する alloc(メモリ確保)に近しいもの
//nil(swift) = null(java)
//""(空文字)とは異なる
//ラッピング(中身が見えないようにする)⇄アンラッピング(中身が見えるようにする)
var value : String?         //OptionalのString型変数の宣言
value = "こんにちは"          //値の設定
print(value)                //「Optional（"こんにちは"）」というアンラップ前の値が出力されてしまう
if let value = value {  //アンラップ処理
    print(value)            //「こんにちは」というアンラップ後の値が出力される
}

//変数の省略バージョン
if let _ = value {
    print("valueはnilではない")
}

if let unwrappedValue = value {
    print(unwrappedValue)
}

//関数
//func 関数名(引数) -> 戻り値の定義 {}
func showTestScore(mathTestScore: Int) -> String {
    return "数学の点数は\(mathTestScore)点"
}

print(showTestScore(mathTestScore: 98))

//引数名の省略
func addValue(_ mathTestScore: Int) -> String {
    return "数学の点数は\(mathTestScore)点"
}

print(addValue(98))

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
    print("正常終了")
} catch MyError.InvalidValue {
    print("エラー発生")
}

//クラス
//クラスのメンバ変数→プロパティ
var radio = UISwitch()
radio.isOn = true

class Dog{
    var name = ""
    func bark(){
        print("私は\(name)です")
    }
}

var dog = Dog()
dog.name = "イヌ"
dog.bark()

class GuideDog: Dog {
    override func bark() {
        //継承元のクラスのbarkメソッドが呼び出される
        super.bark()
        print("ワンワン")
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



/// 以下、課題（4/21）です。

class Human {
    
    /// letは定数、varは変数
    let message = "該当者なし"
    
    var items = [000000:"田中", 000001:"佐藤", 000002:"高橋"]
    
    /// 情報の設定メソッド
    ///
    /// - Parameters:
    ///   - number: 番号
    ///   - name: 名前
    func setInformation(number: Int, name: String) {
        items[number] = name;
    }
    
    /// 番号から名前を返すメソッド
    ///
    /// - Parameter value: 番号
    /// - Returns: 名前
    func getNameFromNumber(_ value: Int) -> String {
        for (number, name) in items {
            if value == number {
                return name
            }
        }
        return message
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
    /// !…Implicitly Unwrapped Optional型
    /// ?…Optional型
    /// 条件節に記述した条件が成立しなかった場合にelse節が実行されて、コードブロックから抜ける。 また、条件節にオプショナル束縛を記述した場合、そこで利用した変数や定数をguard文の後続の文で利用可能。
    func isOptional(optValue: String?) -> Bool {
        /// オプショナル束縛(Optional Binding)
        if let _ = optValue {
            return true
        } else {
            return false
        }
    }

    /// guard文
    ///
    /// - Parameter a: <#a description#>
    func a(a: String?) throws {
        guard let a = a else {
            throw SampleError.InvalidValue
        }
        print("\(a)")
    }
    
    // エラータイプの定義
    enum SampleError: Error {
        case InvalidValue
    }
    
}

var p = Human()
p.setInformation(number: 201487, name: "内田")

print(p.getNameFromNumber(201487))
print(p.getTuple().name)
print(p.getTuple().age)
print(p.getTuple().height)
var v : String?
print(p.isOptional(optValue: v))
do {
    print(try p.a(a: v))
} catch Human.SampleError.InvalidValue {
 print("エラー発生")
}
