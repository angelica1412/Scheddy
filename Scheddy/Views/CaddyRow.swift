//
//  CaddyRow.swift
//  Scheddy
//
//  Created by Maria Regina Taufik on 01/09/25.
//

import SwiftUI

struct CaddyRow: View {
    let caddy: Caddy
    var showChevron: Bool = true
    var trailing: AnyView? = nil
    init(caddy: Caddy, showChevron: Bool = true) {
        self.caddy = caddy
        self.showChevron = showChevron
        self.trailing = nil
    }
    
    init<Content: View>(caddy: Caddy, showChevron: Bool = false, @ViewBuilder trailing: () -> Content) {
        self.caddy = caddy
        self.showChevron = showChevron
        self.trailing = AnyView(trailing())
    }

    var body: some View {
        HStack(spacing: 12) {
            Text(caddy.name.uppercased())
                .font(.body)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if let trailing = trailing {
                trailing
            } else if showChevron {
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(UIColor.white))
        )
    }
}
