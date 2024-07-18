//
//  ChartFilterView.swift
//  ChartingData
//
//  Created by Byron on 13/7/24.
//

import SwiftUI

struct ChartFilterView: View {
    @Bindable private var viewModel: ChartFilterViewModel

    init(viewModel: ChartFilterViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0.0) {
                        Button {
                            viewModel.selectedId = nil
                        } label: {
                            Label("All", systemImage: "star.circle")
                                .symbolVariant(viewModel.isTagSelected ? .fill : .none)
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .foregroundStyle(viewModel.isTagSelected ? .white : .accentColor)
                                .background(viewModel.isTagSelected ? Color.accentColor : .white.opacity(0.8) , in: .rect(cornerRadius: 4))
                        }
                        .padding(.leading)

                        ForEach(viewModel.tags, id: \.id) { tag in
                            Button {
                                viewModel.selectedId = tag.id
                            } label: {
                                Group {
                                    if tag.icon.isEmpty {
                                        Text(tag.name)
                                    } else {
                                        Label(tag.name, systemImage: tag.icon)
                                            .symbolVariant(viewModel.selectedId == tag.id ? .fill : .none)
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .foregroundStyle(viewModel.selectedId == tag.id ? .white : .accentColor)
                                .background(viewModel.selectedId == tag.id ? Color.accentColor : .white.opacity(0.8) , in: .rect(cornerRadius: 4))
                            }
                            .padding(.leading)
                        }
                    }
                }

                let chartListViewModel = ChartListViewModel(dataManager: viewModel.dataManager, tagId: viewModel.selectedId)

                ChartListView(viewModel: chartListViewModel)
            }
            .scrollContentBackground(.hidden)
            .background(.regularMaterial)
            .toolbar {
                Button("", systemImage: "plus") {
                    Task {
                        await viewModel.addChart(name: "New Chart")
                    }
                }
            }
            .onAppear {
                Task {
                    await viewModel.fetchTags()
                }
            }
        }
    }
}

#Preview {
    let preview = DataManagerMock()
    let viewModel = ChartFilterViewModel(dataManager: preview)

    return ChartFilterView(viewModel: viewModel)
}
