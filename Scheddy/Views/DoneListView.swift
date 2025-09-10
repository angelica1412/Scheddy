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
                                    HStack(spacing: 12) {
                                        // Left: caddy name
                                        Text(caddy.nama)
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundColor(.black)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.vertical, 12)

                                        // Right: EDIT pill button
                                        Button {
                                            selectedCaddyId = caddy.id
                                            showEdit = true
                                            Task {
                                                await vm.fetchDetail(caddyId: caddy.id)
                                            }
                                        } label: {
                                            HStack(spacing: 6) {
                                                Image(systemName: "square.and.pencil")
                                                    .font(.system(size: 16, weight: .semibold))
                                                Text("EDIT")
                                                    .font(.system(size: 14, weight: .bold))
                                            }
                                            .foregroundColor(.white)
                                            .padding(.vertical, 10)
                                            .padding(.horizontal, 12)
                                            .background(Color.hijauMuda)
                                            .clipShape(RoundedRectangle(cornerRadius: 14))
                                        }
                                        .buttonStyle(.plain)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 4)
                                    .background(Color.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
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
