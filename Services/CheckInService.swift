//
//  CheckInService.swift
//  Scheddy
//
//  Created by Maria Angelica Vinesytha Chandrawan on 01/09/25.
//

import Foundation

class CheckinService: APIService {
    
    func fetchCheckin(idCaddy: Int, completion: @escaping (Result<CheckInResponse, Error>) -> Void) {
        request(endpoint: "/checkin/\(idCaddy)", completion: completion)
    }
    
    func updateDone(checkinId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let endpoint = "/update-done/\(checkinId)"
        requestVoid(endpoint: endpoint, method: "PUT", completion: completion)
    }
}
