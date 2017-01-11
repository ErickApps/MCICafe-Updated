//
//  Artwork.swift
//  MCICafe
//
//  Created by Erick Barbosa on 1/10/17.
//  Copyright © 2017 Erick Barbosa. All rights reserved.
//

import Foundation
import MapKit
import AddressBook
import Contacts


class Artwork: NSObject, MKAnnotation {
    
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    func mapItem() -> MKMapItem {
        let addressDictionary = [String(describing: CNPostalAddress.self): subtitle]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
        return mapItem
    }
    
}
