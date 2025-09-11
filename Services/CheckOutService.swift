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

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        request.setValue("no-cache", forHTTPHeaderField: "Pragma")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, _) = try await URLSession.shared.data(for: request)
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
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let body = ["jumlah_hole": jumlahHole]
        request.httpBody = try JSONEncoder().encode(body)

        let (data, _) = try await URLSession.shared.data(for: request)
        let decoded = try JSONDecoder().decode(CheckOutResponse.self, from: data)
        return decoded.data
    }

    // Update (PUT /rekap/update/:id)
    func updateRekap(id: String, body: UpdateRekapRequest) async throws -> CheckOutData {
        guard let url = URL(string: "\(baseURL)/rekap/update/\(id)") else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        let decoded = try JSONDecoder().decode(UpdateRekapResponse.self, from: data)
        return decoded.data
    }
}
