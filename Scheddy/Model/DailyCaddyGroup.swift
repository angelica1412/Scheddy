//
//  DailyCaddyGroup.swift
//  Scheddy
//
//  Created by Mahardika Putra Wardhana on 11/09/25.
//

struct DailyCaddyGroup: Codable, Equatable, Identifiable {
    var id_group: String
    var group_name: String
    var allCaddiesDetail: [DailyCaddy]
    var shift: String? = "Pagi"
    var notOnFieldCount: Int? = 0
    var group_order: Int? = 0

    var id: String { id_group }
}

struct DailyCaddy: Codable,Identifiable,Equatable,Hashable{
    let id: String
    let name: String
    let status: String?
}

struct DailyCaddyGroupResponse: Decodable {
    let message: String
    let data: [DynamicCategory]
}

struct ScheduleRequest: Codable {
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

