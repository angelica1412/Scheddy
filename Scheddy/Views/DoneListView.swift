//
//  DoneView.swift
//  Scheddy
//
//  Created by Wardatul Amalia Safitri on 03/09/25.
//

import SwiftUI

struct DoneListView: View {
    let groupedCaddies: [String: [Caddy]]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(groupedCaddies.keys.sorted(), id: \.self) { group in
                    CollapsibleGroup(title: group) {
                        VStack(spacing: 12) {
                            ForEach(groupedCaddies[group] ?? []) { caddy in
                                CaddyRow(caddy: caddy)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
        }
    }
}

//#Preview {
//    DoneListView()
//}
