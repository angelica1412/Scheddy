//
//  DailyScheduleService.swift
//  Scheddy
//
//  Created by Mahardika Putra Wardhana on 09/09/25.
//

import Foundation


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

    func postSchedule(requestData: ScheduleRequest) async throws -> DailyCaddyGroupResponse {
        let url = URL(string: "\(baseURL)/schedule/create")!
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try JSONEncoder().encode(requestData)

        debugPrint("➡️ POST Body:", String(data: req.httpBody ?? Data(), encoding: .utf8) ?? "")

        let (data, response) = try await URLSession.shared.data(for: req)

        guard let httpResponse = response as? HTTPURLResponse,
              200 ..< 300 ~= httpResponse.statusCode
        else {
            throw URLError(.badServerResponse)
        }

        do {
            let decoded = try JSONDecoder().decode(DailyCaddyGroupResponse.self, from: data)
            print("✅ Response: \(decoded.message)")
            return decoded
        } catch {
            print("❌ Post schedule error: \(error)")
            throw error
        }
    }
}
