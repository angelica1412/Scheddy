//
//  CaddyViewModel.swift
//  Scheddy
//
//  Created by Maria Angelica Vinesytha Chandrawan on 29/08/25.
//

import Foundation

enum CaddyStatus: CaseIterable {
    case onField, standBy, done
}

class CaddyStatusViewModel: ObservableObject {
    @Published var groupedCaddies: [String: [Caddy]] = [:]
    @Published var selectedStatus: CaddyStatus = .standBy
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service = CaddyService()
    
    init() {
        loadCaddies()
    }
    
    func loadCaddies() {
        isLoading = true
        groupedCaddies.removeAll()
        
        switch selectedStatus {
        case .standBy:
            service.fetchStandby { result in
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch result {
                    case .success(let groups):
                        // convert ke format [GroupName: [Caddy]]
                        var dict: [String: [Caddy]] = [:]
                        for group in groups {
                            dict[group.caddyGroup.groupName] = group.caddies.map {
                                Caddy(id: $0.id, name: $0.name, status: "standby")
                            }
                        }
                        self.groupedCaddies = dict
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                    }
                }
            }
        case .onField:
            service.fetchOnfield { result in
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch result {
                    case .success(let caddies):
                        self.groupedCaddies = ["On Field": caddies]
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                    }
                }
            }
        case .done:
            service.fetchDone { result in
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch result {
                    case .success(let caddies):
                        self.groupedCaddies = ["Done": caddies]
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }
}
