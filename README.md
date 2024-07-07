# Overview
The Task Manager app helps users efficiently manage their tasks and to-dos. Users can add, update, delete, and view tasks in a simple and intuitive interface. The app uses Core Data for persistent storage, ensuring tasks are saved and accessible across sessions. Tasks are sorted by due date, making it easy to prioritize work.

## Features
* Add new tasks with a title, description, and due date
* Update existing tasks
* Delete tasks
* Tasks are sorted by due date
* Persistent storage using Core Data

## Architecture
The Task Manager app is built using UIKit and Core Data. Here's an overview of the architecture:

**Model:**
TaskModel: Represents a task with properties such as id, title, description, taskDate, and taskStatus.
**Core Data:**
- `Task`: Core Data entity for storing task information.
- `CoreDataManager`: Manages the Core Data stack, including the persistent container and context.
- `TaskManager`: Provides methods to add, delete, update, and fetch tasks from Core Data.

**ViewModel:**
- `MyTaskViewModel`: Manages the task list and interacts with TaskManager to fetch, add, delete, and update tasks.

**View:**
- `MainViewController`: Displays the task list and handles user interactions.
- `TaskBottomSheetViewController`: Provides a form for adding and updating tasks.

## Setup Instructions
1. Clone the repository:

```bash
git clone https://github.com/your-username/task-manager-app.git
cd task-manager-app
```

2. Open the project:
Open `TaskManager.xcodeproj` in Xcode.

3. Run the app:
- Select the target device or simulator and click Xcode's `Run` button.

# Assumptions
- The app assumes the user will input a title, description, and due date when adding a new task.
- The app does not handle user authentication.
- The app assumes that Core Data is correctly set up and functioning.
- The TaskManager.shared singleton is used for managing Core Data operations.

Project Overview link [here](https://drive.google.com/file/d/1jSaW0o2MvVYo-VGesr0A3W19XA5kivi4/view?usp=drive_link)

# Unit Testing
The app includes unit tests to verify the functionality of the TaskManager and MyTaskViewModel classes. To run the tests:
Open the project in Xcode.
Select the test target in the scheme menu.
Run the tests using `Cmd+U.`
The test cases cover adding, updating, deleting, and fetching tasks.

<img width="1440" alt="Screenshot 2024-07-07 at 10 53 30 AM" src="https://github.com/shofiq301/My-Task-manager/assets/36738344/7baa7b7c-b8c4-434d-95d4-79532eab7e99">

