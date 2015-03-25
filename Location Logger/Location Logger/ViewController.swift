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
    
    var manager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up location manager
        manager = CLLocationManager()
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        
        // Set up map view
        mapView.delegate = self
        mapView.mapType = MKMapType.Hybrid
        mapView.showsUserLocation = true

    }
    
    @IBAction func buttonTapped(sender: UISegmentedControl) {
        let alertController = UIAlertController(title: "", message:
            "", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        
        let selectIndex = sender.selectedSegmentIndex
        
        // Set message based on segment chosen
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

