//
//  CaddyStatusViewModel.swift
//  Scheddy
//
//  Created by Maria Angelica Vinesytha Chandrawan on 29/08/25.
//

import Foundation

enum CaddyStatus: CaseIterable {
    case standBy, onField, done
}

@MainActor
class CaddyStatusViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var groupedCaddiesStandBy: [CaddyGroupData] = []
    @Published var groupedCaddiesOnField: [CaddyGroupGeneric] = []
    @Published var groupedCaddiesDone: [CaddyGroupGeneric] = []
    
    @Published var selectedStatus: CaddyStatus = .standBy
    
    private let service = CaddyService()
    
    // MARK: - Load Caddies sesuai status
    func loadCaddies() async {
        isLoading = true
        defer { isLoading = false }
        do {
            switch selectedStatus {
            case .standBy:
                groupedCaddiesStandBy = try await service.fetchStandBy().filter { !$0.caddies.isEmpty }
            case .onField:
                groupedCaddiesOnField = try await service.fetchOnField().filter { !$0.caddies.isEmpty }
            case .done:
                groupedCaddiesDone = try await service.fetchDone().filter { !$0.caddies.isEmpty }
            }
        } catch {
            print("Error fetching caddies:", error.localizedDescription)
        }
    }
}
