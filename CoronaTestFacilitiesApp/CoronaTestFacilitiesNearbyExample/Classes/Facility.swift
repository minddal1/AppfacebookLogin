//
//  Facility.swift
//  CoronaTestFacilitiesNearbyExample
//
//  Created by Mathias Møller Feldt on 06/05/2020.
//  Copyright © 2020 Mathias Møller. All rights reserved.
//

import Foundation
import MapKit
class Facility {
    var attribute = MKMapItem()
    var distance = CLLocationDistance()
    
    init(attribute: MKMapItem, distance:CLLocationDistance) {
        self.attribute = attribute
        self.distance = distance
    }
    
    init() {
    }
}
