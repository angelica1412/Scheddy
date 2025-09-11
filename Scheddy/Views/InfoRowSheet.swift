//
//  InfoRowSheetView.swift
//  Scheddy
//
//  Created by Maria Angelica Vinesytha Chandrawan on 11/09/25.
//

import SwiftUI

struct InfoRowSheet<Content: View>: View {
    let label: String
    var isMultiline: Bool = false
    var showDivider: Bool = false
    @ViewBuilder var value: () -> Content

    var body: some View {
        HStack(alignment: isMultiline ? .top : .center, spacing: 12) {
            Text(label)
                .font(.headline)
                .foregroundColor(.black)
                .frame(width: 120, alignment: .leading)
            value()
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 8)
        .overlay(
            Group {
                if showDivider {
                    Divider().background(Color.gray.opacity(0.15))
                }
            },
            alignment: .bottom
        )
    }
}
