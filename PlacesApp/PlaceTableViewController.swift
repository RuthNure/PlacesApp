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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath)
        let place = places[indexPath.row] as? Place
        cell.textLabel?.text = place?.name
        return cell
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
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPlace = places[indexPath.row] as? Place
        let name = selectedPlace?.name ?? "Unknown"

        let actionHandler = { (action: UIAlertAction!) -> Void in
            let selectedCell = tableView.cellForRow(at: indexPath)
            self.performSegue(withIdentifier: "EditLocation", sender: selectedCell)
        }

        let alertController = UIAlertController(
            title: "Location Selected",
            message: "Selected: \(name) at \(indexPath.row)",
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
            let controller = segue.destination as! PlaceViewController
            if let cell = sender as? UITableViewCell,
               let row = tableView.indexPath(for: cell)?.row,
               let selectedPlace = places[row] as? Place {
                    controller.currentPlace = selectedPlace
                print("Segue to EditLocation — Sending Location: \(selectedPlace.name ?? "nil")")
            }
        }
    }
}
