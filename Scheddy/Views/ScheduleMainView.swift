//
//  ScheduleMainView.swift
//  Scheddy
//
//  Created by Maria Regina Taufik on 08/09/25.

import SwiftUI

struct ScheduleMainView: View {
    enum Tab: String, CaseIterable {
        case daily = "Harian"
        case monthly = "Bulanan"
    }
    
    @State private var selectedTab: Tab = .daily
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea()
                VStack {
                    // Custom Segmented Control
                    CustomSegmentedControl(items: Tab.allCases,
                                           selection: $selectedTab,
                                           label: { $0.rawValue })
                    .padding(.horizontal,50)
                    .padding(.top, 20)
                    
                    // Konten sesuai tab
                    if selectedTab == .daily {
                        ScheduleDailyView()
                            .padding(10)
                    } else {
                        CalendarView(month: Date())
                            .padding(10)
                    }
                    
                    Spacer()
                }.padding()
            }
        }
    }
}

#Preview {
    ScheduleMainView()
}
