//
//  CalendarService.swift
//  Scheddy
//
//  Created by Wardatul Amalia Safitri on 08/09/25.
//

import Foundation

private let apiDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd" // sesuaikan format date string dari API
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
}()

class CalendarService: APIService {
    // Get Generated Libur
    func fetchCalendar(month: Int) async throws -> CalendarData {
        let url = URL(string: "\(baseURL)/calendar/\(month)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(apiDateFormatter)
        
        let response = try JSONDecoder().decode(CalendarResponse.self, from: data)
        return response.data
    }
    
    // Post Generated Libur
    func generateLibur(bulan: String) async throws -> GenerateLiburResponse {
        guard let url = URL(string: "\(baseURL)/schedule/generate_libur_by_month") else {
            throw URLError(.badURL)
        }
        
        let body: [String: Any] = [
            "bulan": bulan
        ]
        
        let jsonData = try JSONSerialization.data(withJSONObject: body)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        // async/await version of dataTask
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        // Decode JSON
        let decoded = try JSONDecoder().decode(GenerateLiburResponse.self, from: data)
        return decoded
    }
}
