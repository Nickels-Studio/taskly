//
//  CloudKitService.swift
//  taskly
//
//  CloudKit sync service for monitoring and managing CloudKit operations
//

import Foundation
import SwiftData
import CloudKit
import Combine

/// Service for monitoring CloudKit sync status
@MainActor
class CloudKitService: ObservableObject {
    static let shared = CloudKitService()
    
    @Published var syncStatus: SyncStatus = .idle
    @Published var lastSyncDate: Date?
    @Published var errorMessage: String?
    
    private init() {}
    
    /// Check CloudKit account status
    func checkAccountStatus() async -> CKAccountStatus {
        let container = CKContainer(identifier: "iCloud.com.nickels.taskly")
        do {
            return try await container.accountStatus()
        } catch {
            print("Error checking CloudKit account status: \(error)")
            return .couldNotDetermine
        }
    }
    
    /// Get CloudKit container
    var container: CKContainer {
        CKContainer(identifier: "iCloud.com.nickels.taskly")
    }
    
    /// Verify CloudKit is available
    func verifyCloudKitAvailable() async -> Bool {
        let status = await checkAccountStatus()
        return status == .available
    }
}
