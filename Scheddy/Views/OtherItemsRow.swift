//
//  OtherItemsRow.swift
//  Scheddy
//
//  Created by Maria Angelica Vinesytha Chandrawan on 11/09/25.
//

import SwiftUI

struct OtherItemsRow: View {
    @Binding var text: String
    var placeholder: String = "(Contoh: Penutup Stick Golf, x1)"

    var body: some View {
        InfoRowSheet(label: "Lainnya", isMultiline: true) {
            TextField(placeholder, text: $text, axis: .vertical)
                .lineLimit(1...3)
                .padding(.horizontal, 12)
                .padding(.vertical, 14)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
    }
}
