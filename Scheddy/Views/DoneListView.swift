//
//  DoneView.swift
//  Scheddy
//
//  Created by Wardatul Amalia Safitri on 03/09/25.
//

import SwiftUI

struct DoneListView: View {
    
    let groupedCaddies: [CaddyGroupGeneric]
    let isLoading: Bool
    let errorMessage: String?
    @State private var selectedCaddyId: String? = nil
    @State private var showEdit = false
    @StateObject private var vm = CheckOutViewModel()
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(groupedCaddies) { group in
                        CollapsibleGroup(title: group.nama) {
                            VStack(spacing: 12) {
                                ForEach(group.caddies) { caddy in
                                    Button {
                                        Task {
                                            selectedCaddyId = caddy.id
                                            await vm.fetchDetail(caddyId: caddy.id)
                                            showEdit = true
                                        }
                                    } label: {
                                        CaddyRow(
                                            caddy: Caddy(
                                                id: caddy.id,
                                                name: caddy.nama,
                                                caddy_type: 0,
                                                id_user: "",
                                                id_caddy_group: "",
                                                urutan: 0
                                            )
                                        )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical, 4)
                .padding(.horizontal, 16)
            }
            // Overlay for loading or error
            if isLoading {
                VStack {
                    ProgressView("Loading...")
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                }
            } else if let error = errorMessage {
                Color.black.opacity(0.2)
                    .ignoresSafeArea()
                VStack {
                    Text(error)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(12)
                }
            }
        }
        .sheet(isPresented: $showEdit) {
            if let _ = selectedCaddyId {
                EditDoneView(vm: vm)
            }
        }
    }
}
