//
//  CheckOutViewModel.swift
//  Scheddy
//
//  Created by Maria Angelica Vinesytha Chandrawan on 04/09/25.
//

import Foundation

@MainActor
class CheckOutViewModel: ObservableObject {
    @Published var detail: DetailOnField?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var checkOutResult: CheckOutData?
    @Published var updateResult: CheckOutData?
    
    private let service = CheckOutService()
    
    // Fetch detail caddy onfield
    func fetchDetail(caddyId: String) async {
        isLoading = true
        defer { isLoading = false }
        do {
            let data = try await service.fetchDetailOnField(caddyId: caddyId)
            self.detail = data
        } catch {
            self.errorMessage = "Gagal mengambil data detail"
        }
    }
    
    // Checkout
    func checkOut(id: String, jumlahHole: Int) async {
        isLoading = true
        defer { isLoading = false }
        do {
            let data = try await service.checkOutCaddy(id: id, jumlahHole: jumlahHole)
            let caddyName = self.detail?.caddy.name ?? "Caddy"
            self.successMessage = "Checkout berhasil untuk \(caddyName)"
            self.checkOutResult = data
            print("Checkout berhasil dikirim ke backend. Response: \(data)")
        } catch {
            self.errorMessage = "Gagal checkout"
            print("Gagal kirim checkout ke backend. Error: \(error.localizedDescription)")
        }
    }
    
    // Update rekap
    func updateRekap(id: String, body: UpdateRekapRequest) async {
        isLoading = true
        defer { isLoading = false }
        do {
            let data = try await service.updateRekap(id: id, body: body)
            let caddyName = self.detail?.caddy.name ?? "Caddy"
            self.successMessage = "Update berhasil untuk \(caddyName)"
            self.updateResult = data
            print("Update berhasil. jumlah_hole=\(data.jumlah_hole)")
            if let cid = self.detail?.id_caddy {
                await self.fetchDetail(caddyId: cid)
            }
        } catch {
            self.errorMessage = error.localizedDescription.isEmpty ? "Gagal update" : error.localizedDescription
            print("[CheckOutViewModel] Gagal update: \(error.localizedDescription)")
        }
    }
}
