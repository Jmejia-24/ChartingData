//
//  PlotModel.swift
//  ChartingData
//
//  Created by Byron on 13/7/24.
//

import Foundation
import SwiftData

@Model
final class PlotModel {
    var id: UUID
    var plotOrder: Int
    var label: String
    var value: Double
    var chart: ChartModel?

    init(plotOrder: Int, label: String = "", value: Double = 0.0, chart: ChartModel? = nil) {
        self.id = UUID()
        self.plotOrder = plotOrder
        self.label = label
        self.value = value
        self.chart = chart
    }
}
