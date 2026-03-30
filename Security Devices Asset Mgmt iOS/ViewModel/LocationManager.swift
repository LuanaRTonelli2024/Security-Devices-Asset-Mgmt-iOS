//
//  LocationManager.swift
//  Security Devices Asset Mgmt iOS
//
//  Created by Jimena Marin on 2026-03-27.
//


import Foundation
import MapKit
import CoreLocation
import Combine


class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private var LocationManager = CLLocationManager()
    
    @Published var userLocation: CLLocationCoordinate2D?
    
    //MARK: inbuilt methods ----> MANDATORY
    
    override init()
    {
        super.init()
        LocationManager.delegate = self
        LocationManager.requestWhenInUseAuthorization() //permission pop up
        LocationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.last else { return }
        
        DispatchQueue.main.async {
            self.userLocation = latestLocation.coordinate
        }
    }
    
    //handle map errors
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Failed o find user's location: \(error.localizedDescription)")
        manager.stopUpdatingLocation()
    }
    
    //check if the permissions are revocked
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case.notDetermined:
            manager.requestWhenInUseAuthorization() //permission pop up
        case .denied, .restricted:
          print("location accesss denied")
            manager.stopUpdatingLocation()
            
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
            
        default:
            break
        }
    }
    
    
    
}
