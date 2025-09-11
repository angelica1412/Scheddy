//
//  DetailOnField.swift
//  Scheddy
//
//  Created by Maria Angelica Vinesytha Chandrawan on 03/09/25.
//

import Foundation

// MARK: - Response untuk GET /rekap/detail_onfield/:id_caddy
struct DetailOnFieldResponse: Codable {
    let success: Bool
    let message: String
    let data: DetailOnField
}

struct DetailOnField: Codable, Identifiable {
    let id: String
    let id_caddy: String
    let kode: String
    let nama_pemain: String
    let date_turun: String
    let booked: Bool
    let jumlah_hole: Int
    let wood_quantity: Int
    let iron_quantity: Int
    let putter_quantity: Int
    let umbrella_quantity: Int
    let other_items: String?
    let caddy: CaddyInfo
}

struct CaddyInfo: Codable {
    let id: String
    let name: String
}

struct CheckOutData: Codable, Identifiable {
    let id: String
    let id_caddy: String
    let kode: String
    let nama_pemain: String
    let date_turun: String
    let booked: Bool
    let jumlah_hole: Int
    let status: Int
    let wood_quantity: Int
    let iron_quantity: Int
    let putter_quantity: Int
    let umbrella_quantity: Int
    let other_items: String?
}

// MARK: - Response untuk PUT /rekap/checkout/:id
struct CheckOutResponse: Codable {
    let message: String
    let data: CheckOutData
}

// MARK: - Request body untuk PUT /rekap/update/:id
struct UpdateRekapRequest: Codable {
    let kode: String
    let nama_pemain: String
    let jumlah_hole: Int
    let booked: Bool
    let wood_quantity: Int
    let iron_quantity: Int
    let putter_quantity: Int
    let umbrella_quantity: Int
    let other_items: String?
}

// MARK: - Response untuk PUT /rekap/update/:id
struct UpdateRekapResponse: Codable {
    let message: String
    let data: CheckOutData
}
