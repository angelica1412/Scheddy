//
//  CaddyService.swift
//  Scheddy
//
//  Created by Maria Angelica Vinesytha Chandrawan on 01/09/25.
//

import Foundation

class CaddyService: APIService {
    
    func fetchOnfield(completion: @escaping (Result<[Caddy], Error>) -> Void) {
        request(endpoint: "/caddy/onfield", completion: completion)
    }
    
    func fetchDone(completion: @escaping (Result<[Caddy], Error>) -> Void) {
        request(endpoint: "/caddy/done", completion: completion)
    }
    
    func fetchStandby(completion: @escaping (Result<[Group], Error>) -> Void) {
        request(endpoint: "/caddy/standby", completion: completion)
    }
}
