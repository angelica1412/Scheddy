//
//  GroupHeader.swift
//  Scheddy
//
//  Created by Maria Angelica Vinesytha Chandrawan on 13/09/25.
//

import SwiftUI

struct GroupHeader: View {
    let title: String
    let type: EmploymentType
    @Binding var isExpanded: Bool

    var body: some View {
        HStack(spacing: 12) {
            Text(title)
                .font(.title3.weight(.heavy))
                .foregroundStyle(Color.group)
                .textCase(.uppercase)

            Spacer()

            LabelCaddyFee(type: type)

            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    isExpanded.toggle()
                }
            } label: {
                Image(systemName: "chevron.down")
                    .rotationEffect(.degrees(isExpanded ? 0 : -90))
                    .font(.system(size: 14, weight: .bold))
                    .padding(8)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(.white)
                .shadow(color: .black.opacity(0.03), radius: 6, y: 2)
        )
        .contentShape(RoundedRectangle(cornerRadius: 18))
    }
}

