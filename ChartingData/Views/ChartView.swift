//
//  ChartView.swift
//  ChartingData
//
//  Created by Byron on 13/7/24.
//

import Charts
import SwiftUI

struct ChartView: View {

    @Bindable private var viewModel: ChartViewModel

    init(viewModel: ChartViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text(viewModel.chart.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title).bold()

                if viewModel.avgPlotsCount != .zero {
                    Text("Avg: \(viewModel.avgPlotsCount.formatted(.number.precision(.fractionLength(2))))")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal)
            .opacity(viewModel.rawSelected == nil ? 1.0 : 0.0)
            .frame(alignment: .top)

            Chart {
                ForEach(viewModel.sortedPlots, id: \.id) { plot in
                    AreaMark(
                        x: .value("Area Label", plot.label),
                        yStart: .value("Area Values", plot.value),
                        yEnd: .value("Min Value", viewModel.minValue)
                    )
                    .foregroundStyle(Gradient(colors: [.accentColor.opacity(0.5), .clear]))
                    .interpolationMethod(.catmullRom)

                    LineMark(
                        x: .value("Line Label", plot.label),
                        y: .value("Line Values", plot.value)
                    )
                    .interpolationMethod(.catmullRom)
                    .symbol(.circle)
                }

                if let rawSelectedValue = viewModel.rawSelected {
                    RuleMark(x: .value("Selected Value", rawSelectedValue))
                        .foregroundStyle(Color.red)
                        .lineStyle(StrokeStyle(lineWidth: 1.5, dash: [3, 5]))
                        .offset(yStart: -10)
                        .zIndex(1)
                        .annotation(
                            position: .top, spacing: 0,
                            overflowResolution: .init(
                                x: .fit(to: .chart),
                                y: .disabled
                            )
                        ) {
                            valueSelectionPopover
                        }
                }

                if !viewModel.sortedPlots.isEmpty {
                    RuleMark(
                        y: .value("Average", viewModel.avgPlotsCount)
                    )
                    .foregroundStyle(.green)
                    .lineStyle(StrokeStyle(lineWidth: 1.5, dash: [3, 5]))
                    .annotation(position: .top, alignment: .leading) {
                        Text("avg")
                            .font(.caption2)
                            .foregroundStyle(.green)
                    }
                }
            }
            .id(viewModel.refreshChart)
            .chartYScale(domain: .automatic(includesZero: false))
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
            .chartXSelection(value: $viewModel.rawSelected.animation(.easeInOut))
            .padding(.horizontal)
        }
        .toolbarTitleDisplayMode(.inline)
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

    @ViewBuilder
    var valueSelectionPopover: some View {
        if let plot = viewModel.currentSelectedPlot {
            VStack(alignment: .leading) {
                Text(plot.label)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .fixedSize()

                HStack(alignment: .lastTextBaseline, spacing: 4) {
                    Text("\(plot.value, format: .number.precision(.fractionLength(2)))")
                        .font(.title2.bold())
                        .foregroundColor(Color.accentColor)

                        Text("records")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                }
            }
            .padding(12)
            .background {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(.secondarySystemBackground))
                    .shadow(color: .secondary.opacity(0.3), radius: 2, x: 2, y: 2)
            }
        } else {
            EmptyView()
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
