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
    var taskArray = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
    }

    // MARK: - Table view functions
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Date"
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.00
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell

        cell.nameLabel.text = taskArray[indexPath.row].name ?? "Add Items"
        
        if taskArray[indexPath.row].dueTime == nil {
            cell.timeLabel.text = ""
        } else {
            let timeFormatter = DateFormatter()
            timeFormatter.timeStyle = .short
            cell.timeLabel.text = timeFormatter.string(from: taskArray[indexPath.row].dueTime!)
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
        let request : NSFetchRequest<Task> = Task.fetchRequest()
        let sort = NSSortDescriptor(key: "dueDate", ascending: false)
        request.sortDescriptors = [sort]
        
        do {
            taskArray = try context.fetch(request)
        } catch {
            print("Error loading data \(error)")
        }
        tableView.reloadData()
    }

}
