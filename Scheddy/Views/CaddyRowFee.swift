//
//  CaddyRowFee.swift
//  Scheddy
//
//  Created by Maria Angelica Vinesytha Chandrawan on 12/09/25.
//

import SwiftUI

struct CaddyRowFee: View {
    let member: Member
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(member.name)
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.primary)
                Text("\(member.trips)x Turun")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 12)
            Text(member.amountIDR.idrCurrency)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color(.systemGray5), lineWidth: 1)
                )
        )
        .contentShape(RoundedRectangle(cornerRadius: 14))
    }
}
