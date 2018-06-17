//
//  SettingViewController.swift
//  MySearchApp
//
//  Created by systena on 2018/06/16.
//  Copyright © 2018年 Mao Nishi. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var labelKeyword: UITextField!
    @IBOutlet weak var pickerPriceFrom: UIPickerView!
    @IBOutlet weak var pickerPriceTo: UIPickerView!
    @IBOutlet weak var switchAvailability: UISwitch!
    @IBOutlet weak var switchShipping: UISwitch!
    
    let dataList = ["100","500","1000","2000","3000","4000","5000","10000","20000","30000"]
    
    var priceFromValue: String = ""
    var priceToValue: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // プロトコルの設定
        pickerPriceFrom.delegate = self
        pickerPriceTo.delegate = self
        pickerPriceFrom.dataSource = self
        pickerPriceTo.dataSource = self
        
        // はじめに表示する項目を指定
        pickerPriceFrom.selectRow(0, inComponent: 0, animated: true)
        pickerPriceTo.selectRow(dataList.count - 1, inComponent: 0, animated: true)
        priceFromValue = dataList[0]
        priceToValue = dataList[dataList.count - 1]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // 表示する列数
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // アイテム表示個数を返す
        return dataList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // 表示する文字列を返す
        return dataList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // 選択時の処理
        print(dataList[row])
        if pickerView == pickerPriceFrom {
            priceFromValue = dataList[row]
        }
        if pickerView == pickerPriceTo {
            priceToValue = dataList[row]
        }
    }
    
    @IBAction func SearchItem(_ sender: Any) {
        // キーワード検索文字が１文字以上だった場合は全画面に遷移する
        if let keyword = labelKeyword.text {
            if keyword.count > 0 {
                let userDefaults = UserDefaults.standard
                // 詳細検索フラグ
                userDefaults.set("set", forKey: "search")
                // 検索キーワードの設定
                userDefaults.set(keyword, forKey: "query")
                // 最低価格の設定
                userDefaults.set(priceFromValue, forKey: "priceFrom")
                // 最高価格の設定
                userDefaults.set(priceFromValue, forKey: "priceTo")
                // 在庫の設定
                if switchAvailability.isOn {
                    userDefaults.set("1", forKey: "availability")
                } else {
                    userDefaults.set("", forKey: "availability")
                }
                // 送料の設定
                if switchAvailability.isOn {
                    userDefaults.set("1", forKey: "shipping")
                } else {
                    userDefaults.set("", forKey: "shipping")
                }
                userDefaults.synchronize()
                
                // 前画面に戻る
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
