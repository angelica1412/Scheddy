//
//  MonthFilter.swift
//  Scheddy
//
//  Created by Maria Angelica Vinesytha Chandrawan on 12/09/25.
//

import SwiftUI

struct MonthPicker: View {
    @Binding var selectedMonth: Int
    @Binding var selectedYear: String
    var onSelect: (Int, String) -> Void
    
    private let months = ["JAN", "FEB", "MAR", "APR",
                          "MEI", "JUN", "JUL", "AGU",
                          "SEP", "OKT", "NOV", "DES"]
    
    var body: some View {
        VStack(spacing: 12) {
            // Year Header
            Text("\(selectedYear)")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.hijauMuda)
                .cornerRadius(12, corners: [.topLeft, .topRight])
            
            // Months grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 12) {
                ForEach(1...12, id: \.self) { month in
                    Button {
                        selectedMonth = month
                        onSelect(month, selectedYear)
                    } label: {
                        Text(months[month - 1])
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(selectedMonth == month ? Color.white : Color.group)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .background(selectedMonth == month ? Color.hijauMuda : Color.white)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 12)
        }
        .background(Color.background)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 3)
        .frame(maxWidth: 300)
    }
}

// Corner radius helper for top-only corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
