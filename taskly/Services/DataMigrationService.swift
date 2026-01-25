//
//  DataMigrationService.swift
//  taskly
//
//  Data migration service for SwiftData schema versioning
//

import Foundation
import SwiftData

/// Data migration service for handling schema changes
class DataMigrationService {
    static let shared = DataMigrationService()
    
    private init() {}
    
    /// Current schema version
    static let currentSchemaVersion: Int = 1
    
    /// Perform migration if needed
    /// SwiftData handles automatic migrations for most cases, but this provides a hook for custom logic
    func performMigrationIfNeeded(modelContainer: ModelContainer) throws {
        // SwiftData automatically handles schema migrations when:
        // 1. Models are versioned using @Model macro
        // 2. Schema changes are additive (adding new properties, not removing)
        // 3. Properties are made optional or have default values
        
        // For custom migration logic, you can check the current schema version
        // and perform necessary transformations here
        
        // Example: Check if migration is needed
        // if getStoredSchemaVersion() < currentSchemaVersion {
        //     try performCustomMigration()
        // }
        
        print("✅ Data migration check completed (SwiftData handles automatic migrations)")
    }
    
    /// Get stored schema version (if tracking manually)
    private func getStoredSchemaVersion() -> Int {
        // In a real implementation, you might store this in UserDefaults or a metadata model
        UserDefaults.standard.integer(forKey: "TasklySchemaVersion")
    }
    
    /// Store schema version
    private func storeSchemaVersion(_ version: Int) {
        UserDefaults.standard.set(version, forKey: "TasklySchemaVersion")
    }
}

/// Migration notes:
/// - SwiftData automatically migrates when you add new optional properties
/// - SwiftData automatically migrates when you add properties with default values
/// - For breaking changes, you may need to create a new model version
/// - Always test migrations with sample data before deploying
