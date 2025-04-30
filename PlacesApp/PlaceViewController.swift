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
    
    var currentPlace: Place?
    
    
    lazy var geoCoder = CLGeocoder()
    var locationManager: CLLocationManager!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var currentLocation: Place?
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        if let thisPlace = currentPlace {
            nameText.text = thisPlace.name
            latitudelbl.text = String(thisPlace.latitude)
            longitudelbl.text = String(thisPlace.longitude)
            datelbl.text = thisPlace.date
            if let imageDate = thisPlace.image {
                imageView.image = UIImage(data: imageDate)
            }
        }
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        segment.selectedSegmentIndex = 0
        changeEditMode(segment!
        )
    }
    
    
    
    @IBAction func changePicture(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraController = UIImagePickerController()
            cameraController.sourceType = .camera
          //  cameraController.cameraCaptureMode = .photo
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

    if currentPlace == nil {
        let context = appDelegate.persistentContainer.viewContext
        currentPlace = Place(context: context)
    }

    currentPlace?.name = nameText.text
    currentPlace?.date = datelbl.text
    currentPlace?.image = imageView.image?.jpegData(compressionQuality: 0.8)
    currentPlace?.latitude = Double(latitudelbl.text ?? "") ?? 0.0
    currentPlace?.longitude = Double(longitudelbl.text ?? "") ?? 0.0

    appDelegate.saveContext()
    print("✅ Saved: \(currentPlace?.name ?? "nil"), Date: \(currentPlace?.date ?? "nil")")

    self.navigationController?.popViewController(animated: true)
    segment.selectedSegmentIndex = 0
    changeEditMode(self)
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

        if currentPlace == nil {
            let context = appDelegate.persistentContainer.viewContext
            currentPlace = Place(context: context)
        }

        currentPlace?.image = image.jpegData(compressionQuality: 1.0)

        // ✅ Add this — set the current date now
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        currentPlace?.date = formatter.string(from: now)

        datelbl.text = formatDate(date: now)
    }

    picker.dismiss(animated: true)
}
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }



           
    func formatDate(from dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z" // matches how it was saved, if stored as string
        let outputFormatter = DateFormatter()
        outputFormatter.dateStyle = .medium
        outputFormatter.timeStyle = .short
        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        }
        return dateString // fallback
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
    
