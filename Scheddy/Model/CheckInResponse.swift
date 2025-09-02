//
//  CheckInResponse.swift
//  Scheddy
//
//  Created by Maria Angelica Vinesytha Chandrawan on 01/09/25.
//

import Foundation

struct CheckInResponse: Codable {
    let id: Int
    let caddy: Caddy
    let status: String
    let hole: Int?
}
