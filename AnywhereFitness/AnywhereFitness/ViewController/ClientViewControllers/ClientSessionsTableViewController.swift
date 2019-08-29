//
//  ClientSessionTableViewController.swift
//  AnywhereFitness
//
//  Created by Bradley Yin on 8/29/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit
import CoreData

class ClientSessionsTableViewController: UITableViewController {

    var course: Course?
    
    lazy var fetchResultsController: NSFetchedResultsController<Session> = {
        let fetchRequest: NSFetchRequest<Session> = Session.fetchRequest()
        
        let dateDescriptor = NSSortDescriptor(key: "dateTime", ascending: false)
        
        // YOU MUST make the descriptor with the same key path as the sectionNameKeyPath be the first sort descriptor in this array
        
        fetchRequest.sortDescriptors = [dateDescriptor]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.mainContext, sectionNameKeyPath: "dateTime", cacheName: nil)
        
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
        self.view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        courseController?.fetchSessionsFromServer(classId: course?.id ?? 0) {
            //done fetch
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClientSessionCell", for: indexPath)
        
        let session = fetchResultsController.object(at: indexPath)
        
        let dateFormatter = ISO8601DateFormatter()
        
        cell.textLabel?.text = dateFormatter.string(from: session.dateTime ?? Date())
        
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ClientSessionDetailShowSegue" {
            guard let clientSessionDetailVC = segue.destination as? ClientClassDetailViewController, let indexPath = tableView.indexPathForSelectedRow else { return }
            clientSessionDetailVC.session = fetchResultsController.object(at: indexPath)
            clientSessionDetailVC.course = course
        }
    }
}

extension ClientSessionsTableViewController: NSFetchedResultsControllerDelegate {
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
