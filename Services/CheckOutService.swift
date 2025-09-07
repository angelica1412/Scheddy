//
//  CheckOutService.swift
//  Scheddy
//
//  Created by Maria Angelica Vinesytha Chandrawan on 01/09/25.
//

import Foundation

class CheckOutService :APIService {
    func fetchDetailOnField(caddyId: String) async throws -> DetailOnField {
        guard let url = URL(string: "\(baseURL)/rekap/detail_onfield/\(caddyId)") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(DetailOnFieldResponse.self, from: data)
        return decoded.data
    }
    
    // Checkout (update jumlah hole)
    func checkOutCaddy(id: String, jumlahHole: Int) async throws -> CheckOutData {
        guard let url = URL(string: "\(baseURL)/rekap/checkout/\(id)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["jumlah_hole": jumlahHole]
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoded = try JSONDecoder().decode(CheckOutResponse.self, from: data)
        return decoded.data
    }
}
