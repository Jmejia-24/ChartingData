//
//  ChartEditView.swift
//  ChartingData
//
//  Created by Byron on 13/7/24.
//

import SwiftData
import SwiftUI

struct ChartEditView: View {
    @Environment(\.dismiss) private var dismiss

    @Bindable var viewModel: ChartEditViewModel

    var body: some View {
        Form {
            Section("Chart Details") {
                TextField("chart name", text: $viewModel.chart.name)
                TextField("chart name", text: $viewModel.chart.yAxisName)
                TextField("chart name", text: $viewModel.chart.xAxisName)
            }
            .listRowBackground(Color.accentColor.opacity(0.05))

            Section("Tags") {
                ForEach(viewModel.tags) { tag in
                    Label {
                        Label(tag.name, systemImage: tag.icon)
                            .foregroundStyle(.primary)
                            .font(.title3.weight(.light))
                    } icon: {
                        Image(systemName: viewModel.isSelected(tag: tag) ? "checkmark.circle.fill" : "circle")
                            .fontWeight(.regular)
                    }
                    .onTapGesture {
                        if viewModel.isSelected(tag: tag) {
                            viewModel.deleteTag(tag)
                        } else {
                            viewModel.addTag(tag)
                        }
                    }
                }
            }
            .listRowBackground(Color.accentColor.opacity(0.05))
        }
        .fontWeight(.light)
        .navigationTitle("Edit Chart")
        .headerProminence(.increased)
        .scrollContentBackground(.hidden)
        .background(.regularMaterial)
        .onAppear {
            Task {
                await viewModel.fetchTags()
            }
        }
    }
}

struct ChartEditView_Previews: PreviewProvider {

    static var previews: some View {
        ChartEditPreview()
    }

    struct ChartEditPreview: View {
        private let dataManager: DataManaging = DataManagerMock()

        @State private var chart: ChartModel?
        @State private var isLoading = true

        var body: some View {
            VStack {
                if isLoading {
                    Text("Loading chart...")
                        .onAppear {
                            Task {
                                await loadChart()
                            }
                        }
                } else if let chart = chart {
                    NavigationStack {
                        let viewModel = ChartEditViewModel(dataManager: dataManager, chart: chart)
                        ChartEditView(viewModel: viewModel)
                    }
                } else {
                    Text("No chart available")
                }
            }
        }

        @MainActor
        func loadChart() async {
            do {
                let container = try await dataManager.read(ChartModel.self)
                if let model = container.first {
                    chart = model

                    isLoading.toggle()
                }
            } catch {
                print("Failed to fetch chart: \(error)")
            }
        }
    }
}
