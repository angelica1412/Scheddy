//
//  CaddyLabelFee.swift
//  Scheddy
//
//  Created by Maria Angelica Vinesytha Chandrawan on 13/09/25.
//
import SwiftUI

struct LabelCaddyFee: View {
    let type: EmploymentType
    var body: some View {
        Text(type.rawValue)
            .font(.callout.weight(.semibold))
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(type.tint.opacity(0.2))
            .foregroundStyle(type.tint)
            .clipShape(Capsule())
    }
}
