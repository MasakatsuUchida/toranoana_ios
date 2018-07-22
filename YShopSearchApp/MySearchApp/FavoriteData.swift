//
//  FavoriteData.swift
//  MySearchApp
//
//  Created by systena on 2018/07/22.
//  Copyright © 2018年 Mao Nishi. All rights reserved.
//

import Foundation

class FavoriteData: NSObject, NSCoding {
    var name: String?
    var image: String?
    var price: String?
    var url: String?
    
    override init() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String
        image = aDecoder.decodeObject(forKey: "image") as? String
        price = aDecoder.decodeObject(forKey: "price") as? String
        url = aDecoder.decodeObject(forKey: "url") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(image, forKey: "image")
        aCoder.encode(price, forKey: "price")
        aCoder.encode(url, forKey: "url")
    }
}
