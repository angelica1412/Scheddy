//
//  CalendarViewModel.swift
//  Scheddy
//
//  Created by Wardatul Amalia Safitri on 08/09/25.
//

// ViewModels/CalendarMonthViewModel.swift

import Foundation

@MainActor
class CalendarMonthViewModel: ObservableObject {
    @Published var days: [CalendarDay] = []
//    @Published var isLoading = false
//    @Published var errorMessage: String?
//    
//    private let service: CalendarService
//    
//    init(service: CalendarService = CalendarService()) {
//        self.service = service
//    }
//    
//    func load(month: Date) async {
//        isLoading = true
//        errorMessage = nil
//        defer { isLoading = false }
//        
//        do {
//            let calendarList = try await service.fetchCalendar()
//            if let calendarData = calendarList.first {
//                mapCalendarData(calendarData, for: month)
//            }
//        } catch {
//            errorMessage = "Gagal memuat kalender: \(error.localizedDescription)"
//        }
//    }
//    
//    private func mapCalendarData(_ data: CalendarData, for month: Date) {
//        let calendar = Calendar.current
//        guard let startOfMonth = calendar.date(
//            from: calendar.dateComponents([.year, .month], from: month)
//        ) else { return }
//        
//        guard let range = calendar.range(of: .day, in: .month, for: startOfMonth) else { return }
//        
//        var tempDays: [CalendarDay] = []
//        
//        for day in range {
//            var comps = calendar.dateComponents([.year, .month], from: startOfMonth)
//            comps.day = day
//            if let date = calendar.date(from: comps) {
//                var entries: [CalendarEntry] = []
//                
//                // Tambahkan data libur dari API
//                if let libur = data.libur.first(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
//                    entries.append(.libur)
//                    entries.append(.group(name: libur.caddyGroup))
//                }
//                
//                // Tambahkan data booking kalau perlu
//                // if let booking = data.booking.first(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
//                //     entries.append(.player(name: booking.namaPemain))
//                // }
//                
//                tempDays.append(CalendarDay(date: date, isCurrentMonth: true, entries: entries))
//            }
//        }
//        
//        self.days = tempDays
//    }

    func load(month: Date) {
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: month))!
        let range = calendar.range(of: .day, in: .month, for: startOfMonth)!
        
        // Build all days of the month
        var tempDays: [CalendarDay] = []
        for day in range {
            var comps = calendar.dateComponents([.year, .month], from: startOfMonth)
            comps.day = day
            if let date = calendar.date(from: comps) {
                tempDays.append(CalendarDay(date: date, isCurrentMonth: true))
            }
        }
        
        // Pad before to start Sunday
        if let firstDay = tempDays.first?.date {
            let weekday = calendar.component(.weekday, from: firstDay) // 1=Sunday
            let padding = weekday - 1
            for i in 0..<padding {
                if let d = calendar.date(byAdding: .day, value: -(padding - i), to: firstDay) {
                    tempDays.insert(CalendarDay(date: d, isCurrentMonth: false), at: 0)
                }
            }
        }
        
        // Inject some mock data
        self.days = tempDays.map { day in
            var entries: [CalendarEntry] = []
            
            let weekday = calendar.component(.weekday, from: day.date)
            if weekday == 2 { // Monday
                entries.append(.libur)
            }
            
            let dayNum = calendar.component(.day, from: day.date)
            
            if [7,14,21,28].contains(dayNum) {
                entries.append(.group(name: "Group 3"))
            }
            if [2,9,16,23,30].contains(dayNum) {
                entries.append(.group(name: "Group 1"))
            }
            //            if [3,10,17,24,31].contains(dayNum) {
            //                entries.append(.player(name: "Mirna"))
            //                entries.append(.player(name: "Zahra"))
            //            }
            
            return CalendarDay(date: day.date,
                               isCurrentMonth: day.isCurrentMonth,
                               entries: entries)
        }
    }
}
