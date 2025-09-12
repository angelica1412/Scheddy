//
//  Calendar.swift
//  Scheddy
//
//  Created by Wardatul Amalia Safitri on 08/09/25.
//

import Foundation

// Represents a single entry inside a calendar day
enum CalendarEntry: Identifiable {
    case libur
    case group(name: String)
    
    var id: String {
        switch self {
        case .libur: return "libur"
        case .group(let g): return "group-\(g)"
        }
    }
}

// A calendar day cell
struct CalendarDay: Identifiable {
    let id = UUID()
    let date: Date
    let isCurrentMonth: Bool
    var entries: [CalendarEntry] = []
}

// Model for Handling Response from API
struct CalendarResponse: Decodable {
    let message: String
    let data: CalendarData
}

struct CalendarData: Decodable {
    let libur: [Libur]
    let booking: [Booking]
}

struct Libur: Decodable {
    let id: String
    let date: String
    let is_request: Bool
    let id_caddy_group: String
    let group_name: String
}

struct Booking: Decodable {
    let id: String
    let id_caddy: String
    let nama_pemain: String
    let date: String
    let caddy_name: String
}

//Handling GeneratedLibur Response
struct GenerateLiburResponse: Codable {
    let message: String?
    let data: [String]?
}
