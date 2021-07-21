//
//  IOHelper.swift
//  IBMCFCShizen01
//
//  Created by アリフ on 2021/07/15.
//

import Foundation
struct IOHelper{
    static func getDocumentsDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = path[0]
        return documentDirectory
    }
}
