//
//  SwipeTableTableViewController.swift
//  Todoey
//
//  Created by Natalia Kazakova on 12/06/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit
import SwipeCellKit
import ChameleonFramework

class SwipeTableTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
    }
    
    // MARK: - Table view data source methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        
        return cell
    }
    
    // MARK: - Swipe Cell Delegate Methods
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else {
            return nil
        }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.updateModel(at: indexPath)
        }
        
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        
        return options
    }
    
    func updateModel(at indexPath: IndexPath) {
        
    }
    
    // MARK: - Nav bar setup methods
    
    func updateNavBar(withHexCode colourHexCode: String) -> UIColor? {
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation controller does not exist.")
        }
        
        guard let navBarColour = UIColor(hexString: colourHexCode) else { fatalError() }
        navBar.barTintColor = navBarColour
        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
        
        return navBarColour
    }
}
