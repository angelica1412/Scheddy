//
//  ToggleRow.swift
//  Scheddy
//
//  Created by Maria Angelica Vinesytha Chandrawan on 11/09/25.
//

import SwiftUI

struct ToggleRow: View {
    let label: String
    @Binding var isOn: Bool

    var body: some View {
        InfoRowSheet(label: label) {
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .scaleEffect(0.9)
        }
    }
}
