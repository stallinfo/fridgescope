//
//  FridgeView.swift
//  IBMCFCShizen01
//
//  Created by アリフ on 2021/06/30.
//

import Foundation
import MapKit

class FridgeMarkerView: MKMarkerAnnotationView{
    override var annotation: MKAnnotation?{
        willSet{
            guard let fridge = newValue as? Fridge else {
                return
            }
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            markerTintColor = fridge.markerTintColor
           
        }
    }
}
