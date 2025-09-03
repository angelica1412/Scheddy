//
//  CheckInViewModel.swift
//  Scheddy
//
//  Created by Maria Angelica Vinesytha Chandrawan on 03/09/25.
//

import Foundation

class CheckInViewModel: ObservableObject {
    @Published var namaPemain: String = ""
    @Published var idPemain: String = ""
    @Published var caddyRequest: Bool = false
    @Published var wood: Int = 0
    @Published var iron: Int = 0
    @Published var putter: Int = 0
    @Published var umbrella: Int = 0
    @Published var otherItems: [String] = []
    
    @Published var isLoading = false
    @Published var successMessage: String?
    @Published var errorMessage: String?
    
    private let service = CheckInService()
    
    func checkInCaddy(idCaddy: String) {
        isLoading = true
        let requestData = CheckInRequest(
            idCaddy: idCaddy,
            namaPemain: namaPemain,
            idPemain: idPemain,
            caddyRequest: caddyRequest,
            wood: wood,
            iron: iron,
            putter: putter,
            umbrella: umbrella,
            otherItems: otherItems.isEmpty ? nil : otherItems
        )
        
        service.checkIn(requestData: requestData) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.successMessage = response.message
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
