//
//  AddItemTableViewControllerDelegate.swift
//  Bucket List
//
//  Created by Tiange Wang on 9/10/18.
//  Copyright © 2018 Tiange Wang. All rights reserved.
//

import Foundation

protocol AddItemTableViewControllerDelegate: class {
    func itemSaved(by controller: AddItemTableViewController, with text: String, at indexPath: NSIndexPath?)
    func cancelButtonPressed(by controller: AddItemTableViewController)
}
