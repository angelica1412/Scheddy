//
//  OnFieldCaddy.swift
//  Scheddy
//
//  Created by Maria Angelica Vinesytha Chandrawan on 03/09/25.
//

import Foundation

struct CaddyOnfieldResponse: Codable {
    let success: Bool
    let message: String
    let data: [CaddyOnfieldGroupWrapper]
}

struct CaddyOnfieldGroupWrapper: Codable, Identifiable {
    let group: CaddyOnfieldGroup
    
    var id: String { group.nama }
}

struct CaddyOnfieldGroup: Codable {
    let nama: String
    let caddies: [CaddyOnfieldCaddy]
}

struct CaddyOnfieldCaddy: Codable, Identifiable {
    let id: String
    let nama: String
}
