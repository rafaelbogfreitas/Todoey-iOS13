//
//  ToDoListViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift
import SwipeCellKit

class ToDoListViewController: SwipeTableViewController {
   
    var items: Results<Item>?
    
    var selectedCategory: Category? {
        didSet {
            loadData()
        }
    }
    
    let realm = try! Realm()
    
    var defaults = UserDefaults.standard
    
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        var field: UITextField!
        let alert = UIAlertController(title: "Add new todo item", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = field.text!
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error: \(error)")
                }
                
            }
            
            self.tableView.reloadData()
            
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create item"
            field = alertTextField
        }
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Methods
    

//    private func loadData(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
//
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        if let predicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//
//
//        do{
//            items = try context.fetch(request)
//            tableView.reloadData()
//        } catch {
//            print(error)
//        }
//    }
    private func loadData() {
        items = selectedCategory?.items.sorted(
            byKeyPath: "title",
            ascending: true
        )
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = items?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(item)
//                    item.done = !item.done
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
}

extension ToDoListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let currentItem = items?[indexPath.row] {
            cell.textLabel?.text = currentItem.title
            cell.accessoryType = currentItem.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items here yet."
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        self.tableView.reloadData()
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - SearchBar Delegate methods
extension ToDoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        items = items?.filter("title CONTAINS[cd] %@", searchBar.text ?? "").sorted(byKeyPath: "dateCreated", ascending: true)
        
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.predicate = predicate
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadData(with: request, predicate: predicate)
        tableView.reloadData()

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
//            loadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

