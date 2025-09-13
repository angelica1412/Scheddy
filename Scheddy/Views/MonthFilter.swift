//
//  MonthFilter.swift
//  Scheddy
//
//  Created by Maria Angelica Vinesytha Chandrawan on 12/09/25.
//

import SwiftUI

struct MonthFilter: View {
    private var title: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.dateFormat = "LLLL yyyy" // Nama bulan panjang + tahun
        return formatter.string(from: Date())
    }
    @State private var showPicker = false
    @State private var selected = 0

    var body: some View {
        HStack(alignment: .center) {
            Text(title)
                .font(.title.weight(.semibold))
                .foregroundStyle(.primary)

            Spacer()

            Menu {
                Picker("Filter", selection: $selected) {
                    Text("Bulan").tag(0)
                    Text("Minggu").tag(1)
                    Text("Hari").tag(2)
                }
            } label: {
                HStack(spacing: 6) {
                    Text("Bulan")
                    Image(systemName: "chevron.down")
                }
                .font(.callout.weight(.semibold))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray5)))
            }
        }
        .padding(.horizontal)
    }
}
