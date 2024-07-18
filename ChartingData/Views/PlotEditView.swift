//
//  PlotEditView.swift
//  ChartingData
//
//  Created by Byron on 13/7/24.
//

import SwiftData
import SwiftUI

struct PlotEditView: View {

    @Bindable private var viewModel: PlotEditViewModel

    init(viewModel: PlotEditViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        List {
            Section {
                ForEach(viewModel.chart.viewSortedPlots) { plot in
                    @Bindable var plot: PlotModel = plot

                    HStack {
                        TextField("label", text: $plot.label)
                        TextField("value", value: $plot.value, format: .number)
                            .keyboardType(.numberPad)
                    }
                }
                .onDelete { indexSet in
                    viewModel.deletePlots(at: indexSet)
                }
            }
            .listRowBackground(Color.accentColor.opacity(0.05))
        }
        .fontWeight(.light)
        .navigationTitle("Values for \(viewModel.chart.name)")
        .scrollContentBackground(.hidden)
        .background(.regularMaterial)
        .toolbar {
            Button("", systemImage: "plus") {
                viewModel.addPlot()
            }
        }
    }
}

struct PlotEditView_Previews: PreviewProvider {

    static var previews: some View {
        ChartPreview()
    }

    struct ChartPreview: View {
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
                        let viewModel = PlotEditViewModel(dataManager: dataManager, chart: chart)
                        PlotEditView(viewModel: viewModel)
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
