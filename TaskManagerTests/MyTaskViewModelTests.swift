//
//  MyTaskViewModelTests.swift
//  TaskManagerTests
//
//  Created by Md Shofiulla on 5/7/24.
//

import XCTest
import CoreData
import Combine
@testable import Task_Manager

final class MyTaskViewModelTests: XCTestCase {
    
    var viewModel: MyTaskViewModel!
    var coreDataManager: CoreDataManager!
    var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        
        coreDataManager = CoreDataManager(inMemory: true)
        
        TaskManager.shared.context = coreDataManager.context
        
        viewModel = MyTaskViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        coreDataManager = nil
        super.tearDown()
    }
    
    func testEmpltyTasks() {
        XCTAssertEqual(viewModel.taskList.count, 0)
        XCTAssertTrue(viewModel.taskList.isEmpty, "The task list should be empty after fetching tasks initially.")
    }
    
    func testFetchTasks() {
        viewModel.addTask(title: "Test Task", description: "Test Description", dueDate: Date(), status: false)
        
        XCTAssertEqual(viewModel.taskList.count, 1)
        XCTAssertEqual(viewModel.taskList.first?.title, "Test Task")
    }
    
    func testAddTask() {
        viewModel.addTask(title: "New Task", description: "New Description", dueDate: Date(), status: false)
        
        XCTAssertEqual(viewModel.taskList.count, 1)
        XCTAssertEqual(viewModel.taskList.first?.title, "New Task")
    }
    
    func testDeleteTask() {
        viewModel.addTask(title: "Test Task", description: "Test Description", dueDate: Date(), status: false)
        viewModel.deleteTask(taskModel: viewModel.taskList.first!)
        
        XCTAssertEqual(viewModel.taskList.count, 0)
    }
    
    func testUpdateTaskStatus() {
        viewModel.addTask(title: "Test Task", description: "Test Description", dueDate: Date(), status: false)
        if var task = viewModel.taskList.first {
            task.taskStatus = true
            viewModel.updateStatus(taskModel: task)
            
            XCTAssertEqual(viewModel.taskList.first?.taskStatus, true)
        }
    }
}
