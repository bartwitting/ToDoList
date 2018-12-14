//
//  NewToDoTableViewController.swift
//  ToDoList
//
//  Created by Bart Witting on 28/11/2018.
//  Copyright © 2018 Bart Witting. All rights reserved.
//

import UIKit

class NewToDoTableViewController: UITableViewController {
    /// Defining variables, like the todo given by the last VC
    var todo : ToDo?
    var isPickerHidden = true
    
    /// Defining outlets
    @IBOutlet weak var saveBut: UIBarButtonItem!
    @IBOutlet weak var isCompleteBut: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var notesLabel: UITextView!
    
    /// Building the screen with all the info for the cells
    override func viewDidLoad() {
        super.viewDidLoad()
        if let todo = todo {
            navigationItem.title = "To-Do"
            titleTextField.text = todo.title
            isCompleteBut.isSelected = todo.isComplete
            datePicker.date = todo.dueDate
            notesLabel.text = todo.notes
        }
        else {
            datePicker.date = Date().addingTimeInterval(24*60*60)
        }
        updateDateLabel(date: datePicker.date)
        updateSaveButState()
    }

    /// Function to update the state of the save button
    func updateSaveButState() {
        let text = titleTextField.text ?? ""
        saveBut.isEnabled = !text.isEmpty
    }
    
    /// Function to update the date label to this moment
    func updateDateLabel(date: Date) {
        dateLabel.text = ToDo.dateFormatter.string(from: date)
    }
    
    /// Function to update the date label to the data from the picker
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        updateDateLabel(date: datePicker.date)
    }
    
    /// Function to check if the title field is edited and make the save button change
    @IBAction func editChange(_ sender: UITextField) {
        updateSaveButState()
    }
    
    /// Function to deactivate the keyboard
    @IBAction func returnPress(_ sender: UITextField) {
        titleTextField.resignFirstResponder()
    }
    
    /// Function to update the checkmark picture
    @IBAction func isCompletePress(_ sender: UIButton) {
        isCompleteBut.isSelected = !isCompleteBut.isSelected
    }

    /// Function to adjust the height of the celss
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let normalHeight = CGFloat(44)
        let largeHeight = CGFloat(200)
        
        switch indexPath {
        case [1,0]:
            return isPickerHidden ? normalHeight : largeHeight
        case [2,0]:
            return largeHeight
        default:
            return normalHeight
        }
    }
    
    /// Function to open or close the date picker
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case [1,0]:
            isPickerHidden = !isPickerHidden
            
            dateLabel.textColor = isPickerHidden ? .black : tableView.tintColor
            
            tableView.beginUpdates()
            tableView.endUpdates()
        default:
            break
        }
    }
    
    /// Action to send the todo back to the list
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else { return }
        
        let title = titleTextField.text!
        let isComplete = isCompleteBut.isSelected
        let date = datePicker.date
        let notes = notesLabel.text
        
        todo = ToDo(title: title, isComplete: isComplete, dueDate: date, notes: notes)
    }
}
