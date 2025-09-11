//
//  DailyScheduleService.swift
//  Scheddy
//
//  Created by Mahardika Putra Wardhana on 09/09/25.
//

import Foundation

struct ScheduleItemRequest: Codable {
    let id_caddy_group: String
    let urutan: Int
    let date: String
    let shift: Int
}

struct PostScheduleResponse: Codable {
    let message: String
    let count: Int
    let data: [ScheduleItemResponse]
}

struct DailyScheduleResponse: Decodable {
    let message: String
    let data: [DailyCaddyGroup]
}

struct ScheduleItemResponse: Codable {
    let id: String
    let id_caddy_group: String
    let urutan: Int
    let date: String
    let shift: Int
}

struct DynamicCategory: Decodable {
    let key: String
    let value: CategoryWrapper

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let dict = try container.decode([String: CategoryWrapper].self)
        guard let (k, v) = dict.first else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Empty category object"
            )
        }
        self.key = k
        self.value = v
    }
}

struct CategoryWrapper: Decodable {
    let groups: [DailyCaddyGroup]
}

class DailyScheduleService: APIService {
    func fetchGeneratedSchedule() async throws -> [DynamicCategory] {
        let url = URL(string: "\(baseURL)/schedule/generated_daily_schedule")!
        let (data, _) = try await URLSession.shared.data(from: url)
        do {
            let response = try JSONDecoder().decode(DailyCaddyGroupResponse.self, from: data)
            for category in response.data {
                print("➡️ Category: \(category.key)")
                for group in category.value.groups {
                    print("   Group: \(group.group_name), Caddies: \(group.allCaddiesDetail.count)")
                }
            }
            return response.data

        } catch {
            print("❌ Decoding error: \(error)")
            throw error
        }
    }

    func fetchSavedSchedule() async throws -> [SavedScheduleItem] {
        let url = URL(string: "\(baseURL)/schedule/after")!
        let (data, response) = try await URLSession.shared.data(from: url)

        if let httpResponse = response as? HTTPURLResponse {
            print("📡 Status: \(httpResponse.statusCode)")
        }

        do {
            let response = try JSONDecoder().decode(SavedScheduleResponse.self, from: data)
            return response.data
        } catch {
            print("❌ Fetch Saved Schedule Decoding error: \(error)")
            throw error
        }
    }

    func postSchedule(items: [ScheduleItemRequest]) async {
        guard let url = URL(string: "\(baseURL)/schedule/create") else { return }

        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted]
            request.httpBody = try encoder.encode(items)

            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse {
                print("📡 Status code: \(httpResponse.statusCode)")
            }

            do {
                let decoded = try JSONDecoder().decode(PostScheduleResponse.self, from: data)
                print("✅ Post sukses: \(decoded.count) jadwal disimpan")
            } catch {
                print("❌ Decode gagal: \(error)")
                print("Raw response: \(String(data: data, encoding: .utf8) ?? "nil")")
            }

        } catch {
            print("❌ Post gagal: \(error)")
        }
    }
}
