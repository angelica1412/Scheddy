//
//  StandByView.swift
//  Scheddy
//
//  Created by Wardatul Amalia Safitri on 03/09/25.
//

import SwiftUI

import SwiftUI

struct StandByListView: View {
    let groupedCaddies: [String: [Caddy]]
    
    @State private var selectedCaddy: Caddy? = nil
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(groupedCaddies.keys.sorted(), id: \.self) { group in
                    CollapsibleGroup(title: group) {
                        VStack(spacing: 12) {
                            ForEach(groupedCaddies[group] ?? []) { caddy in
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
//#Preview {
//    StandByListView()
//}
