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
    @IBOutlet weak var modeSelector: UISegmentedControl!
    @IBOutlet weak var infoLabel: UILabel!
    
    var manager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set default mode to WiFi: on, GPS: on
        modeSelector.selectedSegmentIndex = 2
        
        // Set up location manager
        manager = CLLocationManager()
        manager.delegate = self
        manager.distanceFilter = 10 // Mark location changes only after >10 m changes
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        
        // Set up map view
        mapView.delegate = self
        mapView.mapType = MKMapType.Hybrid
        
        infoLabel.text = "Latitude: calculating...\nLongitude: calculating...\n" +
            "Accuracy: calculating..."
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let currentLocation = mapView.userLocation.location
        
        if currentLocation != nil {
            // Display information on infoLabel
            let latitude = currentLocation.coordinate.latitude
            let longitude = currentLocation.coordinate.longitude
            let accuracy = currentLocation.horizontalAccuracy
            
            infoLabel.text = "Latitude: \(latitude)\nLongitude: \(longitude)\n" +
            "Accuracy: \(accuracy)"
            
            // Log entry
            self.logLocation(currentLocation, mode: modeSelector.selectedSegmentIndex)
        }
    }

    func logLocation(loc: CLLocation, mode: Int) {
        var info = PFObject(className: "Location")
    
        info["latitude"] = loc.coordinate.latitude
        info["longitude"] = loc.coordinate.longitude
        info["accuracy"] = loc.horizontalAccuracy
        info["mode"] = mode
    
        info.saveInBackgroundWithBlock {
            (success: Bool, error: NSError!) -> Void in
            if (success) {
                // Object has been saved
            } else {
                // Problem; check error.description
                NSLog(error.description)
            }
        }
    }
    
    @IBAction func buttonTapped(sender: UISegmentedControl) {
        let alertController = UIAlertController(title: "", message:
            "", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        
        let selectIndex = sender.selectedSegmentIndex

        /*
        
        Set message and accuracy based on segment chosen

        0: WiFi off, GPS off
        1: WiFi on, GPS off
        2: WiFi on, GPS on

        */
        
        switch selectIndex {
        case 0:
            manager.stopUpdatingLocation()
            manager.startMonitoringSignificantLocationChanges()
            alertController.title = "Wifi OFF, GPS OFF"
            alertController.message = "Please make sure that Wi-Fi is turned OFF"
        case 1:
            manager.stopMonitoringSignificantLocationChanges()
            manager.startUpdatingLocation()
            alertController.title = "Wifi ON, GPS OFF"
            alertController.message = "Please make sure that Wi-Fi is turned ON"
        case 2:
            manager.stopMonitoringSignificantLocationChanges()
            manager.startUpdatingLocation()
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

