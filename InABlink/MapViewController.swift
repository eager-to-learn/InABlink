//
//  MapViewController.swift
//  InABlink
//
//  Created by Corey Salzer on 4/3/17.
//  Copyright © 2017 Washington University in St. Louis. All rights reserved.
//

import UIKit
import MapKit

class MapViewController : UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager : CLLocationManager!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let locationServicesEnabled = startStandardLocationServicesUpdates()
        if !locationServicesEnabled {
            //TODO - force user to enable?
        }
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }

        return nil
        
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {

        // 1 degree of latitude/longitude == 69 miles
        mapView.setRegion(MKCoordinateRegion(center: userLocation.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)), animated: false);
        
    }
    
    private func startStandardLocationServicesUpdates() -> Bool {
        
        if locationManager == nil {
            locationManager = CLLocationManager()
        }
        locationManager.delegate = self
        
        // Check if user has allowed location services
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if status != .denied {
            // TODO - check if these values are best
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.distanceFilter = 0.5; // meters
            locationManager.startUpdatingLocation()
            return true
        }

        return false
        
    }
    
}
