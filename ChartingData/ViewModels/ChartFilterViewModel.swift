//
//  ChartFilterViewModel.swift
//  ChartingData
//
//  Created by Byron on 13/7/24.
//

import Combine
import SwiftUI

@Observable
final class ChartFilterViewModel {
    var dataManager: DataManaging

    var tags = [TagModel]()
    var selectedId: UUID?

    var isTagSelected: Bool {
        selectedId == nil
    }

    init(dataManager: DataManaging) {
        self.dataManager = dataManager
    }

    @MainActor
    func addChart(name: String) async {
        let chart = ChartModel(name: name)

        if let tag = tags.first(where: { $0.id == selectedId}) {
            chart.tags.append(tag)
        }

        do {
            try await dataManager.create(chart)
            
            await fetchTags()
        } catch {
            print("Failed to add chart: \(error)")
        }
    }
    
    @MainActor
    func fetchTags() async {
        do {
            tags = try await dataManager.read(TagModel.self)

            if tags.isEmpty || !tags.contains(where: { $0.id == selectedId }) {
                selectedId = nil
            }
        } catch {
            print("Failed to fetch tags: \(error)")
        }
    }
}
