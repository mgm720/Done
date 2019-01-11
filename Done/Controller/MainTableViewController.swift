//
//  MainTableViewController.swift
//  Done
//
//  Created by Michael Miles on 1/6/19.
//  Copyright © 2019 Michael Miles. All rights reserved.
//

import UIKit
import CoreData

class MainTableViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext   
    var fetchController : NSFetchedResultsController<Task>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
    }

    // MARK: - Table view functions
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let frc = fetchController {
            return frc.sections!.count
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionInfo = fetchController?.sections?[section] else {
            return nil
        }
        return sectionInfo.name
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.00
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell

        let entity = fetchController.object(at: indexPath)
        
        cell.nameLabel.text = entity.name ?? "Add Items"
        
        if entity.dueTime == nil {
            cell.timeLabel.text = ""
        } else {
            let timeFormatter = DateFormatter()
            timeFormatter.timeStyle = .short
            cell.timeLabel.text = timeFormatter.string(from: entity.dueTime!)
        }

        return cell
    }
    
    // MARK: Add New Task
    @IBAction func addButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "newTaskSegue", sender: self)
    }
    
    
    // MARK: Save & Load Data
    func saveData() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    func loadData() {
        let request = NSFetchRequest<Task>(entityName: "Task")
        let sort = NSSortDescriptor(key: "dueDate", ascending: false)
        let sort2 = NSSortDescriptor(key: "dueTime", ascending: false)
        request.sortDescriptors = [sort, sort2]
        
        fetchController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "dueDate", cacheName: nil)
        
        do {
            try fetchController.performFetch()
        } catch {
            print("Error loading data \(error)")
        }
        tableView.reloadData()
    }

}
