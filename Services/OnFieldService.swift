//
//  OnFieldService.swift
//  Scheddy
//
//  Created by Maria Angelica Vinesytha Chandrawan on 01/09/25.
//

import Foundation

class OnfieldService: APIService {
    
    func postOnfield(data: OnFieldRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let body = try JSONEncoder().encode(data)
            requestVoid(endpoint: "/onfield", method: "POST", body: body, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }
}
