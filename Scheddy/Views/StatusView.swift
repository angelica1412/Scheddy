//
//  StatusView.swift
//  Scheddy
//
//  Created by Maria Angelica Vinesytha Chandrawan on 29/08/25.
//

import SwiftUI

struct StatusView: View {
    @StateObject private var viewModel = CaddyStatusViewModel()
    @State private var isSidebarVisible = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea()
                VStack {
                    // Segmented Control
                    CustomSegmentedControl(
                        items: CaddyStatus.allCases,
                        selection: $viewModel.selectedStatus,
                        label: { status in
                            switch status {
                            case .onField: "Turun"
                            case .standBy: "Stand-By"
                            case .done: "Selesai"
                            }
                        }
                    )
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    // Konten sesuai status
                    switch viewModel.selectedStatus {
                    case .onField:
                        OnFieldListView(
                            groupedCaddies: viewModel.groupedCaddiesOnField,
                            isLoading: viewModel.isLoading,
                            errorMessage: nil
                        )
                    case .standBy:
                        StandByListView(
                            groupedCaddies: viewModel.groupedCaddiesStandBy,
                            isLoading: viewModel.isLoading,
                            errorMessage: nil
                        )
                    case .done:
                        DoneListView(
                            groupedCaddies: viewModel.groupedCaddiesDone,
                            isLoading: viewModel.isLoading,
                            errorMessage: nil
                        )
                    }
                }
                .task {
                    await viewModel.loadCaddies()
                }
                .onChange(of: viewModel.selectedStatus) { _ in
                    Task { @MainActor in
                        await viewModel.loadCaddies()
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    StatusView()
}
