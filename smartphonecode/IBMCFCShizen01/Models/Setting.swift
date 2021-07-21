//
//  Setting.swift
//  IBMCFCShizen01
//
//  Created by アリフ on 2021/07/15.
//

import UIKit
class Setting: NSObject, NSCoding{
    var identity: String
    var password: String
    var phrase: String
    
    init(identity: String, password: String, phrase: String){
        self.identity = identity
        self.password = password
        self.phrase = phrase
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.identity = aDecoder.decodeObject(forKey: "identity") as! String
        self.password = aDecoder.decodeObject(forKey: "password") as! String
        self.phrase = aDecoder.decodeObject(forKey: "phrase") as! String
    }
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(identity, forKey: "identity")
        aCoder.encode(password, forKey: "password")
        aCoder.encode(phrase, forKey: "phrase")
    }
}
