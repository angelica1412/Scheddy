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
            ZStack {
                HStack {
                    Button(action: {
                        if hasInputChanges() {
                            showExitAlert = true
                        } else {
                            dismiss()
                        }
                    }) {
                            Text("Batal")
                        .foregroundColor(.hijauMuda)
                    }
                    Spacer()
                }
                
                Text("Check-In")
                    .font(.headline)
                    .foregroundColor(.black)
            }
            .padding(.horizontal)
            .padding(.top, 8)
            .padding(.bottom, 16)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    VStack(alignment: .leading, spacing: 20) {
                        // Caddy Name Section
                        HStack {
                            Text("Nama Caddy")
                                .font(.headline)
                                .bold()
                                .foregroundColor(.black)
                                .frame(width: 120, alignment: .leading)
                            Text(caddyName)
                                .font(.headline)
                                .foregroundColor(.black)
                        }
                        
                        // Player Name Section
                        HStack {
                            Text("Nama Pemain")
                                .font(.headline)
                                .bold()
                                .frame(width: 120, alignment: .leading)
                            TextField("(Contoh: John Doe)", text: $playerName)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 14)
                                .cornerRadius(15)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                        }
                        
                        // Player ID Section
                        HStack {
                            Text("ID Pemain")
                                .font(.headline)
                                .bold()
                                .frame(width: 120, alignment: .leading)
                            TextField("(Contoh: 123456)", text: $playerID)
                                .keyboardType(.numberPad)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 14)
                                .cornerRadius(15)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                        }
                        
                        // Caddy Request Section
                        HStack {
                            Text("Caddy Request")
                                .font(.headline)
                                .bold()
                                .frame(width: 120, alignment: .leading)
                            Toggle("", isOn: $caddyRequest)
                                .labelsHidden()
                                .scaleEffect(0.8)
                            Spacer()
                        }
                        
                        // Bag Items Section
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Bag Items")
                                .font(.headline)
                                .foregroundColor(.black)
                            
                            HStack(spacing: 40) {
                                // Left Column
                                VStack(spacing: 15) {
                                    HStack {
                                        Text("Wood")
                                            .font(.body)
                                            .foregroundColor(.black)
                                            .frame(width: 80, alignment: .leading)
                                        ItemStepper(title: "", count: $wood)
                                    }
                                    
                                    HStack {
                                        Text("Iron")
                                            .font(.body)
                                            .foregroundColor(.black)
                                            .frame(width: 80, alignment: .leading)
                                        ItemStepper(title: "", count: $iron)
                                    }
                                }
                                Spacer()
                                // Right Column
                                VStack(spacing: 15) {
                                    HStack {
                                        Text("Putter")
                                            .font(.body)
                                            .foregroundColor(.black)
                                            .frame(width: 80, alignment: .leading)
                                        ItemStepper(title: "", count: $putter)
                                    }
                                    
                                    HStack {
                                        Text("Umbrella")
                                            .font(.body)
                                            .foregroundColor(.black)
                                            .frame(width: 80, alignment: .leading)
                                        ItemStepper(title: "", count: $umbrella)
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        
                        // Other Items Section
                        HStack {
                            Text("Lainnya")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                                .frame(width: 120, alignment: .leading)
                            TextField("(Contoh: Penutup Stick Golf, x1)", text: $otherItem)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 14)
                                .cornerRadius(15)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                        }
                    }
                    
                    // Check-In Button
                    HStack {
                        Spacer()
                        Button(action: {
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
                        }) {
                            if viewModel.isLoading {
                                ProgressView()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.gray.opacity(0.3))
                                    .cornerRadius(25)
                            } else {
                                Text("CHECK-IN")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(Color.hijauMuda)
                                    .cornerRadius(40)
                            }
                        }
                        .frame(maxWidth: 400)
                        Spacer()
                    }
                    .padding(.top, 20)
                    
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
