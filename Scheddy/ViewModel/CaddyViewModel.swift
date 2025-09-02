//
//  CaddyViewModel.swift
//  Scheddy
//
//  Created by Maria Angelica Vinesytha Chandrawan on 29/08/25.
//

import Foundation

@MainActor
class CaddyStatusViewModel: ObservableObject {
    @Published var caddies: [Caddy] = []
    @Published var selectedStatus: CaddyStatus = .onField
    
    init() {
        loadDummyData() // sementara pakai dummy
    }
    
    func loadDummyData() {
        caddies = [
            Caddy(id: 1, name: "Aisyah Zahra", status: .onField, group: "CADDY REQUEST"),
            Caddy(id: 2, name: "Hana Putri", status: .standBy, group: "CADDY REQUEST"),
            Caddy(id: 3, name: "Laila Salsabila", status: .onField, group: "Group 1"),
            Caddy(id: 4, name: "Maya Kartika", status: .onField, group: "Group 2"),
            Caddy(id: 5, name: "Rani Safira", status: .onField, group: "Group 1"),
            Caddy(id: 6, name: "Dinda Ayu", status: .onField, group: "Group 2"),
            Caddy(id: 7, name: "Citra Melati", status: .done, group: "Group 1")
        ]
    }
    
    // API Call → nanti tinggal ganti endpoint sesuai backend
    func fetchFromAPI() async {
        guard let url = URL(string: "https://api.yourbackend.com/caddies") else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode([Caddy].self, from: data)
            caddies = decoded
        } catch {
            print("Error fetching data: \(error)")
        }
    }
    
    var filteredCaddies: [Caddy] {
        caddies.filter { $0.status == selectedStatus }
    }
    var groupedCaddies: [String: [Caddy]] {
        Dictionary(grouping: filteredCaddies, by: { $0.group })
    } //buat nge grouping caddy nya
}
