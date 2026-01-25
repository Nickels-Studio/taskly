//
//  tasklyApp.swift
//  taskly
//
//  Created by Owen on 1/25/26.
//

import SwiftUI
import SwiftData

@main
struct tasklyApp: App {
    init() {
        // Register Sora fonts on app launch
        FontHelper.registerFonts()
        
        // Initialize CloudKit service
        Task { @MainActor in
            let isAvailable = await CloudKitService.shared.verifyCloudKitAvailable()
            if isAvailable {
                print("✅ CloudKit is available and ready")
            } else {
                print("⚠️ CloudKit is not available - check iCloud account status")
            }
        }
    }
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            TaskItem.self,
            Project.self,
            Subtask.self,
            Tag.self,
        ])
        
        // Configure for CloudKit sync
        // CloudKit container identifier matches the one in entitlements: iCloud.com.nickels.taskly
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            cloudKitDatabase: .automatic // Automatically uses CloudKit when available
        )

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    // Set up SwiftData manager with context
                    if let context = sharedModelContainer.mainContext as? ModelContext {
                        SwiftDataManager.shared.setContext(context)
                    }
                    
                    // Register services in dependency container
                    DependencyContainer.shared.registerSingleton(TaskServiceProtocol.self) {
                        TaskService()
                    }
                    DependencyContainer.shared.registerSingleton(ProjectServiceProtocol.self) {
                        ProjectService()
                    }
                }
        }
        .modelContainer(sharedModelContainer)
    }
}

