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
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service: CalendarService
    
    init(service: CalendarService = CalendarService()) {
        self.service = service
    }
    
    func load(month: Date) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            let calendarData = try await service.fetchCalendar()
            print(calendarData.libur)   // contoh akses libur
            //            print(calendarData.booking) // contoh akses booking
            mapCalendarData(calendarData, for: month)
        } catch {
            errorMessage = "Gagal memuat kalender: \(error.localizedDescription)"
            print(errorMessage!)
        }
    }
    
    private let apiDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // karena ada 'Z' (Zulu / UTC)
        return formatter
    }()
    
    private func mapCalendarData(_ data: CalendarData, for month: Date) {
        let calendar = Calendar.current
        guard let startOfMonth = calendar.date(
            from: calendar.dateComponents([.year, .month], from: month)
        ) else { return }
        
        guard let range = calendar.range(of: .day, in: .month, for: startOfMonth) else { return }
        
        var tempDays: [CalendarDay] = []
        
        for day in range {
            var comps = calendar.dateComponents([.year, .month], from: startOfMonth)
            comps.day = day
            if let date = calendar.date(from: comps) {
                var entries: [CalendarEntry] = []
                
                // Tambahkan data libur dari API
                if let libur = data.libur.first(where: {
                    if let liburDate = apiDateFormatter.date(from: $0.date) {
                        return calendar.isDate(liburDate, inSameDayAs: date)
                    }
                    return false
                }) {
                    entries.append(.group(name: libur.group_name))
                }
                
                tempDays.append(CalendarDay(date: date, isCurrentMonth: true, entries: entries))
            }
        }
        
        //Pad before to start Sunday
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
            var entries = day.entries
            
            let weekday = calendar.component(.weekday, from: day.date)
            if weekday == 2 { // Monday
                entries.append(.libur)
            }
            
            return CalendarDay(date: day.date,
                               isCurrentMonth: day.isCurrentMonth,
                               entries: entries)
        }
    }
    
    //          Dummy Data
    //        func load(month: Date) {
    //            let calendar = Calendar.current
    //            let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: month))!
    //            let range = calendar.range(of: .day, in: .month, for: startOfMonth)!
    //
    //            // Build all days of the month
    //            var tempDays: [CalendarDay] = []
    //            for day in range {
    //                var comps = calendar.dateComponents([.year, .month], from: startOfMonth)
    //                comps.day = day
    //                if let date = calendar.date(from: comps) {
    //                    tempDays.append(CalendarDay(date: date, isCurrentMonth: true))
    //                }
    //            }
    //
    //            // Pad before to start Sunday
    //            if let firstDay = tempDays.first?.date {
    //                let weekday = calendar.component(.weekday, from: firstDay) // 1=Sunday
    //                let padding = weekday - 1
    //                for i in 0..<padding {
    //                    if let d = calendar.date(byAdding: .day, value: -(padding - i), to: firstDay) {
    //                        tempDays.insert(CalendarDay(date: d, isCurrentMonth: false), at: 0)
    //                    }
    //                }
    //            }
    //
    //            // Inject some mock data
    //            self.days = tempDays.map { day in
    //                var entries: [CalendarEntry] = []
    //
    //                let weekday = calendar.component(.weekday, from: day.date)
    //                if weekday == 2 { // Monday
    //                    entries.append(.libur)
    //                }
    //
    //                let dayNum = calendar.component(.day, from: day.date)
    //
    //                if [7,14,21,28].contains(dayNum) {
    //                    entries.append(.group(name: "Group 3"))
    //                }
    //                if [2,9,16,23,30].contains(dayNum) {
    //                    entries.append(.group(name: "Group 1"))
    //                }
    //
    //                return CalendarDay(date: day.date,
    //                                   isCurrentMonth: day.isCurrentMonth,
    //                                   entries: entries)
    //            }
    //        }
}
