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
    func fetchCalendar() async throws -> CalendarData {
        let url = URL(string: "\(baseURL)/calendar")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(apiDateFormatter)
        
        let response = try JSONDecoder().decode(CalendarResponse.self, from: data)
        return response.data
    }
}
