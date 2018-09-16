//
//  TaskModel.swift
//  Bucket List
//
//  Created by Tiange Wang on 9/14/18.
//  Copyright © 2018 Tiange Wang. All rights reserved.
//

import Foundation

class TaskModel {
    static func getAllTasks(completionHandler: @escaping(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        let url = URL(string: "http://localhost:8000/tasks")
        let session = URLSession.shared
        let task = session.dataTask(with: url!, completionHandler: completionHandler)
        task.resume()
    }
    
    static func addTaskWithObjective(objective: String, completionHandler: @escaping(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        if let urlToReq = URL(string: "http://localhost:8000/tasks") {
            var request = URLRequest(url: urlToReq)
            request.httpMethod = "POST"
            let bodyData = ["objective": objective]
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: bodyData, options: .prettyPrinted)
            } catch {
                print("Something went wrong")
            }
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest, completionHandler: completionHandler)
            task.resume()
        }
    }
    
    static func editTaskWithObjective(objective: String, selectedTaskId: String,  completionHandler: @escaping(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        if let urlToReq = URL(string: "http://localhost:8000/tasks/\(selectedTaskId)") {
            var request = URLRequest(url: urlToReq)
            request.httpMethod = "PUT"
            let bodyData = ["objective": objective]
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: bodyData, options: .prettyPrinted)
            } catch {
                print("Something went wrong")
            }
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest, completionHandler: completionHandler)
            task.resume()
        }
    }
    
    static func deleteTask(selectedTaskId: String, completionHandler: @escaping(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        if let urlToReq = URL(string: "http://localhost:8000/tasks/\(selectedTaskId)") {
            var request = URLRequest(url: urlToReq)
            request.httpMethod = "DELETE"
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest, completionHandler: completionHandler)
            task.resume()
        }
    }
}
