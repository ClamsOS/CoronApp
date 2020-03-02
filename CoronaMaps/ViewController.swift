//
//  ViewController.swift
//  CoronaMaps
//
//  Created by Mehdi on 02/03/2020.
//  Copyright © 2020 fr.district42. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var statusBackgroundView: UIView!
    @IBOutlet weak var mapKitView: MKMapView!
    @IBOutlet weak var generateLocationButton: UIButton!
    @IBOutlet weak var generateLocationButtonBackgroundView: UIView!
    
    let locationManager = CLLocationManager()
    var locationArray = [Location]()
    let locationCount = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initStuff()
    }
    
    func initStuff() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        generateLocations(count: locationCount)
        
        setupUI()
    }
    
    func setupUI() {
        statusBackgroundView.addBlur(style: .light)
        addRegion(locations: locationArray)
        generateLocationButton.imageView?.contentMode = .scaleAspectFit
        generateLocationButton.imageEdgeInsets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
        generateLocationButtonBackgroundView.layer.cornerRadius = 33
        generateLocationButtonBackgroundView.clipsToBounds = true
        generateLocationButtonBackgroundView.addBlur(style: .light)
        generateLocationButtonBackgroundView.bringSubviewToFront(generateLocationButton)
    }
    
    @IBAction func tapLocationButton(_ sender: Any) {
        mapKitView.removeOverlays(mapKitView.overlays)
        locationArray = []
        generateLocations(count: locationCount)
        addRegion(locations: locationArray)
    }
    
    func generateLocations(count: Int) {
        for _ in 0...count {
            let newLocation = Location(coordinates: CLLocationCoordinate2D(latitude: Double.random(in: 30.0...60.0), longitude: Double.random(in: -13.0...30.0)), id: "first")
            
            locationArray.append(newLocation)
        }
    }
    
    func addRegion(locations: [Location]) {
        for location in locations {
            let coordinates = location.coordinates
            let region = CLCircularRegion(center: coordinates, radius: Double.random(in: 5000...200000), identifier: "geofence")
            locationManager.startMonitoring(for: region)
            let circle = MKCircle(center: coordinates, radius: region.radius)
            mapKitView.addOverlay(circle)
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        mapKitView.showsUserLocation = true
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let circelOverLay = overlay as? MKCircle else {return MKOverlayRenderer()}

        let circleRenderer = MKCircleRenderer(circle: circelOverLay)
        circleRenderer.strokeColor = .red
        circleRenderer.fillColor = .red
        circleRenderer.alpha = 0.3
        return circleRenderer
    }
}
