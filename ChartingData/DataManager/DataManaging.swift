//
//  DataManaging.swift
//  ChartingData
//
//  Created by Byron on 14/7/24.
//

import Foundation
import SwiftData

protocol DataManaging {
    @MainActor func create<T: PersistentModel>(_ object: T) async throws
    @MainActor func read<T: PersistentModel>(_ objectType: T.Type, predicate: Predicate<T>?, sortBy: [SortDescriptor<T>]?) async throws -> [T]
    @MainActor func read<T: PersistentModel>(_ objectType: T.Type) async throws -> [T]
    @MainActor func read<T: PersistentModel>(_ objectType: T.Type, predicate: Predicate<T>) async throws -> T?
    @MainActor func delete<T: PersistentModel>(_ object: T) async throws
}
