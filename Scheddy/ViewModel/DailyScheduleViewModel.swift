//
//  DailyScheduleViewModel.swift
//  Scheddy
//
//  Created by Mahardika Putra Wardhana on 09/09/25.
//

import Foundation
import SwiftUI

@MainActor
class DailyScheduleViewModel: ObservableObject {
    @Published var categories: [DynamicCategory] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service = DailyScheduleService()

    func loadGeneratedSchedule() async {
        print("➡️ Fetching schedule...")
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let result = try await service.fetchGeneratedSchedule()
            await MainActor.run {
                self.categories = result
            }

            print("✅ Selesai fetch, total categories:", categories.count)
        } catch {
            print("Error fetching groups:", error.localizedDescription)
        }
    }
}
