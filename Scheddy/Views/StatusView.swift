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
                Picker("Status", selection: $viewModel.selectedStatus) {
                    ForEach(CaddyStatus.allCases, id: \.self) { status in
                        Text(status.rawValue).tag(status)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                // List Caddy
                List(viewModel.filteredCaddies) { caddy in
                    Text(caddy.name)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(UIColor.systemGray6))
                        )
                        .padding(.vertical, 12)
//                        .padding(.horizontal, 20)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets())
                }
                .listStyle(PlainListStyle())
            }
            .padding(.horizontal, 40)
            .navigationTitle("Status Hari Ini")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        withAnimation { isSidebarVisible.toggle() }
                    } label: {
                        Image(systemName: "sidebar.left")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        print("Profile tapped")
                    } label: {
                        Image(systemName: "person.circle.fill")
                    }
                }
            }
            .overlay {
                SidebarView(isVisible: $isSidebarVisible, selection: $selectedMenu)
            }
        }
    }
}

#Preview {
    StatusView()
}
