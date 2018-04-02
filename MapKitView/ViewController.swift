//
//  ViewController.swift
//  MapKitView
//
//  Created by Ika Javakhishvili on 05/1/18.
//  Copyright © 2018 Ika Javakhishvili. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var restraurantArray = [Restaurant]()
    let refreshController = UIRefreshControl()
    var localIndexPath: IndexPath?
    
    @IBOutlet weak var restauranTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restauranTableView.delegate = self
        restauranTableView.dataSource = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.doubleTap))
        tapGestureRecognizer.numberOfTapsRequired = 2
        restauranTableView.addGestureRecognizer(tapGestureRecognizer)
        
        
        refreshController.addTarget(self, action: #selector(self.refreshData), for: .valueChanged)
        
        restauranTableView.addSubview(refreshController)
    }
    
    @objc func doubleTap() {
        performSegue(withIdentifier: "mapSegue", sender: nil)
    }
    
    @objc func refreshData() {
        Alamofire.request("https://api.myjson.com/bins/wqw9r").responseJSON { (responseData) in
            if let responce = responseData.result.value {
                let swiftyJsonVar = JSON(responce)
                
                if let arrayJSON = swiftyJsonVar.arrayObject {
                    arrayJSON.forEach({ (item) in
                        let dictionary = item as! [String:Any]
                        
                        guard let latitude = dictionary["latitude"] else {
                            return
                        }
                        guard let longitude = dictionary["longitude"] else {
                           return
                        }
                        let newRestaurant = Restaurant(latitude: "\(latitude)", longitude: "\(longitude)"  )
                       
                        self.restraurantArray.append(newRestaurant)
                        self.restauranTableView.reloadData()
                       
                    })
                }
                
                if let latitude = swiftyJsonVar["latitude"].double {
                    print(latitude)
                }
                if let longitude = swiftyJsonVar["longitude"].double {
                    print(longitude)
                }
//                if self.arrRes.count > 0 {
//                    self.tblJSON.reloadData()
//                }
            }
        }
        
        
        print("Refreshing...")
        refreshController.endRefreshing()
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restraurantArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = restauranTableView.dequeueReusableCell(withIdentifier: "justAcell", for: indexPath)
        cell.textLabel?.text = restraurantArray[indexPath.row].latitude
        cell.detailTextLabel?.text = restraurantArray[indexPath.row].longitude
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsSegue" {
            let destinationVC = segue.destination as! detailsViewController
            destinationVC.restaurant = restraurantArray[(localIndexPath?.row)!]
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        localIndexPath = indexPath
        performSegue(withIdentifier: "detailsSegue", sender: nil)
    }


}

