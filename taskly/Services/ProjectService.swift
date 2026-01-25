//
//  ProjectService.swift
//  taskly
//
//  Project service for CRUD operations on Project entities
//

import Foundation
import SwiftData

/// Project service implementing ProjectServiceProtocol
@MainActor
class ProjectService: ProjectServiceProtocol {
    private let dataManager: SwiftDataManager
    
    init(dataManager: SwiftDataManager = .shared) {
        self.dataManager = dataManager
    }
    
    // MARK: - Fetch Operations
    
    func fetchProjects() async throws -> [Project] {
        try dataManager.fetch(Project.self)
    }
    
    /// Fetch projects sorted by name
    func fetchProjectsSorted(by sortDescriptors: [SortDescriptor<Project>]) async throws -> [Project] {
        try dataManager.fetch(Project.self, sortDescriptors: sortDescriptors)
    }
    
    /// Fetch project by ID
    func fetchProject(id: UUID) async throws -> Project? {
        try dataManager.fetch(Project.self, id: id) as? Project
    }
    
    /// Fetch project by name
    func fetchProject(name: String) async throws -> Project? {
        let predicate = #Predicate<Project> { project in
            project.name == name
        }
        let results = try dataManager.fetch(Project.self, predicate: predicate)
        return results.first
    }
    
    // MARK: - Create Operations
    
    func createProject(_ project: Project) async throws {
        dataManager.insert(project)
        try dataManager.save()
    }
    
    /// Create a new project with parameters
    func createProject(
        name: String,
        color: String = "#007AFF",
        icon: String = "folder",
        description: String = ""
    ) async throws -> Project {
        let project = Project(
            name: name,
            color: color,
            icon: icon,
            projectDescription: description
        )
        try await createProject(project)
        return project
    }
    
    // MARK: - Update Operations
    
    func updateProject(_ project: Project) async throws {
        try dataManager.save()
    }
    
    /// Update project name
    func updateProjectName(_ project: Project, name: String) async throws {
        project.name = name
        try await updateProject(project)
    }
    
    /// Update project color
    func updateProjectColor(_ project: Project, color: String) async throws {
        project.color = color
        try await updateProject(project)
    }
    
    /// Update project icon
    func updateProjectIcon(_ project: Project, icon: String) async throws {
        project.icon = icon
        try await updateProject(project)
    }
    
    // MARK: - Delete Operations
    
    func deleteProject(_ project: Project) async throws {
        dataManager.delete(project)
        try dataManager.save()
    }
    
    /// Delete multiple projects
    func deleteProjects(_ projects: [Project]) async throws {
        dataManager.delete(projects)
        try dataManager.save()
    }
}
