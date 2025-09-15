//
//  CaddyFee.swift
//  Scheddy
//
//  Created by Wardatul Amalia Safitri on 12/09/25.
//

import Foundation

struct CaddyFeeResponse: Decodable {
    let message: String
    let data: [CaddyFeeData]
}

struct CaddyFeeData: Decodable {
    let id_group: String
    let group_name: String
    let caddy_group_type: String
    let total_group_fee: Int
    let caddies: [Caddies]
}

struct Caddies: Decodable {
    let id: String
    let name: String
    let caddy_type: Int
    let total_turun: Int
    let total_fee: Int
}
