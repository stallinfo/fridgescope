//
//  Facility.swift
//  IBMCFCShizen01
//
//  Created by アリフ on 2021/06/29.
//

import Foundation
import MapKit

class Facility: NSObject, MKAnnotation{
    var id: Int?        
    var title: String?
    var content: String?
    var currentVolume: Int?
    var coordinate: CLLocationCoordinate2D
    var fridges: [Fridge]
    
    init(id: Int, title: String?, content: String?, coordinate: CLLocationCoordinate2D, fridges: [Fridge]){
        self.id = id
        self.title = title
        self.content = content
        //self.currentVolume = currentVolume
        self.coordinate = coordinate
        self.fridges = fridges
        
        // find the lowest volume in fridges
        var minVol = 100
        for fridge in fridges{
            if minVol > fridge.currentVolume{
                minVol = fridge.currentVolume
            }
        }
        self.currentVolume = minVol
        
        super.init()
    }
    
    var subtitle: String?{
        let sub: String!
        if fridges.count < 2 {
            sub = "\(fridges.count) fridge"
        } else {
            sub = "\(fridges.count) fridges"
        }
        return sub
    }
    
    var mapItem: MKMapItem? {
 
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
    
    var markerTintColor: UIColor{
        if currentVolume! < 51 {
            return .red
        } else {
            return .blue
        }
    }
}
