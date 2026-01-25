//
//  BackgroundDataService.swift
//  taskly
//
//  Background context management for SwiftData operations
//

import Foundation
import SwiftData

/// Service for managing background SwiftData operations
class BackgroundDataService {
    private let modelContainer: ModelContainer
    
    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }
    
    /// Perform operation on background context
    func performBackgroundOperation<T>(_ operation: @escaping (ModelContext) throws -> T) async throws -> T {
        let backgroundContext = ModelContext(modelContainer)
        
        return try await withCheckedThrowingContinuation { continuation in
            Task.detached {
                do {
                    let result = try operation(backgroundContext)
                    try backgroundContext.save()
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    /// Fetch on background context
    func fetchBackground<T: PersistentModel>(
        _ type: T.Type,
        predicate: Predicate<T>? = nil,
        sortDescriptors: [SortDescriptor<T>] = []
    ) async throws -> [T] {
        try await performBackgroundOperation { context in
            var descriptor = FetchDescriptor<T>(predicate: predicate, sortBy: sortDescriptors)
            return try context.fetch(descriptor)
        }
    }
    
    /// Insert on background context
    func insertBackground<T: PersistentModel>(_ item: T) async throws {
        try await performBackgroundOperation { context in
            context.insert(item)
        }
    }
    
    /// Delete on background context
    func deleteBackground<T: PersistentModel>(_ item: T) async throws {
        try await performBackgroundOperation { context in
            context.delete(item)
        }
    }
}
