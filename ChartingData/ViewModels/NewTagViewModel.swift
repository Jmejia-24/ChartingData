//
//  NewTagViewModel.swift
//  ChartingData
//
//  Created by Byron on 14/7/24.
//

import Foundation

@Observable
final class NewTagViewModel {
    private var dataManager: DataManaging

    var newTagName = ""
    var selectedIcon = ""
    var noTagName = false
    var noIconSelected = false

    init(dataManager: DataManaging) {
        self.dataManager = dataManager
    }

    @MainActor
    func addTag() async {
        do {
            let newTag = TagModel(name: newTagName, icon: selectedIcon)

            try await dataManager.create(newTag)
        } catch {
            print("Failed to add tag: \(error)")
        }
    }
}
