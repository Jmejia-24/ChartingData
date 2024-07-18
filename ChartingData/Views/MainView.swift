//
//  MainView.swift
//  ChartingData
//
//  Created by Byron on 13/7/24.
//

import SwiftUI

struct MainView: View {

    @State private var chartFilterViewModel: ChartFilterViewModel
    @State private var tagListViewModel: TagListViewModel

    init(dataManager: DataManaging = DataManager()) {
        _chartFilterViewModel = State(wrappedValue: ChartFilterViewModel(dataManager: dataManager))
        _tagListViewModel = State(wrappedValue: TagListViewModel(dataManager: dataManager))
    }

    var body: some View {
        TabView {
            ChartFilterView(viewModel: chartFilterViewModel)
                .tabItem {
                    Label("Charts", systemImage: "chart.bar")
                }

            TagListView(viewModel: tagListViewModel)
                .tabItem {
                    Label("Tags", systemImage: "tag")
                }
        }
    }
}

#Preview {
    MainView(dataManager: DataManagerMock())
}
