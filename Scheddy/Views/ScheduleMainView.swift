//
//  ScheduleMainView.swift
//  Scheddy
//
//  Created by Rafi Abhista  on 03/09/25.
//

import SwiftUI

struct ScheduleMainView: View {
    enum Tab: String, CaseIterable {
        case daily = "Harian"
        case monthly = "Bulanan"
    }
    
    @State private var selectedTab: Tab = .daily
    
    var body: some View {
        NavigationStack {
            VStack {
                // Custom Segmented Control
                CustomSegmentedControl(items: Tab.allCases,
                                       selection: $selectedTab,
                                       label: { $0.rawValue })
                .padding(.horizontal)
                .padding(.top, 8)
                
                // Konten sesuai tab
                if selectedTab == .daily {
                    ScheduleDailyView()
                        .padding(10)
                } else {
                    CalendarView(month: Date())
                        .padding(10)
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    ScheduleMainView()
}
