//
//  Caddy.swift
//  Scheddy
//
//  Created by Maria Angelica Vinesytha Chandrawan on 29/08/25.
//

import Foundation

struct Caddy: Identifiable, Codable {
    let id: Int
    let name: String
    let status: CaddyStatus
}

enum CaddyStatus: String, Codable, CaseIterable {
    case onField = "On Field"
    case standBy = "Stand By"
    case done = "Done"
}
