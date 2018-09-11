//
//  ViewController.swift
//  Bucket List
//
//  Created by Tiange Wang on 9/10/18.
//  Copyright © 2018 Tiange Wang. All rights reserved.
//

import UIKit
import CoreData

class BucketListViewController: UITableViewController, AddItemTableViewControllerDelegate {
    var items: [BucketListItem] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let saveContext = (UIApplication.shared.delegate as! AppDelegate).saveContext
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "segueTo", sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllItems()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListItemCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].text!
        return cell
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "segueTo", sender: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        context.delete(item)
        saveContext()
        items.remove(at: indexPath.row)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if sender is UIBarButtonItem {
            let navigationController =  segue.destination as! UINavigationController
            let addItemTableController = navigationController.topViewController as! AddItemTableViewController
            addItemTableController.delegate = self
        } else if sender is IndexPath {
            let navigationController =  segue.destination as! UINavigationController
            let addItemTableController = navigationController.topViewController as! AddItemTableViewController
            addItemTableController.delegate = self
            let indexPath = sender as! NSIndexPath
            let item = items[indexPath.row]
            addItemTableController.item = item.text!
            addItemTableController.indexPath = indexPath
        }
    }
    
    func fetchAllItems() {
        let request:NSFetchRequest<BucketListItem> = BucketListItem.fetchRequest()
        do {
            let result = try context.fetch(request)
            items = result
        } catch {
            print("\(error)")
        }
    }
    
    func cancelButtonPressed(by controller: AddItemTableViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func itemSaved(by controller: AddItemTableViewController, with text: String, at indexPath: NSIndexPath?) {
        if let ip = indexPath {
            let item = items[ip.row]
            item.text = text
        } else {
            let item = BucketListItem(context: context)
            item.text = text
            items.append(item)
        }
        saveContext()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
}

