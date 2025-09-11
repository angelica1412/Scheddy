//
//  CheckInView.swift
//  Scheddy
//
//  Created by Wardatul Amalia Safitri on 02/09/25.
//

import SwiftUI

struct CheckInView: View {
    @Environment(\.dismiss) var dismiss

    let caddyId: String
    let caddyName: String
    @State private var playerName = ""
    @State private var playerID = ""
    @State private var holeCount = 18
    @State private var caddyRequest = false

    @State private var wood = 0
    @State private var iron = 0
    @State private var putter = 0
    @State private var umbrella = 0
    @State private var otherItem = ""

    @StateObject private var viewModel = CheckInViewModel()

    @State private var showExitAlert = false
    @State private var showSuccessAlert = false

    var body: some View {
        VStack {
            FormHeader(title: "Check-In") {
                if hasInputChanges() { showExitAlert = true } else { dismiss() }
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    VStack(alignment: .leading, spacing: 20) {
                        // Caddy Name (read-only)
                        InfoRowSheet(label: "Nama Caddy") {
                            Text(caddyName)
                                .font(.body)
                                .foregroundColor(.black)
                        }

                        // Player Name
                        FieldRow(label: "Nama Pemain", text: $playerName, placeholder: "(Contoh: John Doe)")

                        // Player ID
                        FieldRow(label: "ID Pemain", text: $playerID, keyboard: .numberPad, placeholder: "(Contoh: 123456)")

                        // Caddy Request
                        ToggleRow(label: "Caddy Request", isOn: $caddyRequest)

                        // Bag Items (editable)
                        BagItemsEditor(wood: $wood, iron: $iron, putter: $putter, umbrella: $umbrella)

                        // Other Items
                        OtherItemsRow(text: $otherItem)
                    }
                    
                    // Check-In Button
                    HStack {
                        Spacer()
                        PrimaryButton(title: "CHECK-IN", disabled: false, loading: viewModel.isLoading) {
                            viewModel.playerName = playerName
                            viewModel.playerID = playerID
                            viewModel.caddyRequest = caddyRequest
                            viewModel.wood = wood
                            viewModel.iron = iron
                            viewModel.putter = putter
                            viewModel.umbrella = umbrella
                            viewModel.otherItem = otherItem
                            viewModel.holeCount = holeCount

                            Task {
                                await viewModel.checkInCaddy(idCaddy: caddyId)
                                if viewModel.successMessage != nil {
                                    showSuccessAlert = true
                                }
                            }
                        }
                        .frame(maxWidth: 400)
                        Spacer()
                    }
//                    .padding(.top, 20)
                    
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
                .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .alert("Data Belum Tersimpan", isPresented: $showExitAlert) {
            Button("Keluar", role: .destructive) {
                dismiss()
            }
            Button("Tetap di halaman", role: .cancel) { }
        } message: {
            Text("Anda yakin ingin kembali tanpa menyimpan data check-in caddy?")
        }
        .alert("Berhasil", isPresented: $showSuccessAlert) {
            Button("Lanjutkan") {
                dismiss()
            }
        } message: {
            Text("Data check-in berhasil tersimpan")
        }
    }
    
    private func hasInputChanges() -> Bool {
        if !playerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return true }
        if !playerID.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return true }
        if !otherItem.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return true }
        if caddyRequest { return true }
        if wood > 0 || iron > 0 || putter > 0 || umbrella > 0 { return true }
        if holeCount != 18 { return true }
        return false
    }
}
