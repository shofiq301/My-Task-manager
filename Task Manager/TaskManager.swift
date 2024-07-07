//
//  TaskManager.swift
//  Task Manager
//
//  Created by Md Shofiulla on 4/7/24.
//

import Foundation
import CoreData

class TaskManager {
    static let shared = TaskManager()
    var context: NSManagedObjectContext
    
    private init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.context = context
    }
    
    func addTask(taskModel: TaskModel) {
        let _ = taskModel.toTask(context: context)
        saveContext()
    }
    
    func deleteTask(taskModel: TaskModel) {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", taskModel.id as CVarArg)
        
        do {
            let tasks = try context.fetch(fetchRequest)
            if let task = tasks.first {
                context.delete(task)
                saveContext()
            }
        } catch {
            print("Failed to delete task: \(error)")
        }
    }
    
    func updateStatus(taskModel: TaskModel) {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", taskModel.id as CVarArg)
        
        do {
            let tasks = try context.fetch(fetchRequest)
            if let task = tasks.first {
                task.taskStatus = !task.taskStatus
                saveContext()
            }
        } catch {
            print("Failed to update status: \(error)")
        }
    }
    
    func fetchTasks() -> [TaskModel] {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dueDate", ascending: true)]
        
        do {
            let tasks = try context.fetch(fetchRequest)
            return tasks.map { $0.toTaskModel() }
        } catch {
            print("Failed to fetch tasks: \(error)")
            return []
        }
    }
    
    private func saveContext() {
        CoreDataManager.shared.saveContext()
    }
}
