//
//  FacilityViewController.swift
//  CoronaTestFacilitiesNearbyExample
//
//  Created by admin on 05/05/2020.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import MapKit

class FacilityViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var table: UITableView!
    
    
    let locationManager = CLLocationManager()
    let localsearch = MKLocalSearch.Request()
    var searchRegion = MKCoordinateRegion()
    
    var facilities:[Facility] = []
    
    var indexForFacilities = Int()
    var currentPosition = CLLocationCoordinate2D()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        table.delegate = self
        table.dataSource = self
        
        searchForFacilities(searchParameter: "Hospitaler, Danmark") { result, err in
            DispatchQueue.main.async {
                let userLoctation = CLLocation(latitude: self.currentPosition.latitude, longitude: self.currentPosition.longitude)
                for item in result!{
                    let facilityLocation = CLLocation(latitude: item.placemark.coordinate.latitude, longitude: item.placemark.coordinate.longitude)
                    
                    let distanceInBetween = userLoctation.distance(from: facilityLocation)
                    self.facilities.append(Facility(attribute: item, distance: distanceInBetween))
                }
                self.facilities.sort(by: {$0.distance < $1.distance})
                self.table.reloadData()
                
            }
        }

    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        currentPosition = locValue
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? InfoViewController {
            destination.facility = facilities[indexForFacilities]
            
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    //Searching for facilities nearby
    func searchForFacilities(searchParameter:String, competionhandler:@escaping([MKMapItem]?, Error?) -> Void) {
        localsearch.naturalLanguageQuery = searchParameter
        localsearch.region = searchRegion
        let search = MKLocalSearch(request: localsearch)
        
        search.start { (response, err) in
            if let err = err {
                competionhandler(nil, err)
                print("error \(err.localizedDescription ).")
            } else {
                if let facilities = response?.mapItems {
                    competionhandler(facilities, nil)
                }
            }
        }
    }
    

}

extension FacilityViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.facilities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "facilityCell")as! FacilityCell
        
        let distance = facilities[indexPath.row].distance
    
        if distance < 2500 {
            cell.testlabel.textColor = UIColor(red: 100/255.0, green: 198/255.0, blue: 103/255.0, alpha: 1)
        } else if distance > 2500 && distance <= 5000 {
            cell.testlabel.textColor = UIColor(red: 219/255.0, green: 210/255.0, blue: 124/255.0, alpha: 1)
        } else if distance > 5000 {
            cell.testlabel.textColor = UIColor(red: 216/255.0, green: 82/255.0, blue: 82/255.0, alpha: 1)
        }
        
        let distanceStr = String(format: "%.2f", distance/1000)
        
        cell.img.image = UIImage(named: "region")
        cell.nameLabel.text = facilities[indexPath.row].attribute.name
        cell.testlabel.text = "\(distanceStr) km"
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexForFacilities = indexPath.row
        performSegue(withIdentifier: "segueInfo", sender: self)
    }
    
    
}
