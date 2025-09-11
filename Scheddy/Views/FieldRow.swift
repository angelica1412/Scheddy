//
//  FieldRow.swift
//  Scheddy
//
//  Created by Maria Angelica Vinesytha Chandrawan on 11/09/25.
//

import SwiftUI

struct FieldRow: View {
    let label: String
    @Binding var text: String
    var keyboard: UIKeyboardType = .default
    var placeholder: String = ""

    var body: some View {
        InfoRowSheet(label: label) {
            TextField(placeholder, text: $text)
                .keyboardType(keyboard)
                .padding(.horizontal, 12)
                .padding(.vertical, 14)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
    }
}
