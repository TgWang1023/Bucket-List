//
//  AddItemTableViewControllerDelegate.swift
//  Bucket List
//
//  Created by Tiange Wang on 9/10/18.
//  Copyright © 2018 Tiange Wang. All rights reserved.
//

import Foundation
import UIKit

protocol AddItemTableViewControllerDelegate: class {
    
    func addItemViewController(_ controller: AddItemTableViewController, didFinishAddingItem item: String)
    func addItemViewController(_ controller: AddItemTableViewController, didPressCancelButton button: UIBarButtonItem) 
}
