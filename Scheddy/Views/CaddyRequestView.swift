//
//  CaddyRequestView.swift
//  Scheddy
//
//  Created by Maria Angelica Vinesytha Chandrawan on 04/09/25.
//

import SwiftUI

struct CaddyRequestView: View {
    let groupedCaddies: [CaddyGroupData]
    
    @State private var selectedCaddy: Caddy? = nil
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(groupedCaddies) { group in
                    CollapsibleGroup(title: group.caddy_group.group_name) {
                        VStack(spacing: 12) {
                            ForEach(group.caddies) { caddy in
                                Button {
                                    selectedCaddy = caddy
                                } label: {
                                    CaddyRow(caddy: caddy)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
        }
        // Sheet overlay
        .sheet(item: $selectedCaddy) { caddy in
            CheckInView(
                caddyId: caddy.id,
                caddyName: caddy.name
            )
        }
    }
}
