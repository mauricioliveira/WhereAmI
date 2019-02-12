//
//  ViewController.swift
//  WhereAmI
//
//  Created by Maurício Oliveira on 12/02/2019.
//  Copyright © 2019 Maurício Oliveira. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var lonLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var map: MKMapView!
    var manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.manager.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        self.manager.requestWhenInUseAuthorization()
        self.manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status != .authorizedWhenInUse {
            
            let alertController = UIAlertController(title: "Location Permission", message: "Needed location permissions!", preferredStyle: .alert)
            
            let configurations = UIAlertAction (title: "Open Configurations", style: .default) { (openConfig) in
                
                if let configUrl = NSURL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(configUrl as URL)
                }
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            
            alertController.addAction(configurations)
            alertController.addAction(cancel)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation: CLLocation = locations.last!
        
        let lat = userLocation.coordinate.latitude
        let lon = userLocation.coordinate.longitude
        let speed = userLocation.speed.description
        
        self.speedLabel.text = userLocation.speed > 0 ? speed : "0"
        self.latLabel.text = String(lat)
        self.lonLabel.text = String(lon)
        
        let deltaLat = 0.01
        let deltaLon = 0.01
        
        let location = CLLocationCoordinate2D.init(latitude: lat, longitude: lon)
        let span = MKCoordinateSpan.init(latitudeDelta: deltaLat, longitudeDelta: deltaLon)
        
        let region = MKCoordinateRegion.init(center: location, span: span)
        
        map.setRegion(region, animated: true)
        
        CLGeocoder().reverseGeocodeLocation(userLocation) { (localDetails, error) in
            if error == nil {
                if let local = localDetails?.first {
                    var thoroughfare = ""
                    if local.thoroughfare != nil {
                        thoroughfare = local.thoroughfare!
                    }
                    
                    self.addressLabel.text = thoroughfare != "Infinite Loop" ? thoroughfare : ""
                    
                    /*var subThoroughfare = ""
                    if local.subThoroughfare != nil {
                        subThoroughfare = local.subThoroughfare!
                    }
                    
                    var locality = ""
                    if local.locality != nil {
                        locality = local.locality!
                    }
                    
                    var subLocality = ""
                    if local.subLocality != nil {
                        subLocality = local.subLocality!
                    }
                    
                    var postalCode = ""
                    if local.postalCode != nil {
                        postalCode = local.postalCode!
                    }
                    
                    var country = ""
                    if local.country != nil {
                        country = local.country!
                    }
                    
                    var administrativeArea = ""
                    if local.administrativeArea != nil {
                        administrativeArea = local.administrativeArea!
                    }
                    
                    var subAdministrativeArea = ""
                    if local.subAdministrativeArea != nil {
                        subAdministrativeArea = local.subAdministrativeArea!
                    }*/
                }
            }
        }
    }
    
}

