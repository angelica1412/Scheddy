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
        VStack(spacing: 0) {
            header
            
            if let detail = viewModel.detail {
                content(for: detail)
            } else {
                Spacer()
                ProgressView("Loading...")
                Spacer()
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

    // MARK: - Subviews
    @ViewBuilder
    private var header: some View {
        ZStack {
            HStack {
                Button(action: { showExitAlert = true }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Batal")
                    }
                    .foregroundColor(.blue)
                }
                Spacer()
            }
            
            Text("Check-Out")
                .font(.headline)
                .foregroundColor(.black)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }

    @ViewBuilder
    private func content(for detail: DetailOnField) -> some View {
        VStack(spacing: 0) {
            // Content sections
            VStack(spacing: 16) {
                // Caddy Name Section
                infoRow(label: "Nama Caddy", value: detail.caddy.name)
                
                // Player Name Section
                infoRow(label: "Nama Pemain", value: detail.nama_pemain)
                
                // Player ID Section
                infoRow(label: "ID Pemain", value: detail.kode)
                
                // Hole Selection Section
                holeSelectionSection
                
                // Caddy Request Section
                infoRow(label: "Caddy Request", value: detail.booked ? "Ya" : "Tidak")
                
                // Bag Items Section
                bagItemsSection(for: detail)
                
                // Other Items Section
                infoRow(label: "Lainnya", value: detail.other_items ?? "Boneka labambu limited edition", isMultiline: true)
            }
            .padding(.horizontal, 20)
            
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
    private func infoRow(label: String, value: String, isMultiline: Bool = false) -> some View {
        HStack(alignment: isMultiline ? .top : .center, spacing: 12) {
            Text(label)
                .font(.headline)
                .foregroundColor(.black)
                .frame(width: 120, alignment: .leading)
            
            Text(value)
                .font(.body)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 8)
        .overlay(
            Divider()
                .background(Color.gray.opacity(0.15)),
            alignment: .bottom
        )
    }
    
    @ViewBuilder
    private var holeSelectionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            if selectedHole == nil {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                        .font(.subheadline)
                    Text("Pilih jumlah hole yang dimainkan")
                        .foregroundColor(.red)
                        .font(.subheadline)
                }
                .padding(.bottom, 4)
            }
            
            HStack(alignment: .top, spacing: 12) {
                Text("Jumlah Hole")
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(width: 120, alignment: .leading)
                
                holePicker
            }
        }
        .padding(.vertical, 8)
        .overlay(
            Divider()
                .background(Color.gray.opacity(0.15)),
            alignment: .bottom
        )
    }

    @ViewBuilder
    private var holePicker: some View {
        HStack(spacing: 12) {
            ForEach(holeOptions, id: \.self) { hole in
                Button {
                    selectedHole = hole
                } label: {
                    Text("\(hole)")
                        .font(.body)
                        .frame(maxWidth: 120, minHeight: 30)
                        .multilineTextAlignment(.center)
                        .background(selectedHole == hole ? Color.hijauMuda : Color.clear)
                        .foregroundColor(selectedHole == hole ? .white : .black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(selectedHole == hole ? Color.hijauMuda : Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .cornerRadius(20)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    private func bagItemsSection(for detail: DetailOnField) -> some View {
        VStack(alignment: .leading, spacing: 12) {
                Text("Bag Items")
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 8)
                    .overlay(
                        Divider()
                            .background(Color.gray.opacity(0.15)),
                        alignment: .bottom
                    )
                
                VStack(spacing: 12) {
                    HStack {
                        bagItemRow(label: "Wood", quantity: detail.wood_quantity)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        bagItemRow(label: "Putter", quantity: detail.putter_quantity)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                    .padding(.vertical, 8)
                    .overlay(
                        Divider()
                            .background(Color.gray.opacity(0.15)),
                        alignment: .bottom
                    )
                    HStack {
                        bagItemRow(label: "Iron", quantity: detail.iron_quantity)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        bagItemRow(label: "Umbrella", quantity: detail.umbrella_quantity)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.vertical, 8)
                    .overlay(
                        Divider()
                            .background(Color.gray.opacity(0.15)),
                        alignment: .bottom
                    )
                }
                .padding(.horizontal, 16)
        }

    }
    
    @ViewBuilder
    private func bagItemRow(label: String, quantity: Int) -> some View {
        HStack (spacing:16) {
            Text(label)
                .font(.body)
                .foregroundColor(.black)
                .frame(width: 70, alignment: .leading)
            
            Text("\(quantity)")
                .font(.body)
                .foregroundColor(.black)
        }
//        .frame(maxWidth: .infinity, alignment: .leading)
//        .padding(.vertical, 8)
//        .background(
//            VStack {
//                Spacer()
//                Divider()
//                    .background(Color.gray.opacity(0.15))
//            }
//        )
    }

    @ViewBuilder
    private func checkoutButton(detail: DetailOnField) -> some View {
        Button {
            guard let selectedHole = selectedHole else { return }
            Task {
                await viewModel.checkOut(id: detail.id, jumlahHole: selectedHole)
                if viewModel.successMessage != nil {
                    showSuccessAlert = true
                }
            }
        } label: {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(25)
            } else {
                Text("CHECK-OUT")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(selectedHole == nil ? Color.gray.opacity(0.5) : Color.hijauMuda)
                    .cornerRadius(25)
            }
        }
        .disabled(viewModel.isLoading || selectedHole == nil)
    }
}
