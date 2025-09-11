//
//  CheckInViewModel.swift
//  Scheddy
//
//  Created by Maria Angelica Vinesytha Chandrawan on 03/09/25.
//

import Foundation

@MainActor
class CheckInViewModel: ObservableObject {
    @Published var playerName: String = ""
    @Published var playerID: String = ""
    @Published var caddyRequest: Bool = false
    @Published var wood: Int = 0
    @Published var iron: Int = 0
    @Published var putter: Int = 0
    @Published var umbrella: Int = 0
    @Published var otherItem: String = ""
    @Published var holeCount: Int = 18
    @Published var booked: Bool = false
    
    @Published var isLoading = false
    @Published var successMessage: String?
    @Published var errorMessage: String?
    
    private let service = CheckInService()
    
    func checkInCaddy(idCaddy: String) async {
        isLoading = true
        errorMessage = nil
        successMessage = nil
        defer { isLoading = false }
        
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime]
        let nowString = dateFormatter.string(from: Date())
        
        let requestData = CheckInRequest(
            id: UUID().uuidString,
            idCaddy: idCaddy,
            kode: playerID,
            namaPemain: playerName,
            dateTurun: nowString,
            booked: caddyRequest,
            jumlahHole: holeCount,
            status: 0,
            woodQuantity: wood,
            ironQuantity: iron,
            putterQuantity: putter,
            umbrellaQuantity: umbrella,
            otherItems: otherItem.isEmpty ? nil : otherItem,
        )
        
        do {
            let response = try await service.checkIn(requestData: requestData)
            successMessage = response.message
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
