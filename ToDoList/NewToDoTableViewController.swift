//
//  NewToDoTableViewController.swift
//  ToDoList
//
//  Created by Bart Witting on 28/11/2018.
//  Copyright © 2018 Bart Witting. All rights reserved.
//

import UIKit

class NewToDoTableViewController: UITableViewController {
    var todo : ToDo?
    var isPickerHidden = true
    
    @IBOutlet weak var saveBut: UIBarButtonItem!
    @IBOutlet weak var isCompleteBut: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var notesLabel: UITextView!
    
    
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

    func updateSaveButState() {
        let text = titleTextField.text ?? ""
        saveBut.isEnabled = !text.isEmpty
    }
    
    func updateDateLabel(date: Date) {
        dateLabel.text = ToDo.dateFormatter.string(from: date)
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        updateDateLabel(date: datePicker.date)
    }
    
    @IBAction func editChange(_ sender: UITextField) {
        updateSaveButState()
    }
    
    @IBAction func returnPress(_ sender: UITextField) {
        titleTextField.resignFirstResponder()
    }
    
    @IBAction func isCompletePress(_ sender: UIButton) {
        isCompleteBut.isSelected = !isCompleteBut.isSelected
    }

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
