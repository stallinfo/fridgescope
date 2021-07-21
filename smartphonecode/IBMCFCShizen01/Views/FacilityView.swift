//
//  FacilityView.swift
//  IBMCFCShizen01
//
//  Created by アリフ on 2021/06/29.
//

import Foundation
import MapKit

class FacilityView: MKAnnotationView{
    override var annotation: MKAnnotation?{
        willSet{
            //guard let facility = newValue as? Facility else {
            //    return
            //}
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            //image = facility.image
        }
    }
}

class FacilityMarkerView: MKMarkerAnnotationView{
    override var annotation: MKAnnotation?{
        willSet{
            guard let facility = newValue as? Facility else {
                return
            }
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            markerTintColor = facility.markerTintColor
            if let volume = facility.currentVolume {
                if volume <= 50 {
                    glyphText = "L"
                } else {
                    glyphText = "F"
                }
            }
        }
    }
}
