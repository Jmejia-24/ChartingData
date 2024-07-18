//
//  ChartEditViewModel.swift
//  ChartingData
//
//  Created by Byron on 15/7/24.
//

import Foundation

@Observable
final class ChartEditViewModel {
    private var dataManager: DataManaging

    var chart: ChartModel
    var tags = [TagModel]()

    init(dataManager: DataManaging, chart: ChartModel) {
        self.dataManager = dataManager
        self.chart = chart

        Task {
            await fetchChart(id: chart.id)
            await fetchTags()
        }
    }

    @MainActor
    func fetchTags() async {
        do {
            tags = try await dataManager.read(
                TagModel.self,
                predicate: nil,
                sortBy: [SortDescriptor(\TagModel.name)]
            )
        } catch {
            print("Failed to fetch tags: \(error)")
        }
    }

    func isSelected(tag: TagModel) -> Bool {
        chart.tags.contains { $0.id == tag.id }
    }

    func deleteTag(_ tag: TagModel) {
        chart.tags.removeAll { $0.id == tag.id }
    }

    func addTag(_ tag: TagModel) {
        chart.tags.append(tag)
    }
}

// MARK: Private Methods

private extension ChartEditViewModel {

    @MainActor
    func fetchChart(id: UUID) async {
        do {
            let predicate = #Predicate<ChartModel> { $0.id == id }

            if let chartModel = try await dataManager.read(ChartModel.self, predicate: predicate) {
                chart = chartModel
            }
        } catch {
            print("Failed to fetch charts: \(error)")
        }
    }
}
