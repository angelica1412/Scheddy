//
//  CaddyFeeService.swift
//  Scheddy
//
//  Created by Wardatul Amalia Safitri on 12/09/25.
//

import Foundation

class CaddyFeeService: APIService{
    func fetchCaddyFee(month: Int) async throws -> [CaddyFeeData] {
        let url = URL(string: "\(baseURL)/fee/get_caddy_fee/\(month)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(CaddyFeeResponse.self, from: data)
        return response.data
    }
}
