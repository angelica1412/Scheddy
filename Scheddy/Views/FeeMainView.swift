//
//  FeeMainView.swift
//  Scheddy
//
//  Created by Maria Regina Taufik on 10/09/25.
//

import SwiftUI

// MARK: - Models

enum EmploymentType: String, CaseIterable, Codable, Identifiable {
    case partTime = "Part-Time"
    case casual = "Casual"
    var id: String { rawValue }

    var tint: Color {
        switch self {
        case .partTime: return Color.teal
        case .casual:   return Color.green
        }
    }
}

struct Member: Identifiable, Codable {
    let id = UUID()
    let name: String
    let trips: Int
    let amountIDR: Int
}

struct GroupSection: Identifiable, Codable {
    let id = UUID()
    let title: String
    let type: EmploymentType
    let members: [Member]
    var isExpanded: Bool = true
}

// MARK: - Utilities

extension Int {
    var idrCurrency: String {
        let f = NumberFormatter()
        f.locale = Locale(identifier: "id_ID")
        f.numberStyle = .currency
        f.currencyCode = "IDR"
        f.maximumFractionDigits = 0
        return f.string(from: NSNumber(value: self)) ?? "Rp \(self)"
    }
}

// MARK: - Main Screen

struct FeeMainView: View {
    @State private var sections: [GroupSection] = DummyData.sections

    var body: some View {
        ZStack(alignment: .leading) {
            Color(.systemGray6).ignoresSafeArea()

            ScrollView {
                VStack(spacing: 18) {
                    MonthFilter()

                    // Content
                    VStack(spacing: 16) {
                        ForEach(sections.indices, id: \.self) { i in
                            GroupCard(section: $sections[i])
                                .padding(.horizontal)
                        }
                    }
                    .padding(.bottom, 40)
                }
                .padding(.top, 8)
            }
        }
    }
}

// MARK: - Dummy Data
enum DummyData {
    static let sections: [GroupSection] = [
        GroupSection(
            title: "GROUP 2",
            type: .partTime,
            members: [
                Member(name: "RANI SAFIRA",      trips: 21, amountIDR: 1_620_000),
                Member(name: "LAILA SALSABILA",  trips: 24, amountIDR: 1_620_000),
                Member(name: "MAYA KARTIKA",     trips: 27, amountIDR: 1_822_500),
            ],
            isExpanded: true
        ),
        GroupSection(title: "GROUP 4", type: .partTime, members: [], isExpanded: false),
        GroupSection(title: "GROUP 1", type: .partTime, members: [], isExpanded: false),
        GroupSection(title: "GROUP 3", type: .partTime, members: [], isExpanded: false),
        GroupSection(title: "GROUP 5", type: .partTime, members: [], isExpanded: false),
        GroupSection(title: "GROUP 7", type: .partTime, members: [], isExpanded: false),
        GroupSection(title: "GROUP 6", type: .casual,   members: [], isExpanded: false),
        GroupSection(title: "GROUP 8", type: .casual,   members: [], isExpanded: false),
    ]
}

#Preview {
    FeeMainView()
}
