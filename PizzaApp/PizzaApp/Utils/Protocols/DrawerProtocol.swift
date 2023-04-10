//
//  DrawerProtocol.swift
//  PizzaApp
//
//  Created by Oriol Sanz Vericat on 10/4/23.
//

import UIKit

internal protocol DrawerProtocol {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    func drawCell(_ cell: UITableViewCell, withItem item: Any)
}

internal protocol DrawerItemProtocol {
    var cellDrawer: DrawerProtocol { get }
}
