//
//  CaddyService.swift
//  Scheddy
//
//  Created by Maria Angelica Vinesytha Chandrawan on 01/09/25.
//

import Foundation

class CaddyService: APIService {
    func fetchStandby(completion: @escaping (Result<[StandbyGroup], Error>) -> Void) {
        request(endpoint: "/rekap/standby_caddy_sorted") { (result: Result<StandbyCaddyResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func fetchOnfield(completion: @escaping (Result<[Caddy], Error>) -> Void) {
        request(endpoint: "/rekap/caddy_onfield", completion: completion)
    }
    func fetchDone(completion: @escaping (Result<[Caddy], Error>) -> Void) {
        request(endpoint: "/rekap/caddy_done", completion: completion)
    }
}
