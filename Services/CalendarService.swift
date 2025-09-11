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
    func generateLibur(bulan: String) {
        guard let url = URL(string: "\(baseURL)/schedule/generate_libur_by_month") else {
            print("Invalid URL")
            return
        }
        
        let body: [String: Any] = [
            "bulan": bulan
        ]
        
        // Convert dictionary ke JSON
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            print("Failed to encode JSON body")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
//                print("Request error: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
//                print("Status Code: \(httpResponse.statusCode)")
            }
            
            if let data = data {
                if let jsonString = String(data: data, encoding: .utf8) {
//                    print("Response JSON: \(jsonString)")
                }
            }
        }.resume()
    }
}
