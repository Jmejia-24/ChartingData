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

    var sortedPlots: [PlotModel] {
        chart.plots.sorted { plot1, plot2 in
            plot1.plotOrder < plot2.plotOrder
        }
    }

    init(dataManager: DataManaging, chart: ChartModel) {
        self.dataManager = dataManager
        self.chart = chart
    }
}
