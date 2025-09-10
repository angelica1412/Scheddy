//
//  CalendarView.swift
//  Scheddy
//
//  Created by Wardatul Amalia Safitri on 08/09/25.
//

import SwiftUI

struct CalendarView: View {
    @StateObject private var vm = CalendarMonthViewModel()
    @State private var displayedMonth = Date()
    
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
    
    private var currentMonth: Date {
        Date()
    }
    
    private var nextMonth: Date {
        Calendar.current.date(byAdding: .month, value: 1, to: Date())!
    }
    
    var body: some View {
        ZStack(alignment: .bottom){
            VStack(spacing: 12) {
                // Month header
                HStack {
                    Spacer()
                    
                    // Chevron Prev Month
                    Button(action: {
                        if let prev = Calendar.current.date(byAdding: .month, value: -1, to: displayedMonth) {
                            displayedMonth = prev
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title.weight(.semibold))
                            .foregroundColor(
                                Calendar.current.isDate(displayedMonth, equalTo: currentMonth, toGranularity: .month)
                                ? .gray
                                : .hijauMuda
                            )
                    }
                    .disabled(Calendar.current.isDate(displayedMonth, equalTo: currentMonth, toGranularity: .month))
                    
                    // Display Month
                    Text(monthFormatter.string(from: displayedMonth).capitalized)
                        .font(.title.bold())
                        .frame(maxWidth: 500)
                    
                    // Chevron Next Month
                    Button(action: {
                        if let next = Calendar.current.date(byAdding: .month, value: 1, to: displayedMonth) {
                            displayedMonth = next
                        }
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.title.weight(.semibold))
                            .foregroundColor(
                                Calendar.current.isDate(displayedMonth, equalTo: nextMonth, toGranularity: .month)
                                ? .gray
                                : .hijauMuda
                            )
                    }
                    .disabled(Calendar.current.isDate(displayedMonth, equalTo: nextMonth, toGranularity: .month))
                    
                    Spacer()
                }
                
                ZStack(alignment: .top) {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .frame(width: 1150, height: 550)
                    
                    // Grid of days
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(["Minggu","Senin","Selasa","Rabu","kamis","Jumat","Sabtu"], id: \.self) { day in
                            Text(day)
                                .frame(maxWidth: .infinity)
                                .font(.subheadline.weight(.semibold))
                                .foregroundColor(day == "Minggu" || day == "Sabtu" ? .hijauMuda : .secondary)
                        }
                        
                        ForEach(vm.days) { day in
                            VStack(spacing: 8) {
                                if day.isCurrentMonth {
                                    Text(dayFormatter.string(from: day.date))
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                        .frame(width: 70, height: 40)
                                        .background(
                                            Calendar.current.isDateInToday(day.date) ?
                                            Circle().fill(Color.hijauMuda.opacity(0.5)) : nil
                                        )
                                }
                                
                                ForEach(day.entries) { entry in
                                    switch entry {
                                    case .libur:
                                        Text("LIBUR")
                                            .font(.caption.bold())
                                            .padding(.vertical, 4)
                                            .padding(.leading, 6)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(Color.backgroundLiburSenin)
                                            .foregroundColor(.white)
                                            .cornerRadius(4)
                                        
                                    case .group(let group):
                                        Text(group)
                                            .font(.caption.bold())
                                            .padding(.vertical, 4)
                                            .padding(.leading, 6)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(Color.backgroundLiburGroup)
                                            .foregroundColor(Color.textLiburGroup)
                                            .cornerRadius(4)
                                    }
                                }
                            }
                        }
                    }
                    .frame(maxWidth: 1000)
                    .offset(x: 0, y: 50)
                }
                
                Spacer()
            }
            .onAppear {
                Task {
                    await vm.load(month: displayedMonth)
                }
            }
            .onChange(of: displayedMonth) { newValue in
                Task {
                    await vm.load(month: newValue)
                }
            }
            
            if !Calendar.current.isDate(displayedMonth, equalTo: currentMonth, toGranularity: .month){
                Button(action: {
                    print("Buat Jadwal Libur tapped")
                }) {
                    Text("Buat Jadwal Libur")
                        .font(.headline.weight(.bold))
                        .foregroundColor(.white)
                        .padding(.vertical, 20)
                        .frame(maxWidth: 500)
                        .background(Color.hijauMuda)
                        .clipShape(Capsule())
                }.offset(x: 0, y: 20)
            }
        }
    }
}

#Preview {
    CalendarView(month: Date())
}
