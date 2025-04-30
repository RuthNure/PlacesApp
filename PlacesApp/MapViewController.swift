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

        locationManager.startUpdatingLocation()
        mapView.delegate = self

    }
    
    @IBAction func sgmtMapType(_ sender: Any) {
        switch segmentButton.selectedSegmentIndex{
        case 0:
            mapView.mapType = .standard
            break
        case 1:
            mapView.mapType = .satellite
            break
        default :
            break
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           if let location = locations.first {
               let coordinate = location.coordinate
               addPlacemarkToMap(coordinate: coordinate)
               locationManager.stopUpdatingLocation() // Stop for battery efficiency
           }
       }
    
    func addPlacemarkToMap(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Saved Place"
        mapView.addAnnotation(annotation)

        // Optional: center map
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
    }

}
