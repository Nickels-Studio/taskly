//
//  ConflictResolutionService.swift
//  taskly
//
//  Conflict resolution service for CloudKit sync conflicts
//

import Foundation
import SwiftData

/// Conflict resolution strategies
enum ConflictResolutionStrategy {
    case lastWriteWins
    case serverWins
    case clientWins
    case manualMerge
}

/// Service for handling CloudKit sync conflicts
@MainActor
class ConflictResolutionService {
    static let shared = ConflictResolutionService()
    
    private var strategy: ConflictResolutionStrategy = .lastWriteWins
    
    private init() {}
    
    /// Set conflict resolution strategy
    func setStrategy(_ strategy: ConflictResolutionStrategy) {
        self.strategy = strategy
    }
    
    /// Resolve conflict between two versions of a TaskItem
    func resolveTaskConflict(local: TaskItem, remote: TaskItem) -> TaskItem {
        switch strategy {
        case .lastWriteWins:
            // Use the one with the most recent updatedAt timestamp
            // updatedAt is not optional, so we can compare directly
            return local.updatedAt > remote.updatedAt ? local : remote
            
        case .serverWins:
            return remote
            
        case .clientWins:
            return local
            
        case .manualMerge:
            // Merge strategy: combine non-conflicting changes
            return mergeTaskItems(local: local, remote: remote)
        }
    }
    
    /// Resolve conflict between two versions of a Project
    func resolveProjectConflict(local: Project, remote: Project) -> Project {
        switch strategy {
        case .lastWriteWins:
            // Projects don't have updatedAt, so use creation date
            return local.createdAt > remote.createdAt ? local : remote
            
        case .serverWins:
            return remote
            
        case .clientWins:
            return local
            
        case .manualMerge:
            return mergeProjects(local: local, remote: remote)
        }
    }
    
    // MARK: - Merge Helpers
    
    private func mergeTaskItems(local: TaskItem, remote: TaskItem) -> TaskItem {
        // Create merged version
        let merged = TaskItem(
            title: remote.title.isEmpty ? local.title : remote.title,
            taskDescription: remote.taskDescription.isEmpty ? local.taskDescription : remote.taskDescription,
            dueDate: remote.dueDate ?? local.dueDate,
            priority: TaskPriority(rawValue: remote.priority) ?? TaskPriority(rawValue: local.priority) ?? .medium,
            isFlagged: remote.isFlagged || local.isFlagged, // If either is flagged, keep flagged
            isCompleted: remote.isCompleted && local.isCompleted, // Both must be completed
            createdAt: local.createdAt < remote.createdAt ? local.createdAt : remote.createdAt,
            updatedAt: Date() // Set to now
        )
        
        // Merge relationships
        merged.project = remote.project ?? local.project
        merged.subtasks = remote.subtasks ?? local.subtasks ?? []
        merged.tags = remote.tags ?? local.tags ?? []
        
        return merged
    }
    
    private func mergeProjects(local: Project, remote: Project) -> Project {
        let merged = Project(
            name: remote.name.isEmpty ? local.name : remote.name,
            color: remote.color,
            icon: remote.icon,
            projectDescription: remote.projectDescription.isEmpty ? local.projectDescription : remote.projectDescription,
            createdAt: local.createdAt < remote.createdAt ? local.createdAt : remote.createdAt
        )
        
        // Merge tasks (combine both)
        if let localTasks = local.tasks, let remoteTasks = remote.tasks {
            merged.tasks = Array(Set(localTasks + remoteTasks))
        } else {
            merged.tasks = local.tasks ?? remote.tasks
        }
        
        return merged
    }
}
