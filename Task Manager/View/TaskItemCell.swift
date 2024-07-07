//
//  TaskItemCell.swift
//  Task Manager
//
//  Created by Md Shofiulla on 2/7/24.
//

import UIKit

class TaskItemCell: UICollectionViewCell {
    
    // MARK: - Components
    lazy var taskTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    lazy var taskDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    lazy var taskStatus: UIImageView = {
        let status = UIImageView()
        status.translatesAutoresizingMaskIntoConstraints = false
        status.layer.cornerRadius = 12
        status.layer.masksToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dueDateTapped))
        status.isUserInteractionEnabled = true
        status.addGestureRecognizer(tapGesture)
        
        return status
    }()
    
    lazy var dueDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let image = UIImage(systemName: "trash")
        button.setImage(image, for: .normal)
        
        button.tintColor = .red
        button.addTarget(self, action: #selector(deleteTask), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    private var constantValue: CGFloat = 12
    public static let identifier = String(describing: TaskItemCell.self)
    var indexPath: IndexPath?
    var onDelete: ((IndexPath) -> Void)?
    var onTaskUpdate: ((IndexPath) -> Void)?
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        styleCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Styling
    private func styleCell() {
        self.contentView.layer.cornerRadius = 8
        self.contentView.layer.shadowColor = UIColor.black.cgColor
        self.contentView.layer.shadowOpacity = 0.1
        self.contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.contentView.layer.shadowRadius = 4
        self.contentView.layer.masksToBounds = false
        self.contentView.backgroundColor = .white
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        self.contentView.addSubview(taskTitle)
        self.contentView.addSubview(taskDescription)
        self.contentView.addSubview(taskStatus)
        self.contentView.addSubview(dueDateLabel)
        self.contentView.addSubview(deleteButton)
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            taskStatus.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -constantValue),
            taskStatus.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: constantValue),
            taskStatus.heightAnchor.constraint(equalToConstant: 24),
            taskStatus.widthAnchor.constraint(equalToConstant: 24),
            
            taskTitle.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: constantValue),
            taskTitle.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: constantValue),
            taskTitle.trailingAnchor.constraint(equalTo: self.taskStatus.leadingAnchor, constant: -constantValue),
            
            dueDateLabel.topAnchor.constraint(equalTo: self.taskTitle.bottomAnchor, constant: constantValue),
            dueDateLabel.leadingAnchor.constraint(equalTo: self.taskTitle.leadingAnchor),
            
            
            deleteButton.topAnchor.constraint(equalTo: taskStatus.bottomAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: taskStatus.trailingAnchor),
            
            taskDescription.topAnchor.constraint(equalTo: self.dueDateLabel.bottomAnchor, constant: constantValue),
            taskDescription.leadingAnchor.constraint(equalTo: self.taskTitle.leadingAnchor),
            taskDescription.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -constantValue),
            taskDescription.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -constantValue)
        ])
    }
    
    // MARK: - Setup Data
    func setupData(title: String, description: String, dueDate: String, status: Bool) {
        taskTitle.text = title
        taskDescription.text = description
        dueDateLabel.text = "Due: \(dueDate)"
        taskStatus.image = UIImage(systemName: status ? "person.badge.shield.checkmark" : "figure.archery")
    }
    
    @objc private func deleteTask() {
        if let indexPath = indexPath {
            onDelete?(indexPath)
        }
    }
    @objc private func dueDateTapped() {
        if let indexPath = indexPath {
            onTaskUpdate?(indexPath)
        }
    }
}

