//
//  ViewController.swift
//  Task Manager
//
//  Created by Md Shofiulla on 2/7/24.
//

import UIKit
import Combine

enum DefaultSection {
    case main
}

    class MainViewController: UIViewController {
        
        // MARK: - Components
        lazy private var titleText: UILabel =  {
            let text = UILabel()
            text.text = "My Task Manager"
            text.translatesAutoresizingMaskIntoConstraints = false
            return text
        }()
        
        lazy private var devider: UIView = {
            let view = UIView()
            view.backgroundColor = .lightGray.withAlphaComponent(0.1)
            view.heightAnchor.constraint(equalToConstant: 1).isActive = true
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        lazy var mainCollectionView: UICollectionView = {
            var collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: makeLayout())
            collectionView.register(TaskItemCell.self, forCellWithReuseIdentifier: TaskItemCell.identifier)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            return collectionView
        }()
        
        lazy private var emptyTextLabel: UILabel =  {
            let text = UILabel()
            text.text = "No tasks available, please add a new task."
            text.translatesAutoresizingMaskIntoConstraints = false
            text.isHidden = false
            text.font = UIFont.systemFont(ofSize: 14)
            text.textColor = .gray
            text.textAlignment = .center
            return text
        }()
        
        lazy private var addButton: UIButton = {
            let button = UIButton(type: .system)
            
            let image = UIImage(systemName: "plus")
            button.setImage(image, for: .normal)
            
            
            button.tintColor = .white
            button.backgroundColor = .systemBlue
            button.layer.cornerRadius = 21
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOpacity = 0.2
            button.layer.shadowOffset = CGSize(width: 0, height: 2)
            button.layer.shadowRadius = 4
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(addNewTask), for: .touchUpInside)
            return button
        }()
        
        // MARK: - Components
        private typealias DataSource = UICollectionViewDiffableDataSource<DefaultSection, TaskModel>
        private var dataSource: DataSource?
        let viewModel = MyTaskViewModel()
        private var cancellables = Set<AnyCancellable>()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = .systemBackground
            addChildComponents()
            addChildConstraints()
            setupCollectionView()
            setupBindings()
        }
        
        private func addChildComponents() {
            self.view.addSubview(titleText)
            self.view.addSubview(devider)
            self.view.addSubview(mainCollectionView)
            self.view.addSubview(addButton)
            self.view.addSubview(emptyTextLabel)
        }
        
        private func addChildConstraints() {
            NSLayoutConstraint.activate([
                titleText.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
                titleText.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
                titleText.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
                
                devider.topAnchor.constraint(equalTo: self.titleText.bottomAnchor, constant: 8),
                devider.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
                devider.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
                
                mainCollectionView.topAnchor.constraint(equalTo: self.devider.bottomAnchor, constant: 0),
                mainCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
                mainCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
                mainCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 16),
                
                addButton.widthAnchor.constraint(equalToConstant: 42),
                addButton.heightAnchor.constraint(equalToConstant: 42),
                addButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
                addButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                
                emptyTextLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
                emptyTextLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
                emptyTextLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
                emptyTextLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
            ])
        }
        
        @objc private func addNewTask() {
            let taskBottomSheetVC = TaskBottomSheetViewController()
            taskBottomSheetVC.onSave = { [weak self] title, description, dueDate in
                self?.viewModel.addTask(title: title, description: description, dueDate: dueDate, status: false)
            }
            if let sheet = taskBottomSheetVC.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.preferredCornerRadius = 16
                sheet.largestUndimmedDetentIdentifier = .medium
            }
            // Present the sheet
            present(taskBottomSheetVC, animated: true)
        }
    }


    extension MainViewController {
        private func setupBindings(){
            self.viewModel.$taskList
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] updatedData in
                    self?.applyData(taskList: updatedData.sorted(by: { $0.taskDate < $1.taskDate }))
                    if updatedData.isEmpty {
                        self?.emptyTextLabel.isHidden = false
                    }else {
                        self?.emptyTextLabel.isHidden = true
                    }
                })
                .store(in: &cancellables)
        }
        
        private func applyData(taskList: [TaskModel]) {
            var snapshot = NSDiffableDataSourceSnapshot<DefaultSection, TaskModel>()
            snapshot.appendSections([.main])
            snapshot.appendItems(taskList)
            dataSource?.apply(snapshot, animatingDifferences: true)
        }
    }
    extension MainViewController {
        
        private func setupCollectionView() {
            mainCollectionView.delegate = self
            setupCollectionViewDataSource()
        }
        
        private func makeLayout() -> UICollectionViewCompositionalLayout {
            let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
                return self?.myTaskSectionLayout()
            }
            let config = UICollectionViewCompositionalLayoutConfiguration()
            config.interSectionSpacing = 20
            layout.configuration = config
            return layout
            
        }
        
        
        func myTaskSectionLayout() -> NSCollectionLayoutSection {
            // Item
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            // Group
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 12
            
            section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
            
            return section
        }
    }

    extension MainViewController: UICollectionViewDelegate {
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            guard let taskItem = dataSource?.itemIdentifier(for: indexPath) as? TaskModel else { fatalError("Task not found") }
            let taskBottomSheetVC = TaskBottomSheetViewController()
            taskBottomSheetVC.taskModel = taskItem
            taskBottomSheetVC.viewModel = viewModel
            taskBottomSheetVC.populateFields()
            if let sheet = taskBottomSheetVC.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.preferredCornerRadius = 16
                sheet.largestUndimmedDetentIdentifier = .medium
            }
            // Present the sheet
            present(taskBottomSheetVC, animated: true)
        }
    }

    extension MainViewController {
        private func setupCollectionViewDataSource(){
            dataSource = DataSource(collectionView: mainCollectionView) { collectionView, indexPath, item in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskItemCell.identifier, for: indexPath) as? TaskItemCell else { fatalError("Can't find cell with identifier TaskItemCell")}
                cell.setupData(title: item.title, description: item.description, dueDate: item.taskDate.formatted(), status: item.taskStatus)
                cell.indexPath = indexPath
                cell.onDelete = { [weak self] indexPath in
                    if let item = self?.dataSource?.itemIdentifier(for: indexPath) {
                        self?.viewModel.deleteTask(taskModel: item)
                    }
                }
                cell.onTaskUpdate = { [weak self] indexPath in
                    if let item = self?.dataSource?.itemIdentifier(for: indexPath) , !item.taskStatus{
                        self?.viewModel.updateStatus(taskModel: item)
                    }
                }
                return cell
            }
        }
    }
