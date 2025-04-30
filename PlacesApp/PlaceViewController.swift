//
//  PlaceViewController.swift
//  PlacesApp
//
//  Created by Meklit Abera on 4/29/25.
//

import UIKit
import CoreLocation
import CoreData


class PlaceViewController: UIViewController, CLLocationManagerDelegate {
    
    lazy var geoCoder = CLGeocoder()
    var locationManager: CLLocationManager!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var currentLocation: Place?

    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet weak var savePlace: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var pickLocation: UIButton!
    @IBOutlet weak var takePicture: UIButton!
    
    @IBOutlet weak var datelbl: UILabel!
    
    @IBOutlet weak var longitudelbl: UILabel!
    
    @IBOutlet weak var latitudelbl: UILabel!
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    
    @IBAction func changePicture(_ sender: Any) {
    }
    @IBAction func getDeviceCoordinates(_ sender: Any) {
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
              locationManager.distanceFilter = 100
              locationManager.startUpdatingLocation()
              locationManager.startUpdatingHeading()
    }
    
    @IBAction func saveLocation(_ sender: Any) {
        view.endEditing(true)
        if currentLocation == nil {
            let context = appDelegate.persistentContainer.viewContext
            currentLocation = Place(context: context)
        }
        currentLocation?.name = nameText.text
        currentLocation?.date = datelbl.text
        currentLocation?.image = imageView.image?.jpegData(compressionQuality: 0.8)
        appDelegate.saveContext()
        segment.selectedSegmentIndex = 0
        changeEditMode(self)
    }
    
    @IBAction func changeEditMode(_ sender: Any) {
    }
    
    func locationManager (_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            print ("Permission Granted")
        }
        else {
            print("Permission NOT Granted")
        }
        
    }
    
    func locationManager (_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

        // Do any additional setup after loading the view.
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
