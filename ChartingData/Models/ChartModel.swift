//
//  ChartModel.swift
//  ChartingData
//
//  Created by Byron on 13/7/24.
//

import Foundation
import SwiftData

@Model
final class ChartModel {
    var id: UUID
    var name: String
    var xAxisName: String = ""
    var yAxisName: String = ""

    @Relationship(deleteRule: .cascade, inverse: \PlotModel.chart)
    var plots: [PlotModel] = []

    @Relationship(inverse: \TagModel.charts)
    var tags: [TagModel] = []

    init(name: String, xAxisName: String = "", yAxisName: String = "", plots: [PlotModel] = []) {
        self.id = UUID()
        self.name = name
        self.xAxisName = xAxisName
        self.yAxisName = yAxisName
        self.plots = plots
    }
}

extension ChartModel {
    var viewSortedPlots: [PlotModel] {
        plots.sorted { $0.createdAt < $1.createdAt }
    }

    var viewSortedTags: [TagModel] {
        tags.sorted { $0.name < $1.name }
    }
}
