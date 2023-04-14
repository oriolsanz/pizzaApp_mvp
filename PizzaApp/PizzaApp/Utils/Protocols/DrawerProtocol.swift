//
//  DrawerProtocol.swift
//  PizzaApp
//
//  Created by Oriol Sanz Vericat on 10/4/23.
//

import UIKit

/**
    This protocol defines methods for a drawer object to create a UITableViewCell and draw it with an item.
*/
internal protocol DrawerProtocol {
    
    /**
     Returns a UITableViewCell for a given index path in a UITableView.
     
     - Parameters:
        - tableView: The UITableView for which the cell is being created.
        - indexPath: The index path for which the cell is being created.
     
     - Returns: A UITableViewCell object for the given index path.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    
    /**
     Draws the given cell with the specified item.
     
     - Parameters:
        - cell: The UITableViewCell to be drawn.
        - item: The item to be drawn in the cell.
     */
    func drawCell(_ cell: UITableViewCell, withItem item: Any)
}

/**
    This protocol defines an object that can provide a drawer object conforming to DrawerProtocol.
*/
internal protocol DrawerItemProtocol {
    
    /**
     Returns a drawer object conforming to DrawerProtocol.
     
     - Returns: A drawer object conforming to DrawerProtocol.
     */
    var cellDrawer: DrawerProtocol { get }
}
