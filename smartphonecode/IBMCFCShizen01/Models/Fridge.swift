//
//  Fridge.swift
//  IBMCFCShizen01
//
//  Created by アリフ on 2021/06/29.
//

import Foundation
import MapKit

class Fridge: NSObject, MKAnnotation{
    var id: Int // fridge id (from database)
    var title: String? // fridge name
    var content: String // explanation about this fridge
    var time: String // time when take image
    var image: String // to store image
    var currentVolume: Int
    var coordinate: CLLocationCoordinate2D
    
    init(id: Int, title: String, content: String, time: String, image: String, currentVolume: Int, coordinate: CLLocationCoordinate2D){
        self.id = id
        self.title = title
        self.content = content
        self.time = time
        self.image = image
        self.currentVolume = currentVolume
        self.coordinate = coordinate
    }
    
    var markerTintColor: UIColor{
        return .blue
    }
}
