//
//  CalendarView.swift
//  Scheddy
//
//  Created by Wardatul Amalia Safitri on 08/09/25.
//

import SwiftUI

struct CalendarMonthView: View {
    @StateObject private var vm = CalendarMonthViewModel()
    
    let month: Date
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    private let dayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "d"
        return f
    }()
    
    private let monthFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "id_ID")
        f.dateFormat = "LLLL yyyy"
        return f
    }()
    
    var body: some View {
        VStack(spacing: 12) {
            // Month header
            Text(monthFormatter.string(from: month).capitalized)
                .font(.title2.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            // Weekday header
            HStack {
                ForEach(["S","M","T","W","T","F","S"], id: \.self) { w in
                    Text(w)
                        .frame(maxWidth: .infinity)
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(w == "S" ? .green : .secondary)
                }
            }
            
            // Grid of days
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(vm.days) { day in
                    VStack(spacing: 4) {
                        if (day.isCurrentMonth){
                            Text(dayFormatter.string(from: day.date))
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                        ForEach(day.entries) { entry in
                            switch entry {
                            case .libur:
                                Text("LIBUR")
                                    .font(.caption2.bold())
                                    .padding(2)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(4)
                                
                            case .group(let group):
                                Text(group)
                                    .font(.caption2.bold())
                                    .padding(2)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.red.opacity(0.1))
                                    .foregroundColor(.primary)
                                    .cornerRadius(4)
                                //                                    Text(person)
                                //                                        .font(.caption2)
                                //                                        .foregroundColor(.primary)
                                
                                //                            case .player(let name):
                                //                                Text(name)
                                //                                    .font(.caption2)
                                //                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .frame(minHeight: 70)
                    .padding(4)
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            Task {
                await vm.load(month: month)
            }
        }
    }
}

#Preview {
    CalendarMonthView(month: Date())
}
