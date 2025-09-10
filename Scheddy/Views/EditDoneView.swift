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
        VStack(spacing: 0) {
            header
            
            if vm.detail != nil {
                content
            } else {
                Spacer()
                ProgressView("Loading...")
                Spacer()
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
    
    // MARK: - Header
    @ViewBuilder
    private var header: some View {
        ZStack {
            HStack {
                Button(action: {
                    if hasUnsavedChanges() {
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
            Text("Ubah Check-Out")
                .font(.headline)
                .foregroundColor(.black)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    // MARK: - Content wrapper
    @ViewBuilder
    private var content: some View {
        VStack(spacing: 0) {
            ScrollView{
                VStack(spacing: 16) {
                    // Nama Caddy
                    infoRow(label: "Nama Caddy", valueView:
                                Text(vm.detail?.caddy.name ?? "-")
                        .font(.body)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    )
                    
                    // Nama Pemain
                    infoRow(label: "Nama Pemain", valueView:
                                TextField("Nama Pemain", text: $namaPemain)
                        .textInputAutocapitalization(.words)
                        .disableAutocorrection(true)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 14)
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    )
                    
                    // ID Pemain
                    infoRow(label: "ID Pemain", valueView:
                                TextField("ID Pemain", text: $kode)
                        .keyboardType(.numberPad)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 14)
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    )
                    
                    // Jumlah Hole
                    holeSelectionSection
                    
                    // Caddy Request
                    infoRow(label: "Caddy Request", valueView:
                                Toggle("", isOn: $booked)
                        .labelsHidden()
                    )
                    
                    // Bag Items
                    bagItemsSectionEditable
                    
                    // Lainnya
                    infoRow(label: "Lainnya", isMultiline: true, valueView:
                                TextField("Lainnya", text: $lainnya, axis: .vertical)
                        .lineLimit(1...3)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 14)
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    )
                }
                .padding()
                Spacer(minLength: 20)
                saveButton
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
            }
        }
    }
    
    // MARK: - Reusable info row
    @ViewBuilder
    private func infoRow<Content: View>(label: String, isMultiline: Bool = false, valueView: Content) -> some View {
        HStack(alignment: isMultiline ? .top : .center, spacing: 12) {
            Text(label)
                .font(.headline)
                .foregroundColor(.black)
                .frame(width: 120, alignment: .leading)
            valueView
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    // MARK: - Hole selection
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
    }
    
    @ViewBuilder
    private var holePicker: some View {
        HStack(spacing: 12) {
            ForEach(holeOptions, id: \.self) { hole in
                Button {
                    selectedHole = hole
                    jumlahHole = hole
                } label: {
                    Text("\(hole)")
                        .font(.body)
                        .frame(maxWidth: 120, minHeight: 30)
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
    
    // MARK: - Bag items editable
    @ViewBuilder
    private var bagItemsSectionEditable: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Bag Items")
                .font(.headline)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            VStack(spacing: 12) {
                HStack {
                    qtyPair(leftTitle: "Wood", leftValue: $woodQty,
                            rightTitle: "Putter", rightValue: $putterQty)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.vertical, 8)
                HStack {
                    qtyPair(leftTitle: "Iron", leftValue: $ironQty,
                            rightTitle: "Umbrella", rightValue: $umbrellaQty)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    @ViewBuilder
    private func qtyPair(leftTitle: String, leftValue: Binding<Int>, rightTitle: String, rightValue: Binding<Int>) -> some View {
        HStack {
            qtyControl(title: leftTitle, value: leftValue)
            Spacer(minLength: 16)
            qtyControl(title: rightTitle, value: rightValue)
        }
    }
    
    private func qtyControl(title: String, value: Binding<Int>) -> some View {
        HStack(spacing: 10) {
            Text(title)
                .font(.body)
                .foregroundColor(.black)
                .frame(width: 80, alignment: .leading)
            Button(action: { value.wrappedValue = max(0, value.wrappedValue - 1) }) {
                Image(systemName: "minus")
                    .font(.body)
                    .foregroundColor(.black)
                    .frame(width: 30, height: 30)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(Rectangle())
                    .cornerRadius(8)
            }
            Text("\(max(0, value.wrappedValue))")
                .frame(minWidth: 24, alignment: .center)
            Button(action: { value.wrappedValue += 1 }) {
                Image(systemName: "plus")
                    .font(.body)
                    .foregroundColor(.black)
                    .frame(width: 30, height: 30)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(Rectangle())
                    .cornerRadius(8)
            }
        }
    }
    
    // MARK: - Save button
    @ViewBuilder
    private var saveButton: some View {
        Button {
            Task { await save() }
        } label: {
            if vm.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(25)
            } else {
                Text("SIMPAN PERUBAHAN")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.hijauMuda)
                    .cornerRadius(25)
            }
        }
        .disabled(vm.isLoading)
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
    
    private func qtyRow(title: String, value: Binding<Int>) -> some View {
        HStack {
            Text(title)
            Spacer()
            Button(action: { value.wrappedValue = max(0, value.wrappedValue - 1) }) {
                Image(systemName: "minus")
            }
            Text("\(value.wrappedValue)")
                .frame(minWidth: 24)
            Button(action: { value.wrappedValue += 1 }) {
                Image(systemName: "plus")
            }
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
