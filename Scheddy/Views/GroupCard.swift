//
//  GroupCard.swift
//  Scheddy
//
//  Created by Maria Angelica Vinesytha Chandrawan on 12/09/25.
//

import SwiftUI

struct GroupCard: View {
    @Binding var section: GroupSection

    var body: some View {
        VStack(spacing: 10) {
            GroupHeader(title: section.title, type: section.type, isExpanded: $section.isExpanded)

            if section.isExpanded {
                ForEach(section.members) { m in
                    CaddyRowFee(member: m)
                    .padding(.horizontal, 24)
                }
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color(.systemGray6))
        )
    }
}
