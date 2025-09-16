//
//  CaddyFeeViewModel.swift
//  Scheddy
//
//  Created by Wardatul Amalia Safitri on 12/09/25.
//

import Foundation

@Observable
class CaddyFeeViewModel {
    var caddyFees: [CaddyFeeData] = []
    var isLoading = false
    var errorMessage: String?

    private let service: CaddyFeeService

    init(service: CaddyFeeService = CaddyFeeService()) {
        self.service = service
    }

    func load(monthNumber: Int) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let caddyFeeData = try await service.fetchCaddyFee(month: monthNumber)
            self.caddyFees = caddyFeeData
        } catch {
            errorMessage = "Gagal memuat caddy fee: \(error.localizedDescription)"
        }
    }
}

//@Observable
//class CaddyFeeViewModel {
//    var isLoading = false
//    var errorMessage: String?
//    var caddyFees: [CaddyFeeData] = []
//
//    private let service: CaddyFeeService
//    
//    init(service: CaddyFeeService = CaddyFeeService()) {
//        self.service = service
//    }
//    
//    func load(monthNumber: Int) async {
//        isLoading = true
//        errorMessage = nil
//        defer { isLoading = false }
//        
//        do {
//            let response = try await service.fetchCaddyFee(month: monthNumber)
//            caddyFees = response
//        } catch {
//            errorMessage = "Gagal memuat caddy fee: \(error.localizedDescription)"
//            print(errorMessage!)
//        }
//    }
//    
//    // Dummy data for Preview
//    static let dummy: [CaddyFeeData] = [
//        CaddyFeeData(
//            id_group: "00386de9-eab2-46f2-9def-cdbaea758454",
//            group_name: "Group 1",
//            caddy_group_type: "casual",
//            total_group_fee: 387000,
//            caddies: [
//                Caddies(id: "00e401da-e8e2-401c-a563-0a445c6af697",
//                        name: "Dewi Purnama",
//                        caddy_type: 1,
//                        total_holes: 18,
//                        total_fee: 129000),
//                Caddies(id: "3cab0301-1629-42b3-9840-d1c2255501de",
//                        name: "Maya Firmansyah",
//                        caddy_type: 1,
//                        total_holes: 9,
//                        total_fee: 64500),
//                Caddies(id: "93dd032c-c5b5-4b35-9029-487e5b1476ec",
//                        name: "Wahyu Haryanto",
//                        caddy_type: 1,
//                        total_holes: 27,
//                        total_fee: 193500)
//            ]
//        )
//    ]
//}
