//
//  CheckOutService.swift
//  Scheddy
//
//  Created by Maria Angelica Vinesytha Chandrawan on 01/09/25.
//

import Foundation

class CheckOutService: APIService {
    func checkout(caddyId: Int, hole: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let endpoint = "/check-out/\(hole)/\(caddyId)"
        requestVoid(endpoint: endpoint, method: "PUT", completion: completion)
    }
}
