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
    private let holeOptions: [Int] = [9, 18, 27]

    var body: some View {
        VStack {
            header
            ScrollView {
                if let detail = viewModel.detail {
                    content(for: detail)
                        .padding()
                } else {
                    ProgressView("Loading...")
                        .padding()
                }
            }
        }
        .alert("Sukses", isPresented: $showSuccessAlert) {
            Button("OK") { dismiss() }
        } message: {
            Text(viewModel.successMessage ?? "")
        }
        .task {
            await viewModel.fetchDetail(caddyId: caddyId)
        }
    }

    // MARK: - Subviews
    @ViewBuilder
    private var header: some View {
        HStack {
            Button("Kembali") { dismiss() }
            Spacer()
        }
        .padding()
    }

    @ViewBuilder
    private func content(for detail: DetailOnField) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            // Title
            Text(detail.caddy.name)
                .font(.title)
                .bold()

            Group {
                labelled("Nama Pemain", value: detail.nama_pemain)
                labelled("ID Pemain", value: detail.kode)

                Text("Jumlah Hole")
                    .font(.headline)
                holePicker

                if selectedHole == nil {
                    Text("Silahkan pilih jumlah hole yang dimainkan")
                        .foregroundColor(.red)
                        .font(.footnote)
                }

                labelled("Caddy Request", value: detail.booked ? "Ya" : "Tidak")
            }

            Text("Bag Items")
                .font(.headline)
            bagItems(for: detail)

            Text("Others")
                .font(.headline)
            Text(detail.other_items ?? "-")

            checkoutButton(detail: detail)

            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.footnote)
            }
            if let success = viewModel.successMessage {
                Text(success)
                    .foregroundColor(.green)
                    .font(.footnote)
            }
        }
    }

    @ViewBuilder
    private var holePicker: some View {
        HStack {
            ForEach(holeOptions, id: \.self) { hole in
                Button {
                    selectedHole = hole
                } label: {
                    Text("\(hole)")
                        .padding()
                        .frame(minWidth: 60)
                        .background(selectedHole == hole ? Color.teal : Color.gray.opacity(0.2))
                        .foregroundColor(selectedHole == hole ? .white : .black)
                        .cornerRadius(8)
                }
            }
        }
    }

    @ViewBuilder
    private func bagItems(for detail: DetailOnField) -> some View {
        VStack(spacing: 10) {
            HStack { Text("Wood"); Spacer(); Text("\(detail.wood_quantity)") }
            HStack { Text("Iron"); Spacer(); Text("\(detail.iron_quantity)") }
            HStack { Text("Putter"); Spacer(); Text("\(detail.putter_quantity)") }
            HStack { Text("Umbrella"); Spacer(); Text("\(detail.umbrella_quantity)") }
        }
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
                    .frame(maxWidth: .infinity)
                    .padding()
            } else {
                Text("CHECK-OUT")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.teal)
                    .cornerRadius(12)
            }
        }
        .disabled(viewModel.isLoading || selectedHole == nil)
        .padding(.top)
    }

    @ViewBuilder
    private func labelled(_ title: String, value: String) -> some View {
        Text(title)
            .font(.headline)
        Text(value)
    }
}
