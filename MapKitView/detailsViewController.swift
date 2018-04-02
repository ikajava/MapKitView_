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
    
    var restaurant: Restaurant?
    var pinAnnotaion = MKPointAnnotation()

    override func viewDidLoad() {
        super.viewDidLoad()

        if let restaurant = restaurant {
            mapView.delegate = self
            
            let latitude = Double(restaurant.latitude)!
            let longitude = Double(restaurant.longitude)!
            let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
            pinAnnotaion.coordinate = coordinate
            pinAnnotaion.title = "Restaurant Barbarestan"
            let span = MKCoordinateSpanMake(0.065, 0.065)
            let region = MKCoordinateRegionMake(coordinate, span)
    
            
            mapView.setRegion(region, animated: true)
            mapView.addAnnotation(pinAnnotaion)
            print(restaurant.latitude)
            
        
        }
    }

 
    @IBAction func closeButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

}



