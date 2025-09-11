//
//  CheckIn.swift
//  Scheddy
//
//  Created by Maria Angelica Vinesytha Chandrawan on 03/09/25.
//
import Foundation

struct CheckInResponse: Codable {
    let message: String
    let data: CheckInRequest
}

struct CheckInRequest: Codable {
    let id: String
    let idCaddy: String
    let kode: String
    let namaPemain: String
    let dateTurun: String
    let booked: Bool
    let jumlahHole: Int
    let status: Int
    let woodQuantity: Int
    let ironQuantity: Int
    let putterQuantity: Int
    let umbrellaQuantity: Int
    let otherItems: String?

    enum CodingKeys: String, CodingKey {
        case id
        case idCaddy = "id_caddy"
        case kode
        case namaPemain = "nama_pemain"
        case dateTurun = "date_turun"
        case booked
        case jumlahHole = "jumlah_hole"
        case status
        case woodQuantity = "wood_quantity"
        case ironQuantity = "iron_quantity"
        case putterQuantity = "putter_quantity"
        case umbrellaQuantity = "umbrella_quantity"
        case otherItems = "other_items"
    }
}
