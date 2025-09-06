//
//  CaddyService.swift
//  Scheddy
//
//  Created by Maria Angelica Vinesytha Chandrawan on 03/09/25.
//

import Foundation

class CaddyService :APIService {
    // MARK: - Fetch StandBy
    func fetchStandBy() async throws -> [CaddyGroupData] {
        let url = URL(string: "\(baseURL)/rekap/standby_caddy_sorted")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(CaddyStandbyResponse.self, from: data)
        return response.data
    }
    
    // MARK: - Fetch OnField
    func fetchOnField() async throws -> [CaddyGroupGeneric] {
        let url = URL(string: "\(baseURL)/rekap/caddy_onfield")!
        let (data, _) = try await URLSession.shared.data(from: url)
        if let jsonString = String(data: data, encoding: .utf8) {
                print(jsonString)
            } else {
                print("Could not convert data to string.")
            }
        let response = try JSONDecoder().decode(CaddyGroupResponse.self, from: data)
        return response.data.map { $0.group }
    }
    
    // MARK: - Fetch Done
    func fetchDone() async throws -> [CaddyGroupGeneric] {
        let url = URL(string: "\(baseURL)/rekap/caddy_done")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(CaddyGroupResponse.self, from: data)
        return response.data.map { $0.group }
    }
}
