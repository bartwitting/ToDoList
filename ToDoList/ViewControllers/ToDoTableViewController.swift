//
//  ToDoTableViewController.swift
//  ToDoList
//
//  Created by Bart Witting on 27/11/2018.
//  Copyright © 2018 Bart Witting. All rights reserved.
//

import UIKit

class ToDoTableViewController: UITableViewController, ToDoCellDelegate, UISearchBarDelegate {

    /// Defining variables
    var todos : [ToDo] = []
    var oldToDos : [ToDo] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private func setupSearchBar () {
        searchBar.delegate = self
    }
    
    /// Function to build the screen by checking all the todo's
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedToDos = ToDo.loadToDos() {
            todos = savedToDos
        }
        else {
            todos = ToDo.loadSampleToDos()!
        }
        makeCopy()
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    func makeCopy() {
        oldToDos = todos
    }
    

    /// Function to check if the checkmarked is active
    func checkmarkTapped(sender: ToDoCell) {
        if let index = tableView.indexPath(for: sender) {
            var todo = todos[index.row]
            todo.isComplete = !todo.isComplete
            todos[index.row] = todo
            tableView.reloadRows(at: [index], with: .automatic)
            ToDo.saveToDos(todos)
        }
    }
    
    /// Action to go back to the list and save the new todo
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
        makeCopy()
        ToDo.saveToDos(todos)
    }
    
    /// Function to give amount of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }

    /// Function to fill in a cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCellId") as? ToDoCell else {fatalError("Could not dequeue a cell")}
        let todo = todos[indexPath.row]
        cell.titleLabel?.text = todo.title
        cell.isCompleteButt.isSelected = todo.isComplete
        cell.delegate = self
        
        return cell
    }

    /// Function to make editing possible
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /// Function to make removing possible
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let todo = todos[indexPath.row]
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            ToDo.saveToDos(todos)
        }
    }
    // Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            todos = oldToDos
            tableView.reloadData()
            return
        }
        todos = oldToDos.filter({ (ToDo) -> Bool in
            ToDo.title.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    /// Action to send the todo to the detail VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let todoVC = segue.destination as! NewToDoTableViewController
            let index = tableView.indexPathForSelectedRow!
            let selectedToDo = todos[index.row]
            todoVC.todo = selectedToDo
        }
    }
    
}
