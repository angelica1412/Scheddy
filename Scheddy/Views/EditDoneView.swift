//
//  EditDoneView.swift
//  Scheddy
//
//  Created by Maria Angelica Vinesytha Chandrawan on 09/09/25.
//

import SwiftUI

struct EditDoneView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var vm: CheckOutViewModel
    
    // state untuk form
    @State private var namaPemain: String = ""
    @State private var kode: String = ""
    @State private var jumlahHole: Int = 18
    @State private var booked: Bool = false
    @State private var woodQty: Int = 0
    @State private var ironQty: Int = 0
    @State private var putterQty: Int = 0
    @State private var umbrellaQty: Int = 0
    @State private var lainnya: String = ""
    @State private var selectedHole: Int? = nil
    @State private var showExitAlert: Bool = false
    @State private var showSuccessAlert: Bool = false
    private let holeOptions: [Int] = [9, 18, 27]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if vm.detail != nil {
                    content
                } else {
                    Spacer()
                    ProgressView("Loading...")
                    Spacer()
                }
            }
            .navigationTitle("Edit Check-Out")
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
        .onAppear {
            prefillFromDetail()
        }
        .onReceive(vm.$detail) { newDetail in
            print("[EditDoneView] onReceive detail ->", String(describing: newDetail?.id))
            prefillFromDetail()
        }
        .onChange(of: vm.detail?.id) { newId in
            print("[EditDoneView] onChange detail.id ->", String(describing: newId))
            prefillFromDetail()
        }
        .onChange(of: selectedHole) { newValue in
            if let v = newValue { jumlahHole = v }
        }
        .onChange(of: vm.detail?.jumlah_hole) { _ in
            prefillFromDetail()
        }
        .id(vm.detail?.id)
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
    
    
    // MARK: - Content wrapper
    @ViewBuilder
    private var content: some View {
        VStack(spacing: 0) {
            ScrollView{
                VStack(alignment: .leading, spacing: 16) {
                    // Nama Caddy (read-only, UPPERCASE)
                    InfoRowSheet(label: "Nama Caddy") {
                        Text(vm.detail?.caddy.name ?? "-")
                            .font(.body.weight(.medium))
                            .foregroundColor(.black)
                    }

                    // Nama Pemain (editable)
                    FieldRow(label: "Nama Pemain", text: $namaPemain, placeholder: "(Contoh: John Doe)")

                    // ID Pemain (editable)
                    FieldRow(label: "ID Pemain", text: $kode, keyboard: .numberPad, placeholder: "(Contoh: 123456)")

                    // Jumlah Hole (editable)
                    HolePicker(selection: $selectedHole, showDivider: false)

                    // Caddy Request (editable)
                    ToggleRow(label: "Caddy Request", isOn: $booked)

                    // Bag Items (editable stepper)
                    BagItemsEditor(wood: $woodQty, iron: $ironQty, putter: $putterQty, umbrella: $umbrellaQty)

                    // Lainnya (editable multiline)
                    OtherItemsRow(text: $lainnya)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                Spacer(minLength: 20)
                PrimaryButton(title: "SIMPAN PERUBAHAN", disabled: vm.isLoading, loading: vm.isLoading) {
                    Task { await save() }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
    }
    
    private func save() async {
        guard let id = vm.detail?.id else { return }
        if let sel = selectedHole { jumlahHole = sel }
        let body = UpdateRekapRequest(
            kode: kode,
            nama_pemain: namaPemain,
            jumlah_hole: jumlahHole,
            booked: booked,
            wood_quantity: woodQty,
            iron_quantity: ironQty,
            putter_quantity: putterQty,
            umbrella_quantity: umbrellaQty,
            other_items: lainnya.isEmpty ? nil : lainnya
        )
        await vm.updateRekap(id: id, body: body)
        if vm.errorMessage == nil {
            showSuccessAlert = true
        }
    }
    
    private func hasUnsavedChanges() -> Bool {
        guard let d = vm.detail else { return false }
        if namaPemain != d.nama_pemain { return true }
        if kode != d.kode { return true }
        if (selectedHole ?? jumlahHole) != d.jumlah_hole { return true }
        if booked != d.booked { return true }
        if woodQty != d.wood_quantity { return true }
        if ironQty != d.iron_quantity { return true }
        if putterQty != d.putter_quantity { return true }
        if umbrellaQty != d.umbrella_quantity { return true }
        if lainnya != (d.other_items ?? "") { return true }
        return false
    }
    private func prefillFromDetail() {
        guard let detail = vm.detail else {
            print("[EditDoneView] prefillFromDetail: detail is nil")
            return
        }
        print("[EditDoneView] prefillFromDetail: got detail for caddy:", detail.caddy.name,
              "nama_pemain:", detail.nama_pemain,
              "kode:", detail.kode,
              "jumlah_hole:", detail.jumlah_hole)
        namaPemain = detail.nama_pemain
        kode = detail.kode
        jumlahHole = detail.jumlah_hole
        booked = detail.booked
        woodQty = detail.wood_quantity
        ironQty = detail.iron_quantity
        putterQty = detail.putter_quantity
        umbrellaQty = detail.umbrella_quantity
        lainnya = detail.other_items ?? ""
        selectedHole = jumlahHole
        print("After prefill -> namaPemain=\(namaPemain), kode=\(kode), selectedHole=\(String(describing: selectedHole)))")
    }
}
