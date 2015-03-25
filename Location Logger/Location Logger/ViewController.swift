//
//  ViewController.swift
//  Location Logger
//
//  Created by Andrew Titus on 3/24/15.
//  Copyright (c) 2015 GreekEasy. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var logButton: UIButton!
    @IBOutlet weak var modeSelector: UISegmentedControl!
    @IBOutlet weak var infoLabel: UILabel!
    
    var manager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up location manager
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        manager.requestWhenInUseAuthorization()
        
        // Set up map view
        mapView.delegate = self
        mapView.mapType = MKMapType.Hybrid
        
        infoLabel.text = "Latitude: 0\nLongitude: 0\nLatitude Accuracy: 0\nLongitude Accuracy: 0"
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let currentLocation = mapView.userLocation.location
        
        if currentLocation != nil {
            let latitude = currentLocation.coordinate.latitude
            let longitude = currentLocation.coordinate.longitude
            let latAccuracy = currentLocation.horizontalAccuracy
            let longAccuracy = currentLocation.verticalAccuracy
            
            infoLabel.text = "Latitude: \(latitude)\nLongitude: \(longitude)\n" +
            "Latitude Accuracy: \(latAccuracy)\nLongitude Accuracy: \(longAccuracy)"
        }
    }
    
    @IBAction func buttonTapped(sender: UISegmentedControl) {
        let alertController = UIAlertController(title: "", message:
            "", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        
        let selectIndex = sender.selectedSegmentIndex
        
        // Set message and accuracy based on segment chosen
        switch selectIndex {
        case 0:
            manager.desiredAccuracy = kCLLocationAccuracyKilometer
            alertController.title = "Wifi OFF, GPS OFF"
            alertController.message = "Please make sure that Wi-Fi is turned OFF"
        case 1:
            manager.desiredAccuracy = kCLLocationAccuracyKilometer
            alertController.title = "Wifi ON, GPS OFF"
            alertController.message = "Please make sure that Wi-Fi is turned ON"
        case 2:
            manager.desiredAccuracy = kCLLocationAccuracyBest
            alertController.title = "Wifi ON, GPS ON"
            alertController.message = "Please make sure that Wi-Fi is turned ON"
        default:
            println("error in mode selector")
        }
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }

    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            mapView.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
            manager.startUpdatingLocation()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

