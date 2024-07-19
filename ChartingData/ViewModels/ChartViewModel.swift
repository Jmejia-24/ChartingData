//
//  ChartViewModel.swift
//  ChartingData
//
//  Created by Byron on 14/7/24.
//

import Foundation

@Observable
final class ChartViewModel {
    var dataManager: DataManaging
    
    let chart: ChartModel
    var refreshChart = false
    var rawSelected: String?

    var sortedPlots: [PlotModel] {
        chart.plots.sorted { plot1, plot2 in
            plot1.createdAt < plot2.createdAt
        }
    }

    var minValue: Double {
        sortedPlots.map { $0.value }.min() ?? .zero
    }

    var avgPlotsCount: Double {
        guard !sortedPlots.isEmpty else { return .zero }

        let totalPlots = sortedPlots.reduce(.zero) { $0 + $1.value }

        return totalPlots / Double(sortedPlots.count)
    }

    init(dataManager: DataManaging, chart: ChartModel) {
        self.dataManager = dataManager
        self.chart = chart
    }

    var currentSelectedPlot: PlotModel? {
        guard let rawSelected else { return nil }

        return sortedPlots.first(where: { $0.label == rawSelected })
    }
}
