//
//  ChartListView.swift
//  ChartingData
//
//  Created by Byron on 13/7/24.
//

import SwiftUI

struct ChartListView: View {
    @Bindable private var viewModel: ChartListViewModel

    init(viewModel: ChartListViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        List {
            ForEach(viewModel.charts, id: \.id) { chart in
                NavigationLink {
                    let chartViewModel = ChartViewModel(dataManager: viewModel.dataManager, chart: chart)

                    ChartView(viewModel: chartViewModel)
                } label: {
                    Text(chart.name)
                        .font(.title3.weight(.light))
                }
                .listRowBackground(Color.accentColor.opacity(0.05))
            }
            .onDelete { indexSet in
                Task {
                    await viewModel.deleteChart(at: indexSet)
                }
            }
        }
        .animation(.smooth, value: viewModel.charts)
        .navigationTitle("Charts")
    }
}

#Preview("All charts") {
    NavigationStack {
        let preview = DataManagerMock()
        let viewModel = ChartListViewModel(dataManager: preview, tagId: nil)

        ChartListView(viewModel: viewModel)
    }
}
