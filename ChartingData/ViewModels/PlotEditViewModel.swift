//
//  PlotEditViewModel.swift
//  ChartingData
//
//  Created by Byron on 14/7/24.
//

import Foundation

@Observable
final class PlotEditViewModel {
    private var dataManager: DataManaging
    var chart: ChartModel

    init(dataManager: DataManaging, chart: ChartModel) {
        self.dataManager = dataManager
        self.chart = chart
    }

    @MainActor
    func deletePlots(at indexSet: IndexSet) {
        indexSet.forEach { index in
            let plot = chart.viewSortedPlots[index]

            chart.plots.removeAll { $0.id == plot.id }
        }
    }

    @MainActor
    func addPlot() {
        let plot = PlotModel(plotOrder: chart.plots.count + 1)
        
        chart.plots.append(plot)
    }
}
