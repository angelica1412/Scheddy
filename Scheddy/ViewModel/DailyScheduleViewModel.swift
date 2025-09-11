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
    @Published var dailyGroups: [DailyCaddyGroup] = []
    @Published var liburTomorrow: DailyCaddyGroup?
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
                self.mapCategoriesToGroups()
                print("-------dailyGroups-------")
                prettyPrint(dailyGroups)
                print("-----------------")
                print("-------liburTomorrow-------")
                prettyPrint([liburTomorrow])
                print("-----------------")
            }

            print("✅ Selesai fetch, total categories:", categories.count)
        } catch {
            print("Error fetching groups:", error.localizedDescription)
        }
    }

    private func mapCategoriesToGroups() {
        var newDailyGroups: [DailyCaddyGroup] = []
        var newLiburTomorrow: DailyCaddyGroup?

        for category in categories {
            switch category.key {
            case "Libur Today":
                // mapping RawGroup → DailyCaddyGroup
                let groups = category.value.groups.enumerated().map { index, raw in
                    DailyCaddyGroup(
                        id_group: raw.id_group, // kalau API belum ada id_group
                        group_name: raw.group_name.isEmpty ? "Libur Today \(index + 1)" : raw.group_name,
                        allCaddiesDetail: raw.allCaddiesDetail,
                        shift: index < 4 ? "Pagi" : "Siang", // formasi 4:3
                        notOnFieldCount: raw.notOnFieldCount,
                        group_order: index
                    )
                }
                newDailyGroups.append(contentsOf: groups)

            case "Generated Schedule":
                let groups = category.value.groups.enumerated().map { index, raw in
                    DailyCaddyGroup(
                        id_group: raw.id_group,
                        group_name: raw.group_name.isEmpty ? "Generated \(index + 1)" : raw.group_name,
                        allCaddiesDetail: raw.allCaddiesDetail,
                        shift: index < 4 ? "Pagi" : "Siang",
                        notOnFieldCount: raw.notOnFieldCount,
                        group_order: raw.group_order ?? index
                    )
                }
                newDailyGroups.append(contentsOf: groups)

            case "Libur Tomorrow":
                let groups = category.value.groups.enumerated().map { index, raw in
                    DailyCaddyGroup(
                        id_group: raw.id_group,
                        group_name: raw.group_name.isEmpty ? "Libur Tomorrow \(index + 1)" : raw.group_name,
                        allCaddiesDetail: raw.allCaddiesDetail,
                        shift: "Pagi", // default, atau bisa diset sesuai kebutuhan
                        notOnFieldCount: raw.notOnFieldCount,
                        group_order: raw.group_order ?? index
                    )
                }
                newLiburTomorrow = groups.first ?? DailyCaddyGroup(id_group: "", group_name: "", allCaddiesDetail: [])

            default:
                break
            }
        }
        // update state
        dailyGroups = newDailyGroups
        liburTomorrow = newLiburTomorrow
    }
}

func prettyPrint<T: Encodable>(_ value: T) {
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    if let data = try? encoder.encode(value),
       let jsonString = String(data: data, encoding: .utf8)
    {
        print(jsonString)
    }
}
