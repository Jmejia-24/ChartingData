//
//  ChartView.swift
//  ChartingData
//
//  Created by Byron on 13/7/24.
//

import Charts
import SwiftData
import SwiftUI

struct ChartView: View {

    @Bindable private var viewModel: ChartViewModel

    init(viewModel: ChartViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        Chart {
            ForEach(viewModel.sortedPlots) { plot in
                AreaMark(
                    x: .value("Label", plot.label),
                    y: .value("Values", plot.value)
                )
                .foregroundStyle(Gradient(colors: [.accentColor.opacity(0.5), .clear]))

                LineMark(
                    x: .value("Label", plot.label),
                    y: .value("Values", plot.value)
                )
            }
            .foregroundStyle(Color.accentColor)
            .symbol(.circle)
        }
        .id(viewModel.refreshChart)
        .navigationTitle(viewModel.chart.name)
        .chartXAxisLabel(position: .bottom) {
            Text(viewModel.chart.xAxisName)
                .font(.body.weight(.bold))
        }
        .chartXAxis {
            AxisMarks { value in
                AxisValueLabel {
                    if let text = value.as(String.self) {
                        Text(text)
                            .fixedSize()
                            .rotationEffect(.degrees(-80))
                            .padding(.vertical)
                    }
                }

                AxisGridLine(centered: false)
            }
        }
        .chartYAxisLabel(position: .leading) {
            Text(viewModel.chart.yAxisName)
                .font(.body.weight(.bold))
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .padding()
        .toolbar {
            NavigationLink {
                let chartEditViewModel = ChartEditViewModel(dataManager: viewModel.dataManager, chart: viewModel.chart)

                ChartEditView(viewModel: chartEditViewModel)
            } label: {
                Image(systemName: "chart.line.uptrend.xyaxis.circle.fill")
            }

            NavigationLink {
                let plotEditViewModel = PlotEditViewModel(dataManager: viewModel.dataManager, chart: viewModel.chart)

                PlotEditView(viewModel: plotEditViewModel)
            } label: {
                Image(systemName: "list.bullet.circle.fill")
            }
        }
        .onAppear {
            viewModel.refreshChart.toggle()
        }
    }
}

struct ChartView_Previews: PreviewProvider {

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
                        let viewModel = ChartViewModel(dataManager: dataManager, chart: chart)
                        ChartView(viewModel: viewModel)
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
