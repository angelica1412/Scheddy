//
//  DailyScheduleService.swift
//  Scheddy
//
//  Created by Mahardika Putra Wardhana on 09/09/25.
//

import Foundation

struct DailyCaddyGroupResponse: Decodable {
    let message: String
    let data: [DynamicCategory]
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
    let groups: [RawGroup]

    struct RawGroup: Decodable {
        let group_name: String
        let notOnFieldCount: Int?
        let allCaddiesDetail: [Caddy]
        let group_order: Int?
    }
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
}
