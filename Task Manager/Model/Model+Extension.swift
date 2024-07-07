//
//  Model+Extension.swift
//  Task Manager
//
//  Created by Md Shofiulla on 4/7/24.
//

import Foundation
import CoreData
extension Task {
    func toTaskModel() -> TaskModel {
        return TaskModel(
            id: self.id ?? UUID(),
            title: self.title ?? "",
            description: self.taskDescription ?? "",
            taskDate: self.dueDate ?? Date(),
            taskStatus: self.taskStatus
        )
    }
}

extension TaskModel {
    func toTask(context: NSManagedObjectContext) -> Task {
        let task = Task(context: context)
        task.id = self.id
        task.title = self.title
        task.taskDescription = self.description
        task.dueDate = self.taskDate
        task.taskStatus = self.taskStatus
        return task
    }
}
