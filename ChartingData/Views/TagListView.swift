//
//  TagListView.swift
//  ChartingData
//
//  Created by Byron on 13/7/24.
//

import Foundation
import SwiftUI

struct TagListView: View {

    @Bindable private var viewModel: TagListViewModel

    init(viewModel: TagListViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.tags) { tag in
                    Label(tag.name, systemImage: tag.icon)
                        .listRowBackground(Color.accentColor.opacity(0.05))
                }
                .onDelete { indexSet in
                    Task {
                        await viewModel.deleteTags(at: indexSet)
                    }
                }
            }
            .navigationTitle("Tags")
            .toolbar {
                Button("", systemImage: "plus") {
                    viewModel.showingSheet = true
                }
            }
            .sheet(isPresented: $viewModel.showingSheet) {
                let newTagViewModel = NewTagViewModel(dataManager: viewModel.dataManager)

                NewTagView(viewModel: newTagViewModel)
            }
            .onChange(of: viewModel.showingSheet) {
                Task {
                    await viewModel.fetchTags()
                }
            }
            .scrollContentBackground(.hidden)
            .background(.regularMaterial)
            .animation(.smooth, value: viewModel.tags)
        }
    }
}

#Preview {
    let preview = DataManagerMock()
    let viewModel = TagListViewModel(dataManager: preview)

    return TagListView(viewModel: viewModel)
}
