//
//  PlaceViewController.swift
//  PlacesApp
//
//  Created by Meklit Abera on 4/29/25.
//

import UIKit
import CoreLocation
import CoreData


class PlaceViewController: UIViewController, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
   
    @IBOutlet weak var savePlace: UIButton!
    
    
    @IBOutlet weak var pickLocation: UIButton!
    @IBOutlet weak var takePicture: UIButton!
    
    @IBOutlet weak var datelbl: UILabel!
    
    @IBOutlet weak var longitudelbl: UILabel!
    
    @IBOutlet weak var latitudelbl: UILabel!
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    
    lazy var geoCoder = CLGeocoder()
    var locationManager: CLLocationManager!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var currentLocation: Place?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func changePicture(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraController = UIImagePickerController()
            cameraController.sourceType = .camera
          //  cameraController.cameraCaptureMode = .photo
            cameraController.delegate = self
            cameraController.allowsEditing = true
            self.present(cameraController, animated: true, completion: nil)
        }
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
        self.navigationController?.popViewController(animated: true)
        segment.selectedSegmentIndex = 0
        changeEditMode(self)
        if currentLocation == nil {
            print("currentLocation is nil. No contact to save.")
        } else {
            print("currentLocation exists. Proceeding to save:")
            print("Location name: \(currentLocation?.name ?? "nil")")
        }
        
    }
    
    @IBAction func changeEditMode(_ sender: Any) {
        if segment.selectedSegmentIndex == 0 {//View Mode
            nameText.isUserInteractionEnabled = false
            nameText.borderStyle = .none
            savePlace.isHidden = true
            pickLocation.isHidden = true
        }
        else{//Edit Mode
            nameText.isUserInteractionEnabled = true
            nameText.borderStyle = .roundedRect
            savePlace.isHidden = false
            pickLocation.isHidden = false
            
        }
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
        if let location = locations.last {
            let eventDate = location.timestamp
            let howRecent = eventDate.timeIntervalSinceNow
            if Double(howRecent) < 15.0 {
                let lat = location.coordinate.latitude
                let long = location.coordinate.longitude
                
                latitudelbl.text = String(format: "%g\u{00B0}", lat)
                longitudelbl.text = String(format: "%g\u{00B0}", long)
                
                
                if currentLocation == nil {
                    let context = appDelegate.persistentContainer.viewContext
                    currentLocation = Place(context: context)
                }
                
                currentLocation?.latitude = lat
                currentLocation?.longitude = long
            }
        }
        
    }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
                imageView.contentMode = .scaleAspectFill
                imageView.image = image
                
                if currentLocation == nil {
                    let context = appDelegate.persistentContainer.viewContext
                    currentLocation = Place(context: context)
                }

                currentLocation?.image = image.jpegData(compressionQuality: 1.0)
                setDate()
            }

            picker.dismiss(animated: true)
        }

           
        func setDate(){
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            datelbl.text = formatter.string(from: Date())
            dismiss(animated: true, completion: nil)
        }
        
        
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
        
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
    }
    

