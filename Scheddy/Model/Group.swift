//
//  Group.swift
//  Scheddy
//
//  Created by Maria Angelica Vinesytha Chandrawan on 01/09/25.
//

import Foundation

struct StandbyCaddyResponse: Codable {
    let message: String
    let data: [StandbyGroup]
}

struct StandbyGroup: Codable, Identifiable {
    let id: String
    let urutan: Int
    let date: String
    let shift: Int
    let idCaddyGroup: String
    let caddyGroup: CaddyGroup
    let caddies: [StandbyCaddy]
    
    enum CodingKeys: String, CodingKey {
        case id, urutan, date, shift
        case idCaddyGroup = "id_caddy_group"
        case caddyGroup = "caddy_group"
        case caddies
    }
}

struct CaddyGroup: Codable {
    let groupName: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case groupName = "group_name"
        case id
    }
}

struct StandbyCaddy: Codable, Identifiable {
    let id: String
    let name: String
    let caddyType: Int
    let idUser: String
    let idCaddyGroup: String
    let urutan: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name, urutan
        case caddyType = "caddy_type"
        case idUser = "id_user"
        case idCaddyGroup = "id_caddy_group"
    }
}
