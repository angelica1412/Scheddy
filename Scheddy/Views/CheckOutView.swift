//
//  CheckOutView.swift
//  Scheddy
//
//  Created by Maria Angelica Vinesytha Chandrawan on 03/09/25.
//

import SwiftUI

struct CheckOutView: View {
    @Environment(\.dismiss) var dismiss
    let caddyId: String

    @StateObject private var viewModel = CheckOutViewModel()
    @State private var selectedHole: Int? = nil
    @State private var showSuccessAlert = false
    @State private var showExitAlert = false
    private let holeOptions: [Int] = [9, 18, 27]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    if let detail = viewModel.detail {
                        content(for: detail)
                    } else {
                        VStack {
                            Spacer()
                            ProgressView("Loading...")
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .navigationTitle("Check-Out")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Batal") {
                            if hasUnsavedChanges() { showExitAlert = true } else { dismiss() }
                        }
                        .foregroundColor(.hijauMuda)
                    }
                }
            }
        }
        .alert("Sukses", isPresented: $showSuccessAlert) {
            Button("OK") { dismiss() }
        }
        message: {
            Text(viewModel.successMessage ?? "")
        }
        .alert("Data Belum Tersimpan", isPresented: $showExitAlert) {
            Button("Tetap di halaman", role: .cancel) { }
            Button("Keluar", role: .destructive) {
                dismiss()
            }
        } message: {
            Text("Anda yakin ingin kembali tanpa menyimpan data check-out caddy?")
        }
        .task {
            await viewModel.fetchDetail(caddyId: caddyId)
        }
    }

    @ViewBuilder
    private func content(for detail: DetailOnField) -> some View {
        VStack(spacing: 0) {
            // Content sections
            VStack(alignment: .center, spacing: 16) {
                // Caddy Name
                InfoRowSheet(label: "Nama Caddy", showDivider: true) {
                    Text(detail.caddy.name)
                        .font(.body)
                        .foregroundColor(.black)
                }

                // Player Name
                InfoRowSheet(label: "Nama Pemain", showDivider: true) {
                    Text(detail.nama_pemain)
                        .font(.body)
                        .foregroundColor(.black)
                }

                // Player ID
                InfoRowSheet(label: "ID Pemain", showDivider: true) {
                    Text(detail.kode)
                        .font(.body)
                        .foregroundColor(.black)
                }

                // Hole Selection
                HolePicker(selection: $selectedHole)

                // Caddy Request
                InfoRowSheet(label: "Caddy Request", showDivider: true) {
                    Text(detail.booked ? "Ya" : "Tidak")
                        .font(.body)
                        .foregroundColor(.black)
                }

                // Bag Items (read-only, with its own separators)
                BagItemsReadOnly(
                    wood: detail.wood_quantity,
                    iron: detail.iron_quantity,
                    putter: detail.putter_quantity,
                    umbrella: detail.umbrella_quantity
                )

                // Other Items
                InfoRowSheet(label: "Lainnya", isMultiline: true, showDivider: true) {
                    Text(detail.other_items ?? "-")
                        .font(.body)
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            Spacer(minLength: 20)
            
            // Bottom section
            VStack(spacing: 16) {
                Text("Cek kembali barang bawaan pemain sebelum check-out")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                checkoutButton(detail: detail)
                    .padding(.horizontal, 20)
            }
            .padding(.bottom, 30)
        }
    }
    
    @ViewBuilder
    private func checkoutButton(detail: DetailOnField) -> some View {
        PrimaryButton(
            title: "CHECK-OUT",
            disabled: selectedHole == nil,
            loading: viewModel.isLoading
        ) {
            guard let selectedHole = selectedHole else { return }
            Task {
                await viewModel.checkOut(id: detail.id, jumlahHole: selectedHole)
                if viewModel.successMessage != nil {
                    showSuccessAlert = true
                }
            }
        }
    }
    
    private func hasUnsavedChanges() -> Bool {
        // Consider a change if the user has selected a hole.
        if selectedHole != nil { return true }
        return false
    }
}
