//
//  PlantsTableViewController.swift
//  Oxygen
//
//  Created by Ezra Black on 4/27/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import UIKit
import CoreData

class PlantsTableViewController: UITableViewController {
    // MARK: - Properties
    var shouldPresentLoginViewController: Bool {
        ApiController.bearer == nil
    }
    let apiController = ApiController()
    lazy var fetchedResultsController: NSFetchedResultsController<Plant> = {
        let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "commonName", ascending: true)]
        let context = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: context,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch {
            NSLog("Error")
        }
        return frc
    }()
    // MARK: - View Lifecycle
    override func viewDidLoad() {
    super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        if shouldPresentLoginViewController {
            presentRegisterView()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlantCell", for: indexPath) as?
            PlantTableViewCell else {
                fatalError("Can't dequeue cell of type \(PlantTableViewCell())")
        }
        cell.plant = fetchedResultsController.object(at: indexPath)
        cell.delegate = self
        return cell
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let plant = fetchedResultsController.object(at: indexPath)
            apiController.deletePlantFromServer(plant) { result in
                guard let _ = try? result.get() else {
                    return
                }
                DispatchQueue.main.async {
                    CoreDataStack.shared.mainContext.delete(plant)
                    do {
                        try CoreDataStack.shared.mainContext.save()
                    } catch {
                        CoreDataStack.shared.mainContext.reset()
                        NSLog("Error saving managed object context: \(error)")
                    }
                }
            }
        }
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreatePlantSegue" {
            guard let createVC = segue.destination as? PlantDetailViewController else { return }
            createVC.apiController = apiController
        } else if segue.identifier == "PlantDetailSegue" {
            guard let detailVC = segue.destination as? PlantDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            detailVC.plant = fetchedResultsController.object(at: indexPath)
            detailVC.apiController = apiController
        }
    }
    // MARK: - Actions
    @IBAction func signOut(_ sender: Any) {
        // Clear everything
        self.clearData()
        ApiController.bearer = nil
        // Move the user back to the register page
        self.presentRegisterView()
    }
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue) {
    }
    // MARK: - Core Data
    func clearData() {
        let context = CoreDataStack.shared.mainContext
        do {
            let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
            let allPlants = try context.fetch(fetchRequest)
            for plant in allPlants {
                let plantData: NSManagedObject = plant as NSManagedObject
                context.delete(plantData)
            }
            try context.save()
        } catch {
            NSLog("Could not fetch plants.")
        }
    }
    // MARK: - Private Functions
    private func presentRegisterView() {
        let loginRegisterStoryboard = UIStoryboard(name: "Login-Register",
                                                   bundle: Bundle(identifier: "CasanovaStudios.Oxygen"))
        let registerViewController = loginRegisterStoryboard.instantiateViewController(withIdentifier: "RegisterView")
        registerViewController.modalPresentationStyle = .fullScreen
        present(registerViewController, animated: true)
    }
}

extension PlantsTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}

extension PlantsTableViewController: PlantCellDelegate {
    func timerDidFire(plant: Plant) {
        showAlert(title: "Water is required", message: "\(plant.commonName ?? "egg") needs water badly")
    }
    func showAlert(title: String,
                   message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}
