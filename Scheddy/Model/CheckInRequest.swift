//
//  CheckInRequest.swift
//  Scheddy
//
//  Created by Maria Angelica Vinesytha Chandrawan on 03/09/25.
//

import Foundation

struct CheckInRequest: Codable {
    let idCaddy: String
    let namaPemain: String
    let idPemain: String
    let caddyRequest: Bool
    let wood: Int
    let iron: Int
    let putter: Int
    let umbrella: Int
    let otherItems: [String]?
    
    enum CodingKeys: String, CodingKey {
        case idCaddy = "id_caddy"
        case namaPemain = "nama_pemain"
        case idPemain = "id_pemain"
        case caddyRequest = "caddy_request"
        case wood, iron, putter, umbrella
        case otherItems = "other_items"
    }
}

struct CheckInResponse: Codable {
    let success: Bool
    let message: String
}
