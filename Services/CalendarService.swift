//
//  CalendarService.swift
//  Scheddy
//
//  Created by Wardatul Amalia Safitri on 08/09/25.
//

import Foundation

class CalendarService :APIService {
    // MARK: - Fetch Calendar
    func fetchCalendar() async throws -> [CalendarData] {
        let url = URL(string: "\(baseURL)/calendar")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                decoder.keyDecodingStrategy = .convertFromSnakeCase
        let response = try JSONDecoder().decode(CalendarResponse.self, from: data)
        return response.data
    }
}
