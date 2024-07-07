//
//  TaskBottomSheetViewController.swift
//  Task Manager
//
//  Created by Md Shofiulla on 3/7/24.
//

import Foundation
import UIKit


class TaskBottomSheetViewController: UIViewController {
    
    // MARK: - Components
    lazy private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Add Task"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    lazy private var titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Title"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    lazy private var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "Description"
        textView.textColor = .lightGray
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 8.0
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.delegate = self
        return textView
    }()
    
    lazy private var dueDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Due Date"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    lazy private var dueDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .dateAndTime
        return datePicker
    }()
    
    lazy private var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8.0
        button.addTarget(self, action: #selector(saveTask), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    var taskModel: TaskModel?
    var viewModel: MyTaskViewModel?
    var onSave: ((String, String, Date) -> Void)?
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        view.backgroundColor = .white
        view.layer.cornerRadius = 12.0
        view.layer.masksToBounds = true
        
        view.addSubview(titleLabel)
        view.addSubview(titleTextField)
        view.addSubview(descriptionTextView)
        view.addSubview(dueDateLabel)
        view.addSubview(dueDatePicker)
        view.addSubview(saveButton)
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleTextField.heightAnchor.constraint(equalToConstant: 40),
            
            descriptionTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 16),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 100),
            
            dueDateLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 16),
            dueDateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            dueDatePicker.topAnchor.constraint(equalTo: dueDateLabel.bottomAnchor, constant: 8),
            dueDatePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dueDatePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            saveButton.topAnchor.constraint(equalTo: dueDatePicker.bottomAnchor, constant: 24),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 46),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - Actions
    @objc private func saveTask() {
        
        guard let title = titleTextField.text, !title.isEmpty,
              let description = descriptionTextView.text, !description.isEmpty else {
            return
        }
        
        if var taskModel = taskModel {
            taskModel = TaskModel(id: taskModel.id, title: title, description: description, taskDate: dueDatePicker.date, taskStatus: taskModel.taskStatus)
            viewModel?.deleteTask(taskModel: taskModel)
            viewModel?.addTask(title: title, description: description, dueDate: taskModel.taskDate,status: taskModel.taskStatus)
        } else {
            let dueDate = dueDatePicker.date
            onSave?(title, description, dueDate)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func populateFields() {
        if let taskModel = taskModel {
            titleTextField.text = taskModel.title
            descriptionTextView.text = taskModel.description
            dueDatePicker.date = taskModel.taskDate
            saveButton.setTitle("Update", for: .normal)
            titleLabel.text = "Task title"
            descriptionTextView.textColor = .black
        }
    }
}
extension TaskBottomSheetViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Description" {
            textView.text = ""
            textView.textColor = .black
        }
    }
}
