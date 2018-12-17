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
    var filteredToDos : [ToDo] = []
    var searchActive : Bool = false
    
    /// Defining outlet
    @IBOutlet weak var searchBar: UISearchBar!
    
    /// Defining delegate for searchbar
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
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    /// Function to check if the checkmarked is active
    func checkmarkTapped(sender: ToDoCell) {
        if let index = tableView.indexPath(for: sender) {
            if searchActive {
                var todo = filteredToDos[index.row]
                todo.isComplete = !todo.isComplete
                filteredToDos[index.row] = todo
                tableView.reloadRows(at: [index], with: .automatic)
                ToDo.saveToDos(filteredToDos)
            }
            else {
                var todo = todos[index.row]
                todo.isComplete = !todo.isComplete
                todos[index.row] = todo
                tableView.reloadRows(at: [index], with: .automatic)
                ToDo.saveToDos(todos)
            }
        }
    }
    
    /// Action to go back to the list and save the new todo
    @IBAction func unwindtoToDoList(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else { return }
        let sourceVC = segue.source as! NewToDoTableViewController
        if searchActive {
            if let todo = sourceVC.todo {
                if let selectedIndex = tableView.indexPathForSelectedRow {
                    filteredToDos[selectedIndex.row] = todo
                    tableView.reloadRows(at: [selectedIndex], with: .none)
                }
                else {
                    let newIndex = IndexPath(row: filteredToDos.count, section: 0)
                    filteredToDos.append(todo)
                    tableView.insertRows(at: [newIndex], with: .automatic)
                }
            }
            ToDo.saveToDos(filteredToDos)
        }
        else {
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
    }
    
    /// Function to give amount of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return filteredToDos.count
        }
        else {
            return todos.count
        }
    }

    /// Function to fill in a cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCellId") as? ToDoCell else {fatalError("Could not dequeue a cell")}
        let todo : ToDo
        if searchActive {
            todo = filteredToDos[indexPath.row]
        }
        else {
            todo = todos[indexPath.row]
        }
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
            if searchActive {
                let todo = filteredToDos[indexPath.row]
                for i in 0..<todos.count {
                    if todos[i].title == todo.title {
                        todos.remove(at: i)
                        break
                    }
                }
                filteredToDos.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            else {
                todos.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            ToDo.saveToDos(todos)
        }
    }
    
    /// Function for the Search Bar to work
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty || searchText == "" {
            searchActive = false
            view.endEditing(true)
            tableView.reloadData()
        }
        else {
            searchActive = true
            filteredToDos = todos.filter({ (ToDo) -> Bool in
                ToDo.title.lowercased().contains(searchText.lowercased())
            })
            tableView.reloadData()
        }
    }
    
    /// Action to send the todo to the detail VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let todoVC = segue.destination as! NewToDoTableViewController
            let index = tableView.indexPathForSelectedRow!
            let selectedToDo : ToDo
            if searchActive {
                selectedToDo = filteredToDos[index.row]
            }
            else {
                selectedToDo = todos[index.row]
            }
            todoVC.todo = selectedToDo
        }
    }
}
