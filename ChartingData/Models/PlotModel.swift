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
    var createdAt: Date
    var label: String
    var value: Double
    var chart: ChartModel?

    init(label: String = "", value: Double = 0.0, chart: ChartModel? = nil) {
        self.id = UUID()
        self.createdAt = Date()
        self.label = label
        self.value = value
        self.chart = chart
    }
}
