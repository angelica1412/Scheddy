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

    @Published var hasSaved = false
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service = DailyScheduleService()

    func loadGeneratedSchedule() async {
        print("➡️ Fetching schedule...")
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let savedSchedule = try await service.fetchSavedSchedule()

            if savedSchedule.isEmpty {
                print("ℹ️ Tidak ada jadwal tersimpan, ambil generated...")
                let result = try await service.fetchGeneratedSchedule()

                await MainActor.run {
                    self.categories = result
                    self.mapCategoriesToGroups()
                }
            } else {
                print("✅ Ada jadwal tersimpan untuk besok, pakai saved schedule")
                hasSaved = true

                await MainActor.run {
                    self.dailyGroups = savedSchedule.map { DailyCaddyGroup(from: $0) }
                }
            }

        } catch {
            print("❌ Error fetching groups:", error.localizedDescription)
            await MainActor.run {
                self.errorMessage = error.localizedDescription
            }
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
                        shift: index < 3 ? "Pagi" : "Siang", // formasi 4:3
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
                        shift: index < 3 ? "Pagi" : "Siang",
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

    func postSchedule() async {
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let formatter = ISO8601DateFormatter()

        let items = dailyGroups.enumerated().map { index, group in
            ScheduleItemRequest(
                id_caddy_group: group.id_group,
                urutan: index + 1,
                date: formatter.string(from: tomorrow),
                shift: shiftCode(from: group.shift)
            )
        }
        print(items)

        isLoading = true
        do {
            let response: () = try await service.postSchedule(items: items)
            print("✅ Post success:")
        } catch {
            errorMessage = "Post gagal: \(error.localizedDescription)"
        }
        isLoading = false
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
