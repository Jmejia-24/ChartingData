//
//  NewTagView.swift
//  ChartingData
//
//  Created by Byron on 13/7/24.
//

import SwiftUI

struct NewTagView: View {
    @Environment(\.dismiss) private var dismiss

    @Bindable private var viewModel: NewTagViewModel

    init(viewModel: NewTagViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        Form {
            Section {
                TextField("Enter tag name", text: $viewModel.newTagName)
                    .padding()
                    .border(viewModel.noTagName ? .red : .clear)

                LazyVGrid(columns: [GridItem(), GridItem(), GridItem()], spacing: 16) {
                    ForEach(Icon.allCases, id: \.self) { icon in
                        Button {
                            viewModel.selectedIcon = icon.rawValue
                            viewModel.noIconSelected = false
                        } label: {
                            Image(systemName: icon.rawValue)
                                .symbolVariant(icon.rawValue == viewModel.selectedIcon ? .fill : .none)
                        }
                        .font(.largeTitle)
                    }
                }
                .foregroundStyle(Color.accentColor)
                .padding(1)
                .border(viewModel.noIconSelected ? .red : .clear)

                Button("Add Tag") {
                    viewModel.noTagName = viewModel.newTagName.isEmpty
                    viewModel.noIconSelected = viewModel.selectedIcon.isEmpty

                    if viewModel.noTagName || viewModel.noIconSelected {
                        return
                    }

                    Task {
                        await viewModel.addTag()
                    }

                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
                .fontWeight(.regular)
                .padding(8)
            } header: {
                Text("New Tag")
                    .padding(.top)
            }
            .fontWeight(.light)
            .listRowBackground(Color.accentColor.opacity(0.05))
        }
        .headerProminence(.increased)
        .buttonStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(.regularMaterial)
    }
}

#Preview {
    let preview = DataManagerMock()
    let viewModel = NewTagViewModel(dataManager: preview)

    return NewTagView(viewModel: viewModel)
}
