//
//  DataManager.swift
//  ChartingData
//
//  Created by Byron on 14/7/24.
//

import Foundation
import SwiftData

class DataManager {

    var container: ModelContainer?

    @MainActor
    var modelContext: ModelContext? {
        container?.mainContext
    }

    init() {
        container = try? ModelContainer(for: ChartModel.self)
    }
}

// MARK: Private Methods

private extension DataManager {
    @MainActor
    func saveContext() async throws {
        guard let modelContext else { throw NSError(domain: "ModelContextError", code: 0, userInfo: nil) }

        try modelContext.save()
    }
}

// MARK: Data Managing

extension DataManager: DataManaging {

    @MainActor
    func create<T: PersistentModel>(_ object: T) async throws {
        guard let modelContext else { throw NSError(domain: "ModelContextError", code: 0, userInfo: nil) }

        modelContext.insert(object)

        try await saveContext()
    }

    @MainActor
    func read<T>(_ objectType: T.Type) async throws -> [T] where T : PersistentModel {
        guard let modelContext else { throw NSError(domain: "ModelContextError", code: 0, userInfo: nil) }

        let request = FetchDescriptor<T>()

        return try modelContext.fetch(request)
    }

    @MainActor
    func read<T: PersistentModel>(_ objectType: T.Type, predicate: Predicate<T>?, sortBy: [SortDescriptor<T>]?) async throws -> [T] {
        guard let modelContext else { throw NSError(domain: "ModelContextError", code: 0, userInfo: nil) }

        var request = FetchDescriptor<T>()
        request.predicate = predicate

        if let sortBy {
            request.sortBy = sortBy
        }

        return try modelContext.fetch(request)
    }

    @MainActor
    func read<T: PersistentModel>(_ objectType: T.Type, predicate: Predicate<T>) async throws -> T? {
        guard let modelContext else { throw NSError(domain: "ModelContextError", code: 0, userInfo: nil) }

        let request = FetchDescriptor<T>(predicate: predicate)

        return try modelContext.fetch(request).first
    }

    @MainActor
    func delete<T: PersistentModel>(_ object: T) async throws {
        guard let modelContext else { throw NSError(domain: "ModelContextError", code: 0, userInfo: nil) }

        modelContext.delete(object)

        try await saveContext()
    }
}
