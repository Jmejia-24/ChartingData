//
//  TagModel.swift
//  ChartingData
//
//  Created by Byron on 13/7/24.
//

import Foundation
import SwiftData

@Model
final class TagModel {
    var id: UUID
    var name: String
    var icon: String = ""
    var charts: [ChartModel] = []

    init(name: String, icon: String) {
        self.id = UUID()
        self.name = name
        self.icon = icon
    }
}
