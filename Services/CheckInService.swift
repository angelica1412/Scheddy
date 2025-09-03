//
//  CheckInService.swift
//  Scheddy
//
//  Created by Maria Angelica Vinesytha Chandrawan on 03/09/25.
//

import Foundation

class CheckInService: APIService{
    func checkIn(requestData: CheckInRequest, completion: @escaping (Result<CheckInResponse, Error>) -> Void) {
        do {
            let body = try JSONEncoder().encode(requestData)
            request(endpoint: "/rekap/onfield", method: "POST", body: body, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }
}
