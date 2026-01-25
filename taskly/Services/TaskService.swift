//
//  TaskService.swift
//  taskly
//
//  Task service for CRUD operations on TaskItem entities
//

import Foundation
import SwiftData

/// Task service implementing TaskServiceProtocol
@MainActor
class TaskService: TaskServiceProtocol {
    private let dataManager: SwiftDataManager
    
    init(dataManager: SwiftDataManager = .shared) {
        self.dataManager = dataManager
    }
    
    // MARK: - Fetch Operations
    
    func fetchTasks() async throws -> [TaskItem] {
        try dataManager.fetch(TaskItem.self)
    }
    
    /// Fetch tasks with predicate
    func fetchTasks(predicate: Predicate<TaskItem>) async throws -> [TaskItem] {
        try dataManager.fetch(TaskItem.self, predicate: predicate)
    }
    
    /// Fetch tasks sorted by date
    func fetchTasksSorted(by sortDescriptors: [SortDescriptor<TaskItem>]) async throws -> [TaskItem] {
        try dataManager.fetch(TaskItem.self, sortDescriptors: sortDescriptors)
    }
    
    /// Fetch task by ID
    func fetchTask(id: UUID) async throws -> TaskItem? {
        try dataManager.fetch(TaskItem.self, id: id)
    }
    
    /// Fetch tasks for a specific project
    func fetchTasks(for project: Project) async throws -> [TaskItem] {
        // SwiftData predicates have limitations with optional chaining
        // Fetch all tasks and filter in Swift for project relationship
        let allTasks = try await fetchTasks()
        return allTasks.filter { task in
            task.project?.id == project.id
        }
    }
    
    /// Fetch tasks for today
    func fetchTasksForToday() async throws -> [TaskItem] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        // Predicate must be a single expression - check that dueDate exists and is within range
        let predicate = #Predicate<TaskItem> { task in
            task.dueDate != nil && 
            task.dueDate! >= startOfDay && 
            task.dueDate! < endOfDay
        }
        return try await fetchTasks(predicate: predicate)
    }
    
    /// Fetch flagged tasks
    func fetchFlaggedTasks() async throws -> [TaskItem] {
        let predicate = #Predicate<TaskItem> { task in
            task.isFlagged == true
        }
        return try await fetchTasks(predicate: predicate)
    }
    
    /// Fetch completed tasks
    func fetchCompletedTasks() async throws -> [TaskItem] {
        let predicate = #Predicate<TaskItem> { task in
            task.isCompleted == true
        }
        return try await fetchTasks(predicate: predicate)
    }
    
    /// Fetch incomplete tasks
    func fetchIncompleteTasks() async throws -> [TaskItem] {
        let predicate = #Predicate<TaskItem> { task in
            task.isCompleted == false
        }
        return try await fetchTasks(predicate: predicate)
    }
    
    // MARK: - Create Operations
    
    func createTask(_ task: TaskItem) async throws {
        task.touch() // Update timestamp
        dataManager.insert(task)
        try dataManager.save()
    }
    
    /// Create a new task with parameters
    func createTask(
        title: String,
        description: String = "",
        dueDate: Date? = nil,
        priority: TaskPriority = .medium,
        isFlagged: Bool = false,
        project: Project? = nil
    ) async throws -> TaskItem {
        let task = TaskItem(
            title: title,
            taskDescription: description,
            dueDate: dueDate,
            priority: priority,
            isFlagged: isFlagged,
            project: project
        )
        try await createTask(task)
        return task
    }
    
    // MARK: - Update Operations
    
    func updateTask(_ task: TaskItem) async throws {
        task.touch() // Update timestamp
        try dataManager.save()
    }
    
    /// Toggle task completion
    func toggleCompletion(_ task: TaskItem) async throws {
        task.isCompleted.toggle()
        try await updateTask(task)
    }
    
    /// Toggle task flag
    func toggleFlag(_ task: TaskItem) async throws {
        task.isFlagged.toggle()
        try await updateTask(task)
    }
    
    // MARK: - Delete Operations
    
    func deleteTask(_ task: TaskItem) async throws {
        dataManager.delete(task)
        try dataManager.save()
    }
    
    /// Delete multiple tasks
    func deleteTasks(_ tasks: [TaskItem]) async throws {
        dataManager.delete(tasks)
        try dataManager.save()
    }
    
    /// Delete completed tasks
    func deleteCompletedTasks() async throws {
        let completed = try await fetchCompletedTasks()
        try await deleteTasks(completed)
    }
}
