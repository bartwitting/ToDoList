//
//  ToDoTableViewController.swift
//  ToDoList
//
//  Created by Bart Witting on 27/11/2018.
//  Copyright © 2018 Bart Witting. All rights reserved.
//

import UIKit

class ToDoTableViewController: UITableViewController, ToDoCellDelegate {

    var todos : [ToDo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedToDos = ToDo.loadToDos() {
            todos = savedToDos
        }
        else {
//            let todo1 = ToDo(title: "Hi1", isComplete: false, dueDate: Date(), notes: "Test 1")
//            let todo2 = ToDo(title: "Hi2", isComplete: true, dueDate: Date(), notes: "Test 2")
//            let todo3 = ToDo(title: "Hi3", isComplete: false, dueDate: Date(), notes: "Test 3")
            
            //todos = [todo1, todo2, todo3]
            todos = ToDo.loadSampleToDos()!
        }
        navigationItem.leftBarButtonItem = editButtonItem
    }

    func checkmarkTapped(sender: ToDoCell) {
        if let index = tableView.indexPath(for: sender) {
            var todo = todos[index.row]
            todo.isComplete = !todo.isComplete
            todos[index.row] = todo
            tableView.reloadRows(at: [index], with: .automatic)
            ToDo.saveToDos(todos)
        }
    }
    
    @IBAction func unwindtoToDoList(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else { return }
        let sourceVC = segue.source as! NewToDoTableViewController
        
        if let todo = sourceVC.todo {
            if let selectedIndex = tableView.indexPathForSelectedRow {
                todos[selectedIndex.row] = todo
                tableView.reloadRows(at: [selectedIndex], with: .none)
            }
            else {
                let newIndex = IndexPath(row: todos.count, section: 0)
                todos.append(todo)
                tableView.insertRows(at: [newIndex], with: .automatic)
            }
        }
        ToDo.saveToDos(todos)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCellId") as? ToDoCell else {fatalError("Could not dequeue a cell")}
        let todo = todos[indexPath.row]
        cell.titleLabel?.text = todo.title
        cell.isCompleteButt.isSelected = todo.isComplete
        cell.delegate = self
        
        return cell
    }

    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            ToDo.saveToDos(todos)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let todoVC = segue.destination as! NewToDoTableViewController
            let index = tableView.indexPathForSelectedRow!
            let selectedToDo = todos[index.row]
            todoVC.todo = selectedToDo
        }
    }
    
}
