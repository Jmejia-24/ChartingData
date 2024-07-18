//
//  DataManagerMock.swift
//  ChartingData
//
//  Created by Byron on 14/7/24.
//

import Foundation
import SwiftData

final class DataManagerMock: DataManager {

    override init() {
        super.init()
        container = try? ModelContainer(
            for: ChartModel.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )

        Task {
            do {
                try await createData()
            } catch {
                print("Failed to create mock data: \(error)")
            }
        }
    }
}

// MARK: Private Methods

private extension DataManagerMock {

    @MainActor
    func createData() async throws {
        let tags = [
            TagModel(name: "Business", icon: Icon.buildingColumnsCircle.rawValue),
            TagModel(name: "Personal", icon: Icon.houseCircle.rawValue),
            TagModel(name: "Other", icon: Icon.trophyCircle.rawValue)
        ]

        for tag in tags {
            try await create(tag)
        }

        // Mock 10 charts with 10 plots
        for chartIndex in 0..<10 {
            var dataPoints: [PlotModel] = []

            for plotIndex in 0..<10 {
                let plot = PlotModel(
                    plotOrder: plotIndex,
                    label: "Label \(plotIndex)",
                    value: Double.random(in: 1...100)
                )

                dataPoints.append(plot)
            }

            let chart = ChartModel(name: "Chart \(chartIndex)", xAxisName: "X-Axis \(chartIndex)", yAxisName: "Y-Axis \(chartIndex)")
            try await create(chart)

            if let randomTag = tags.randomElement() {
                chart.tags = [randomTag]
            }

            chart.plots = dataPoints
        }

        try await saveContext()

    }

    @MainActor
    func saveContext() async throws {
        guard let modelContext else { throw NSError(domain: "ModelContextError", code: 0, userInfo: nil) }

        try modelContext.save()
    }
}
