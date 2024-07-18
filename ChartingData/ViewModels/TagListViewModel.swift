//
//  TagListViewModel.swift
//  ChartingData
//
//  Created by Byron on 14/7/24.
//

import Foundation

@Observable
final class TagListViewModel {
    var dataManager: DataManaging

    var tags = [TagModel]()
    var showingSheet = false

    init(dataManager: DataManaging) {
        self.dataManager = dataManager

        Task {
            await fetchTags()
        }
    }

    @MainActor
    func fetchTags() async {
        do {
            tags = try await dataManager.read(TagModel.self)
        } catch {
            print("Failed to fetch tags: \(error)")
        }
    }

    @MainActor
    func deleteTags(at indexSet: IndexSet) async {
        do {
            for index in indexSet {
                let chart = tags[index]

                try await dataManager.delete(chart)
            }

            await fetchTags()
        } catch {
            print("Failed to delete tag: \(error)")
        }
    }
}
