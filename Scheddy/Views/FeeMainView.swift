////
////  FeeMainView.swift
////  Scheddy
////
////  Created by Maria Regina Taufik on 10/09/25.
////
//
//import SwiftUI
//
//// MARK: - Models
//
//enum EmploymentType: String, CaseIterable, Codable, Identifiable {
//    case partTime = "Part-Time"
//    case casual = "Casual"
//    var id: String { rawValue }
//
//    var tint: Color {
//        switch self {
//        case .partTime: return Color.teal
//        case .casual:   return Color.green
//        }
//    }
//}
//
//struct Member: Identifiable, Codable {
//    let id = UUID()
//    let name: String
//    let trips: Int
//    let amountIDR: Int
//}
//
//struct GroupSection: Identifiable, Codable {
//    let id = UUID()
//    let title: String
//    let type: EmploymentType
//    let members: [Member]
//    var isExpanded: Bool = true
//}
//
//// MARK: - Utilities
//
//extension Int {
//    var idrCurrency: String {
//        let f = NumberFormatter()
//        f.locale = Locale(identifier: "id_ID")
//        f.numberStyle = .currency
//        f.currencyCode = "IDR"
//        f.maximumFractionDigits = 0
//        return f.string(from: NSNumber(value: self)) ?? "Rp \(self)"
//    }
//}
//
//// MARK: - Main Screen
//
//struct FeeMainView: View {
//    @State var viewModel = CaddyFeeViewModel()
//    @State private var draggedGroup: CaddyFeeData? = nil
//
//    var groupedGroup: [String: [CaddyFeeData]] {
//        Dictionary(
//            grouping: viewModel.caddyFees,
//            by: { $0.caddy_group_type }
//        )
//    }
//
//    @State private var sections: [GroupSection] = DummyData.sections
//
//    var body: some View {
//        ZStack(alignment: .leading) {
//            Color(.systemGray6).ignoresSafeArea()
//
//            ScrollView {
//                VStack(spacing: 18) {
//                    MonthFilter()
//
//                    // Content
//                    VStack(spacing: 16) {
//                        ForEach(sections.indices, id: \.self) { i in
//                            GroupCard(section: $sections[i])
//                                .padding(.horizontal)
//                        }
//                    }
//                    .padding()
//                    .cornerRadius(10)
//
//                    Spacer()
//                }
//                .padding(.top, 8)
//            }
//        }
//        .onAppear {
//            viewModel.caddyFees = CaddyFeeViewModel.dummy // load dummy data
//        }
//    }
//}
//
//// MARK: - Dummy Data
//enum DummyData {
//    static let sections: [GroupSection] = [
//        GroupSection(
//            title: "GROUP 2",
//            type: .partTime,
//            members: [
//                Member(name: "RANI SAFIRA",      trips: 21, amountIDR: 1_620_000),
//                Member(name: "LAILA SALSABILA",  trips: 24, amountIDR: 1_620_000),
//                Member(name: "MAYA KARTIKA",     trips: 27, amountIDR: 1_822_500),
//            ],
//            isExpanded: true
//        ),
//        GroupSection(title: "GROUP 4", type: .partTime, members: [], isExpanded: false),
//        GroupSection(title: "GROUP 1", type: .partTime, members: [], isExpanded: false),
//        GroupSection(title: "GROUP 3", type: .partTime, members: [], isExpanded: false),
//        GroupSection(title: "GROUP 5", type: .partTime, members: [], isExpanded: false),
//        GroupSection(title: "GROUP 7", type: .partTime, members: [], isExpanded: false),
//        GroupSection(title: "GROUP 6", type: .casual,   members: [], isExpanded: false),
//        GroupSection(title: "GROUP 8", type: .casual,   members: [], isExpanded: false),
//    ]
//}
//
//#Preview {
//    FeeMainView()
//}

import SwiftUI

struct FeeMainView: View {
    @State private var viewModel = CaddyFeeViewModel()
    
    @State private var showMonthPicker = false
    @State private var selectedMonth: Int = Calendar.current.component(.month, from: Date())
    @State private var selectedYear: String = String(Calendar.current.component(.year, from: Date()))
    
    var groupedGroup: [String: [CaddyFeeData]] {
        Dictionary(grouping: viewModel.caddyFees, by: { $0.caddy_group_type })
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topTrailing) {
                Color.background.ignoresSafeArea()
                
                VStack(spacing: 12) {
                    // Header bulan
                    HStack {
                        Text("\(monthName(for: selectedMonth)) \(selectedYear)")
                            .font(.title2)
                            .bold()
                        Spacer()
                        Button {
                            withAnimation {
                                showMonthPicker.toggle()
                            }
                        } label: {
                            HStack {
                                Text("Bulan")
                                Image(systemName: showMonthPicker ? "chevron.up" : "chevron.down")
                            }
                            .foregroundColor(Color.hijauMuda)
                        }
                    }
                    .padding(.horizontal, 25)
                    
                    // Error state or content
                    if let errorMessage = viewModel.errorMessage {
                        Text("\(errorMessage)")
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        ScrollView {
                            VStack(spacing: 16) {
                                ForEach(Array(groupedGroup.keys.sorted()), id: \.self) { caddyGroupType in
                                    CaddyFeeGroupView(
                                        type: caddyGroupType,
                                        groups: groupedGroup[caddyGroupType] ?? []
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                }
                .padding(.top)
                
                // MonthPicker overlay directly below the button
                if showMonthPicker {
                    VStack(alignment: .trailing, spacing: 0) {
                        Spacer().frame(height: 50)
                        
                        MonthPicker(
                            selectedMonth: $selectedMonth,
                            selectedYear: $selectedYear,
                            onSelect: { month, year in
                                showMonthPicker = false
                                Task {
                                    await viewModel.load(monthNumber: month)
                                }
                            }
                        )
                        .padding(.trailing, 16)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                        .shadow(color: Color.black.opacity(0.1), radius: 3)
                        
                        Spacer()
                    }
                    .zIndex(1)
                }
                
                // Loading overlay
                if viewModel.isLoading {
                    ZStack {
                        Color.background.ignoresSafeArea()
                        ProgressView("Loading...")
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.1), radius: 3)
                    }
                    .zIndex(3)
                }
            }
            .task {
                await viewModel.load(monthNumber: selectedMonth)
            }
        }
    }
    
    private func monthName(for month: Int) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        return formatter.monthSymbols[month - 1].capitalized
    }
}

#Preview {
    FeeMainView()
}
