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
    var body: some View {
        HStack {
            Text(caddy.name.uppercased())
            Spacer()
            if showChevron {
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(UIColor.white))
        )
    }
}
