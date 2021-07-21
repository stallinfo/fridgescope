//
//  User.swift
//  IBMCFCShizen01
//
//  Created by アリフ on 2021/06/30.
//

import Foundation

class User: NSObject{
    var phrase: String
    var identity: String
    var name: String
    var email: String
    var password: String
    var facility: Facility
    var authenticated: Bool
    init(phrase: String, identity: String, name: String, email: String, password: String, facility: Facility, authenticated: Bool){
        self.phrase = phrase
        self.identity = identity
        self.name = name
        self.email = email
        self.password = password
        self.facility = facility
        self.authenticated = authenticated
    }
}
