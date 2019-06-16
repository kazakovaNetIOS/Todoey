//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Natalia Kazakova on 07/06/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableTableViewController {
    
    let realm = try! Realm()

    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
        
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateNavBar(withHexCode: "FF85FF")
    }

    // MARK: - Table view data source methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            
            guard let categoryColor = UIColor(hexString: category.colour) else { fatalError() }
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    // MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = self.categories?[indexPath.row]
        }
    }
    
    // MARK: - Data manipulation methods
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context \(error)")
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Delete data from swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = categories?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("Error deleting category \(error)")
            }
        }
    }

    // MARK: - Add new categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField: UITextField? = nil
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField!.text!
            newCategory.colour = UIColor.randomFlat.hexValue()
            
            self.save(category: newCategory)
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Nav bar setup methods
    
    override func updateNavBar(withHexCode colourHexCode: String) -> UIColor? {
        return super.updateNavBar(withHexCode: colourHexCode)
    }
}
