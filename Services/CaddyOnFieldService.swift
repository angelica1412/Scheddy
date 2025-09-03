//
//  OnFieldService.swift
//  Scheddy
//
//  Created by Maria Angelica Vinesytha Chandrawan on 01/09/25.
//

import Foundation

class CaddyOnfieldService: APIService {
    func fetchOnfield(completion: @escaping (Result<[CaddyOnfieldGroupWrapper], Error>) -> Void) {
        request(endpoint: "/rekap/caddy_onfield") { (result: Result<CaddyOnfieldResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
