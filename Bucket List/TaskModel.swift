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
}
