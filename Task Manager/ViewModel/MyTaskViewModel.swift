//
//  MyTaskViewModel.swift
//  Task Manager
//
//  Created by Md Shofiulla on 3/7/24.
//

import Foundation
import Combine


class MyTaskViewModel: ObservableObject {
    @Published var taskList: [TaskModel] = []
    private var cancellables: Set<AnyCancellable> = .init()
    private let taskManager = TaskManager.shared
    
    init() {
        fetchTasks()
    }
    func fetchTasks() {
        taskList = taskManager.fetchTasks()
    }
    func addTask(title: String, description: String, dueDate: Date, status: Bool) {
        let taskModel = TaskModel(id: UUID(), title: title, description: description, taskDate: dueDate, taskStatus: status)
        taskManager.addTask(taskModel: taskModel)
        fetchTasks()
    }
    
    func deleteTask(taskModel: TaskModel) {
        taskManager.deleteTask(taskModel: taskModel)
        fetchTasks()
    }
    
    func updateStatus(taskModel: TaskModel) {
        taskManager.updateStatus(taskModel: taskModel)
        fetchTasks()
    }
}
