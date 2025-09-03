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
    @State private var selectedMenu = "Status"
    
    var body: some View {
        NavigationStack {
            VStack {
                // Segmented Control
                CustomSegmentedControl(
                    items: CaddyStatus.allCases,
                    selection: $viewModel.selectedStatus,
                    label: { status in
                        switch status {
                        case .onField: "On Field"
                        case .standBy: "Stand-By"
                        case .done: "Selesai"
                        }
                    }
                )
                .padding(.horizontal)
                
                // Konten berubah sesuai segmented control
                switch viewModel.selectedStatus {
                case .onField:
                    OnFieldListView(groupedCaddies: viewModel.groupedCaddies)
                case .standBy:
                    StandByListView(groupedCaddies: viewModel.groupedCaddies)
                case .done:
                    DoneListView(groupedCaddies: viewModel.groupedCaddies)
                }
            }
            .padding()
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    VStack(alignment: .leading) {
                        Text("Status")
                            .font(.largeTitle.bold())
                        Text(Date(), style: .date)
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top)
                }
            }
        }
        .padding(.horizontal, 40)
        .navigationTitle(Text("Status"))
    }
}

#Preview {
    StatusView()
}
