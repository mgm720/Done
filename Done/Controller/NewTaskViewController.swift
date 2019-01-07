//
//  NewTaskViewController.swift
//  Done
//
//  Created by Michael Miles on 1/6/19.
//  Copyright © 2019 Michael Miles. All rights reserved.
//

import UIKit
import CoreData

class NewTaskViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    
    //created this toolbar extension to add a "Done" button that will dismiss the keyboard/date picker
    let toolBar = UIToolbar().ToolbarPicker(mySelect: #selector(NewTaskViewController.dismissPicker))
    
    var datePicker: UIDatePicker?
    var timePicker: UIDatePicker?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.inputAccessoryView = toolBar

        //uses GestureRecognizer to hide keyboard and datePicker when view is tapped
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(NewTaskViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    //MARK: Editing the text fields
    @IBAction func dateBeginEditing(_ sender: Any) {
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(NewTaskViewController.dateChanged(datePicker:)), for: .valueChanged)
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = toolBar
    }
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateTextField.text = dateFormatter.string(from: datePicker.date)
    }
    
    @IBAction func timeBeginEditing(_ sender: Any) {
        timePicker = UIDatePicker()
        timePicker?.datePickerMode = .time
        timePicker?.addTarget(self, action: #selector(NewTaskViewController.timeChanged(timePicker:)), for: .valueChanged)
        timeTextField.inputView = timePicker
        timeTextField.inputAccessoryView = toolBar
    }
    @objc func timeChanged(timePicker: UIDatePicker) {
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        timeTextField.text = timeFormatter.string(from: timePicker.date)
        print(timeFormatter.string(from: timePicker.date))
    }
    @objc func dismissPicker() {
        view.endEditing(true)
    }
    
    
    // MARK: Save Data
    @IBAction func submitButtonPressed(_ sender: Any) {
        let newTask = Task(context: self.context)
        
        if (nameTextField.text?.isEmpty == true || dateTextField.text?.isEmpty == true) {
            let alert = UIAlertController(title: "Missing Data", message: "Name and Date are required.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            newTask.name = nameTextField.text
            newTask.dueDate = datePicker?.date
            if timeTextField.text?.isEmpty == true {
                print("Item saved without time")
            } else {
                newTask.dueTime = timePicker?.date
            }
            saveData()
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    
    func saveData() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
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

extension UIToolbar {
    
    func ToolbarPicker(mySelect : Selector) -> UIToolbar {
        
        let toolBar = UIToolbar()
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: mySelect)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
}
