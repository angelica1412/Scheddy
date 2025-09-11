//
//  Caddy.swift
//  Scheddy
//
//  Created by Maria Angelica Vinesytha Chandrawan on 02/09/25.
//

import Foundation

// MARK: - StandBy Models
struct CaddyStandbyResponse: Codable {
    let message: String
    let data: [CaddyGroupData]
}

struct CaddyGroupData: Codable, Identifiable {
    let id: String
    let urutan: Int
    let date: String
    let shift: Int
    let id_caddy_group: String
    let caddy_group: CaddyGroup
    let caddies: [Caddy]
}

struct CaddyGroup: Codable {
    let group_name: String
    let id: String
}

struct Caddy: Codable, Identifiable, Equatable, Hashable {
    let id: String
    let name: String
    let caddy_type: Int
    let id_user: String
    let id_caddy_group: String
    let urutan: Int
}

// MARK: - OnField & Done (Generic Models)
struct CaddyGroupResponse: Codable {
    let success: Bool
    let message: String
    let data: [CaddyGroupWrapper]
}

struct CaddyGroupWrapper: Codable {
    let group: CaddyGroupGeneric
}

struct CaddyGroupGeneric: Codable, Identifiable {
    var id: String { nama } 
    let nama: String
    let caddies: [CaddySimple]
}

struct CaddySimple: Codable, Identifiable {
    let id: String
    let nama: String
}
