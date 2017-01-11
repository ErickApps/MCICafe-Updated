//
//  InfoViewController.swift
//  MCICafe
//
//  Created by Erick Barbosa on 1/10/17.
//  Copyright © 2017 Erick Barbosa. All rights reserved.
//

import UIKit
import MapKit
class InfoViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
       let location = CLLocation(latitude: 25.778511, longitude: -80.190155)
        
        centerMapOnLocation(location: location)
        
        let mciCafe = Artwork(title: "MCI Café",
                              locationName: "Miami Culinary Institute",
                              discipline: "Food",
                              coordinate: CLLocationCoordinate2D(latitude: 25.778511, longitude: -80.190155))
        
        
        self.mapView.addAnnotation(mciCafe)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    

   
}
