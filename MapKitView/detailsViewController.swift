//
//  detailsViewController.swift
//  MapKitView
//
//  Created by Ika Javakhishvili on 05/1/18.
//  Copyright © 2018 Ika Javakhishvili. All rights reserved.
//

import UIKit
import MapKit

class detailsViewController: UIViewController, MKMapViewDelegate  {
   
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var restaurant: Restaurant?

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        searchBar.delegate = self
        
        if let restaurant = restaurant {
            print(restaurant.latitude)
            
            
            let annotation = MKPointAnnotation()
            let coordinate = CLLocationCoordinate2DMake(Double(restaurant.latitude)!, Double(restaurant.longitude)!)
            let span = MKCoordinateSpanMake(0.06, 0.06)
            let region = MKCoordinateRegionMake(coordinate, span)
            
            mapView.setRegion(region, animated: true)
            
            annotation.coordinate = coordinate
            annotation.title = "Restaurant"
            mapView.addAnnotation(annotation)
            mapView.selectAnnotation(annotation, animated: true)
        }
    }

 
    @IBAction func closeButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

}

extension detailsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(searchBar.text!) { (placemarks, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                guard let placemark = placemarks?.first else {
                    return
                }
                
                let annotation = MKPointAnnotation()
                var coordinate = CLLocationCoordinate2D()
                coordinate = (placemark.location?.coordinate)!
                annotation.coordinate = coordinate
                annotation.title = "\(String(describing: placemark.country!)) \n \(String(describing: placemark.name!))"
                let span = MKCoordinateSpanMake(0.01, 0.01)
                let region = MKCoordinateRegionMake(annotation.coordinate, span)
                
                self.mapView.setRegion(region, animated: true)
                self.mapView.addAnnotation(annotation)
                self.mapView.selectAnnotation(annotation, animated: true)
                
            }
        }
    }
}
