//
//  Location.swift
//  CoronaMaps
//
//  Created by Mehdi on 02/03/2020.
//  Copyright © 2020 fr.district42. All rights reserved.
//

import MapKit

class Location {
    init(coordinates: CLLocationCoordinate2D, id: String) {
        self.coordinates = coordinates
        self.id = id
    }
    
    let coordinates: CLLocationCoordinate2D
    let id: String
}
