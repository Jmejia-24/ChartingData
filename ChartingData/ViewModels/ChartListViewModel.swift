//
//  ChartListViewModel.swift
//  ChartingData
//
//  Created by Byron on 13/7/24.
//

import SwiftUI

@Observable
final class ChartListViewModel {
    var dataManager: DataManaging

    private var tagId: UUID?

    var charts = [ChartModel]()

    init(dataManager: DataManaging, tagId: UUID?) {
        self.dataManager = dataManager
        self.tagId = tagId

        Task {
            await fetchCharts()
        }
    }

    @MainActor
    func fetchCharts() async {
        do {
            if let tagId {
                let sort = [SortDescriptor(\ChartModel.name)]

                let predicate = #Predicate<ChartModel> { chart in
                    chart.tags.contains { $0.id == tagId }
                }

                charts = try await dataManager.read(
                    ChartModel.self,
                    predicate: predicate,
                    sortBy: sort
                )
            } else {
                charts = try await dataManager.read(ChartModel.self)
            }
        } catch {
            print("Failed to fetch charts: \(error)")
        }
    }

    @MainActor
    func deleteChart(at indexSet: IndexSet) async {
        do {
            for index in indexSet {
                let chart = charts[index]
                
                try await dataManager.delete(chart)
            }

            await fetchCharts()
        } catch {
            print("Failed to delete chart: \(error)")
        }
    }
}
