//
//  MapViewController.swift
//  PlacesApp
//
//  Created by Meklit Abera on 4/29/25.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var segmentButton: UISegmentedControl!
    var locationManager = CLLocationManager()
    var place: [Place] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization( )
        mapView.delegate = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
