//
//  MapViewController.swift
//  CoronaTestFacilitiesNearbyExample
//
//  Created by admin on 01/05/2020.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate{
    
    let localsearch = MKLocalSearch.Request()

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentLocation()
        
        mapView.showsUserLocation = true
        
        localsearch.naturalLanguageQuery = "Hospitaler, Danmark"
        localsearch.region = mapView.region
        let search = MKLocalSearch(request: localsearch)
        
        search.start { (response, error) in
            guard let response = response else {
                print("error \(error?.localizedDescription ?? "UNknown error").")
                return
            }
            for item in response.mapItems {
                print(item.name ?? "No name")
                print(item.placemark.coordinate)
                self.addMarker(location: item.placemark.coordinate, markerTitle: item.name ?? "Corona test facility")
            }
        }
    }
    
    func addMarker(location:CLLocationCoordinate2D, markerTitle:String){
        let marker = MKPointAnnotation()
        marker.title = markerTitle
        marker.coordinate = location
        mapView.addAnnotation(marker)
    }
    
    fileprivate let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        return manager
    }()
    
    func currentLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      
      if let coord = locations.last?.coordinate {
        
      let region = MKCoordinateRegion(center: coord, latitudinalMeters: 10000, longitudinalMeters: 10000)
      mapView.setRegion(region, animated: true)
      }

   }
   func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
      print(error.localizedDescription)
   }
}

