//
//  CheckInService.swift
//  Scheddy
//
//  Created by Maria Angelica Vinesytha Chandrawan on 03/09/25.
//

import Foundation

class CheckInService :APIService {
    
    func checkIn(requestData: CheckInRequest) async throws -> CheckInResponse {
        let url = URL(string: "\(baseURL)/rekap/onfield")!
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try JSONEncoder().encode(requestData)
        
        let (data, _) = try await URLSession.shared.data(for: req)
        if let jsonString = String(data: data, encoding: .utf8) {
                print(jsonString)
            } else {
                print("Could not convert data to string.")
            }
        return try JSONDecoder().decode(CheckInResponse.self, from: data)
    }
}
