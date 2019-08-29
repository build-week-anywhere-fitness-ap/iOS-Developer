//
//  PassesTableViewController.swift
//  AnywhereFitness
//
//  Created by Bradley Yin on 8/29/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit
import CoreData

class PassesTableViewController: UITableViewController {

    lazy var fetchResultsController: NSFetchedResultsController<Pass> = {
        let fetchRequest: NSFetchRequest<Pass> = Pass.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "clientId == %i", courseController?.currentUser?.id ?? 0)
        
        let classIdDescriptor = NSSortDescriptor(key: "classId", ascending: false)
        
        // YOU MUST make the descriptor with the same key path as the sectionNameKeyPath be the first sort descriptor in this array
        
        fetchRequest.sortDescriptors = [classIdDescriptor]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.mainContext, sectionNameKeyPath: "classId", cacheName: nil)
        
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            fatalError("Error performing fetch for frc: \(error)")
        }
        
        return frc
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = nil
        
        courseController?.fetchPassesFromServer {
            
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchResultsController.sections?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PassCell", for: indexPath)
        
        let pass = fetchResultsController.object(at: indexPath)
        
        let request: NSFetchRequest<Course> = Course.fetchRequest()
        request.predicate = NSPredicate(format: "id == %i", pass.classId)
        
        var course: Course?
        
        CoreDataStack.shared.mainContext.performAndWait {
            do {
                course = try CoreDataStack.shared.mainContext.fetch(request).first
            } catch {
                NSLog("Error fetching Course: \(error)")
            }
        }
        
        cell.textLabel?.text = course?.name
        
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PassDetailShowSegue" {
            guard let passDetailVC = segue.destination as? ClientPassDetailViewController, let indexPath = tableView.indexPathForSelectedRow else { return }
            passDetailVC.pass = fetchResultsController.object(at: indexPath)
        }
    }
}

extension PassesTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            fatalError("new cases for fetch result controller type")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let sectionsIndexSet = IndexSet(integer: sectionIndex)
        
        
        switch type {
        case .insert:
            tableView.insertSections(sectionsIndexSet, with: .automatic)
        case .delete:
            tableView.deleteSections(sectionsIndexSet, with: .automatic)
        default:
            break
        }
    }
}
