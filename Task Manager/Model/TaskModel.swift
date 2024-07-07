//
//  TaskModel.swift
//  Task Manager
//
//  Created by Md Shofiulla on 3/7/24.
//

import Foundation
struct TaskModel: Hashable {
    let id: UUID
    let title: String
    let description: String
    let taskDate: Date
    var taskStatus: Bool
    
    init(id: UUID, title: String, description: String, taskDate: Date, taskStatus: Bool) {
        self.id = id
        self.title = title
        self.description = description
        self.taskDate = taskDate
        self.taskStatus = taskStatus
    }
}
