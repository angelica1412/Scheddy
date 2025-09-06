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
            self.successMessage = "Checkout berhasil untuk \(data.nama_pemain)"
            self.checkOutResult = data
            print("Checkout berhasil dikirim ke backend. Response: \(data)")
        } catch {
            self.errorMessage = "Gagal checkout"
            print("Gagal kirim checkout ke backend. Error: \(error.localizedDescription)")
        }
    }
}
