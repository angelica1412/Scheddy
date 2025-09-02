//
//  OnFieldRequest.swift
//  Scheddy
//
//  Created by Maria Angelica Vinesytha Chandrawan on 01/09/25.
//

import Foundation

struct OnFieldRequest: Codable {
    let idCaddy: Int
    let kode: String
    let namaPemain: String
    let booked: Bool
    let wood: Int
    let iron: Int
    let putter: Int
    let umbrella: Int
    let otherItems: [String]?
}
