//
//  MapViewController.swift
//  MapKitView
//
//  Created by Ika Javakhishvili on 05/1/18.
//  Copyright © 2018 Ika Javakhishvili. All rights reserved.
//
import MapKit
import UIKit

class MapViewController: UIViewController, MKMapViewDelegate,  UISearchBarDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        
        mapView.delegate = self
        searchBar.delegate = self

        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(_ :)))
        mapView.addGestureRecognizer(longPressRecognizer)
        
        
        super.viewDidLoad()
   
    }
    
    @objc func longPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let touchPoint = gesture.location(in: mapView)
            let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            
            placingAnnotation(coordinate, needToCenter: false)
        }
    }

    @IBAction func buttonClick(_ sender: Any) {
        if let sender = sender as? UIButton {
            switch sender.currentTitle! {
            case "Close":
                dismiss(animated: true, completion: nil)
            case "Current":
                updateDeviceLocation()
            case "Clear":
                mapView.removeAnnotations(mapView.annotations)
                mapView.removeOverlays(mapView.overlays)
            case "Route":
                calculateRoad()
            default:
                return
            }
        }
        
    }
    
    func calculateRoad() {
        if mapView.annotations.count == 2 {
            let sourceCoordinate = mapView.annotations.first?.coordinate
            let destinationCoordinate = mapView.annotations.last?.coordinate
            
            let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate!)
            let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate!)
            
            let sourceItem = MKMapItem(placemark: sourcePlacemark)
            let destinationItem = MKMapItem(placemark: destinationPlacemark)
            
            let directionRequest = MKDirectionsRequest()
            directionRequest.source = sourceItem
            directionRequest.destination = destinationItem
            directionRequest.transportType = .automobile
            
            let directions = MKDirections(request: directionRequest)
            directions.calculate(completionHandler: { (responce, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                guard let responce = responce else {
                    return
                }
                let route = responce.routes[0]
                self.mapView.add(route.polyline, level: .aboveRoads)
                
                let rectangle = route.polyline.boundingMapRect
                let region = MKCoordinateRegionForMapRect(rectangle)
                
                self.mapView.setRegion(region, animated: true)
                
            })
            
        } else {
            print("MapView should have \(2-mapView.annotations.count) annotations!")
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.orange
        renderer.lineWidth = 2.0
        
        return renderer
    }
    
    func updateDeviceLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            
            let localCoordinate = (locationManager.location?.coordinate)!
            placingAnnotation(localCoordinate, needToCenter: true)
            
        }
    }
    
    fileprivate func placingAnnotation(_ coordinate: CLLocationCoordinate2D, needToCenter: Bool) {
        let coordinates = coordinate
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        
        if needToCenter {
            let span = MKCoordinateSpanMake(0.03, 0.03)
            let region = MKCoordinateRegionMake(coordinates, span)
            self.mapView.setRegion(region, animated: true)
        }
        
        self.mapView.addAnnotation(annotation)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let geocode = CLGeocoder()
        geocode.geocodeAddressString(searchBar.text!) { (placemarks, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let placemark = placemarks?.first {
                    self.placingAnnotation((placemark.location?.coordinate)!, needToCenter: true)
                }
            }
        }
        print(searchBar.text!)
    }

}
