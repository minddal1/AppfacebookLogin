//
//  InfoViewController.swift
//  CoronaTestFacilitiesNearbyExample
//
//  Created by admin on 05/05/2020.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import MapKit

class InfoViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phonenumberLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var facility = Facility()
    var phonenumber = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phonenumber = createNumber(number: facility.attribute.phoneNumber!)
        
        nameLabel.text = facility.attribute.name
        addressLabel.text = facility.attribute.placemark.title ?? "No address found"
        phonenumberLabel.text = facility.attribute.phoneNumber
        
    }
    @IBAction func getDirectionsBtn(_ sender: Any) {
        facility.attribute.openInMaps(launchOptions: nil)
    }
    
    @IBAction func websiteBtn(_ sender: Any) {
        if let url = facility.attribute.url {
            UIApplication.shared.open(url)
        }
    }
    

    //Not working for the moment....
    @IBAction func callNumber(_ sender: Any) {
        let number = phonenumber
        print(phonenumber)
        callNumber(phoneNumber: "112")
        phonenumberLabel.textColor = UIColor(red: 100/255.0, green: 198/255.0, blue: 103/255.0, alpha: 1)
        
    }
    
    private func callNumber(phoneNumber:String) {

        if let phoneCallURL = URL(string: "telprompt://\(phoneNumber)") {

            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                     application.openURL(phoneCallURL as URL)

                }
            }
        }
    }

    
    func createNumber(number:String) -> String {
        var numberreated = String()
        var index = 0
        for item in number {
            
            if item == " "{
                
            }else if index > 3 {
                numberreated += String(item)
            }
            print(index)
            index += 1
        }
        print("l"+numberreated+"l")
        return numberreated
    }
    
    /*// MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
