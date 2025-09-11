//
//  BagItemsReadOnly.swift
//  Scheddy
//
//  Created by Maria Angelica Vinesytha Chandrawan on 11/09/25.
//

import SwiftUI

struct BagItemsReadOnly: View {
    let wood: Int
    let iron: Int
    let putter: Int
    let umbrella: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Bag Items")
                .font(.headline)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 8)
                .overlay(Divider().background(Color.gray.opacity(0.15)), alignment: .bottom)

            VStack(spacing: 12) {
                row(leftTitle: "Wood", left: wood, rightTitle: "Putter", right: putter)
                    .padding(.vertical, 8)
                    .overlay(Divider().background(Color.gray.opacity(0.15)), alignment: .bottom)
                row(leftTitle: "Iron", left: iron, rightTitle: "Umbrella", right: umbrella)
                    .padding(.vertical, 8)
                    .overlay(Divider().background(Color.gray.opacity(0.15)), alignment: .bottom)
            }
            .padding(.horizontal, 16)
        }
    }

    private func row(leftTitle: String, left: Int, rightTitle: String, right: Int) -> some View {
        HStack {
            item(title: leftTitle, qty: left)
            Spacer(minLength: 16)
            item(title: rightTitle, qty: right)
        }
    }

    private func item(title: String, qty: Int) -> some View {
        HStack(spacing: 16) {
            Text(title)
                .font(.body)
                .foregroundColor(.black)
                .frame(width: 80, alignment: .leading)
            Text("\(qty)")
                .font(.body)
                .foregroundColor(.black)
        }
    }
}
