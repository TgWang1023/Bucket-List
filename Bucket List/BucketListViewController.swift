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
        TaskModel.deleteTask(selectedTaskId: tasks[indexPath.row]["_id"] as! String) {
            data, response, error in
            do {
                self.tasks.remove(at: indexPath.row)
                self.objectives.remove(at: indexPath.row)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } 
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let addItemTableViewController = navigationController.topViewController as! AddItemTableViewController
        addItemTableViewController.delegate = self
        if sender is IndexPath {
            let indexPath = sender as! NSIndexPath
            let objective = objectives[indexPath.row]
            addItemTableViewController.item = objective
            addItemTableViewController.indexPath = indexPath
        }
        
    }

}
extension BucketListViewController: AddItemTableViewControllerDelegate {
    
    func addItemViewController(_ controller: AddItemTableViewController, didFinishAddingItem item: String, at indexPath: NSIndexPath?) {
        if let ip = indexPath {
            TaskModel.editTaskWithObjective(objective: item, selectedTaskId: tasks[ip.row]["_id"] as! String) {
                data, response, error in
                do {
                    if let edited_task = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary {
                        let temp = edited_task["data"] as! NSDictionary
                        self.tasks[ip.row] = temp
                        self.objectives[ip.row] = temp["objective"] as! String
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                } catch {
                    print("Something went wrong")
                    print(error)
                }
            }
        } else {
            TaskModel.addTaskWithObjective(objective: item) {
                data, response, error in
                do {
                    if let added_task = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary {
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
        }
        dismiss(animated: true, completion: nil)
    }
    
    func addItemViewController(_ controller: AddItemTableViewController, didPressCancelButton button: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}

