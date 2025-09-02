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
    @State private var expandedGroups: Set<String> = ["CADDY REQUEST"]
    
    var body: some View {
        NavigationStack {
            VStack {
                // Segmented Control < Bisa diganti-ganti items dan labelsnya
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
                    .padding(.vertical)
                
                // List Caddy
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(viewModel.groupedCaddies.keys.sorted(), id: \.self) { group in
                        CollapsibleGroup(title: group) {
                            VStack(spacing: 12) {
                                ForEach(viewModel.groupedCaddies[group] ?? []) { caddy in
                                    CaddyRow(caddy: caddy)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
        }
        .padding(.horizontal, 40)
        .navigationTitle(Text("Status"))
//        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading) {
//                Button {
//                    withAnimation { isSidebarVisible.toggle() }
//                } label: {
//                    Image(systemName: "sidebar.left")
//                }
//            }
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button {
//                    print("Profile tapped")
//                } label: {
//                    Image(systemName: "person.circle.fill")
//                }
//            }
//        }
//        .overlay {
//            SidebarView(isVisible: $isSidebarVisible, selection: $selectedMenu)
//        }
    }
}

#Preview {
    StatusView()
}
