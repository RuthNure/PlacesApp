//
//  PlaceTableViewController.swift
//  PlacesApp
//
//  Created by Michael Bonger on 4/30/25.
//

import UIKit
import CoreData

class PlaceTableViewController: UITableViewController {

 
    var places: [NSManagedObject] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        loadFromDatabase()
        print("✅ PlacesTableViewController loaded")
    }
    override func viewWillAppear(_ animated: Bool) {
            loadFromDatabase()
            tableView.reloadData()
    }

    func loadFromDatabase() {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<Place>(entityName: "Place")
        do {
            places = try context.fetch(request)
            print("Loaded \(places.count) contacts from core data")
        } catch {
            print("Error fetching places: \(error)")
        }
    }

    // MARK: - Table View Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let place = places[indexPath.row] as? Place
            let context = appDelegate.persistentContainer.viewContext
            context.delete(place!)
            do {
                try context.save()
            } catch {
                fatalError("Error deleting contact: \(error)")
            }
            loadFromDatabase()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath)
        let place = places[indexPath.row] as? Place
        cell.textLabel?.text = place?.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPlace = places[indexPath.row] as? Place
        let name = selectedPlace!.name
        
        let actionHandler = { (action: UIAlertAction!) -> Void in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "PlaceController") as! PlaceViewController
            controller.currentLocation = selectedPlace
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        let alertController = UIAlertController(
            title: "Location Selected",
            message: "Selected: \(String(describing: name)) at \(indexPath.row)",
            preferredStyle: .actionSheet
        )
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let detailsAction = UIAlertAction(title: "Show details", style: .default, handler: actionHandler)
        
        alertController.addAction(cancelAction)
        alertController.addAction(detailsAction)
        
        present(alertController, animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditLocation" {
            let locationController = segue.destination as! PlaceViewController
            let selectedRow = self.tableView.indexPath(for: sender as! UITableViewCell)?.row
            let selectedLocation = places[selectedRow!] as? Place
            locationController.currentLocation = selectedLocation
         
        }
    }
    
}
