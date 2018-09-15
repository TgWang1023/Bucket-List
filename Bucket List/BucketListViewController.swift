//
//  ViewController.swift
//  Bucket List
//
//  Created by Tiange Wang on 9/10/18.
//  Copyright © 2018 Tiange Wang. All rights reserved.
//

import UIKit

class BucketListViewController: UITableViewController {
    
    var tasks: [NSDictionary] = []
    var objectives: [String] = []
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "segueTo", sender: sender)
    }
    
    override func viewDidLoad() {
        TaskModel.getAllTasks() {
            data, response, error in
            do {
                if let tsk = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    self.tasks = tsk["data"] as! [NSDictionary]
                    for task in self.tasks {
                        self.objectives.append(task["objective"] as! String)
                    }
                    print(self.objectives)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            } catch {
                print("Something went wrong")
            }
        }
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListItemCell", for: indexPath)
        cell.textLabel?.text = objectives[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "segueTo", sender: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        tasks.remove(at: indexPath.row)
        objectives.remove(at: indexPath.row)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let addItemTableViewController = navigationController.topViewController as! AddItemTableViewController
        addItemTableViewController.delegate = self
        
    }
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if sender is UIBarButtonItem {
//            let navigationController =  segue.destination as! UINavigationController
//            let addItemTableController = navigationController.topViewController as! AddItemTableViewController
//        }
//        else if sender is IndexPath {
//            let navigationController =  segue.destination as! UINavigationController
//            let addItemTableController = navigationController.topViewController as! AddItemTableViewController
//            addItemTableController.delegate = self
//            let indexPath = sender as! NSIndexPath
//            let item = items[indexPath.row]
//            addItemTableController.item = item.text!
//            addItemTableController.indexPath = indexPath
//        }
//    }

}
extension BucketListViewController: AddItemTableViewControllerDelegate {
    
    func addItemViewController(_ controller: AddItemTableViewController, didFinishAddingItem item: String) {
        TaskModel.addTaskWithObjective(objective: item) {
            data, response, error in
            do {
                if let added_task = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary {
                    print(added_task)
                    let temp = added_task["data"] as! NSArray
                    let elem = temp[0] as! NSDictionary
                    self.tasks.append(elem)
                    self.objectives.append(elem["objective"] as! String)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            } catch {
                print("Something went wrong")
                print(error)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func addItemViewController(_ controller: AddItemTableViewController, didPressCancelButton button: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}

