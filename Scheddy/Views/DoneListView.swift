//
//  DoneView.swift
//  Scheddy
//
//  Created by Wardatul Amalia Safitri on 03/09/25.
//

import SwiftUI

struct DoneListView: View {
  
    let groupedCaddies: [CaddyGroupGeneric]
    let isLoading: Bool
    let errorMessage: String?
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(groupedCaddies) { group in
                        CollapsibleGroup(title: group.nama) {
                            VStack(spacing: 12) {
                                ForEach(group.caddies) { caddy in
                                    CaddyRow(
                                        caddy: Caddy(
                                            id: caddy.id,
                                            name: caddy.nama,
                                            caddy_type: 0,
                                            id_user: "",
                                            id_caddy_group: "",
                                            urutan: 0
                                        ),
                                        showChevron: false
                                    )
                                    .background(Color.white)
                                    .cornerRadius(8)
                                }
                            }
                            .padding(.vertical, 4)
                            .padding(.horizontal, 16)
                        }
                    }
                }
                .padding(.vertical)
            }
            // Overlay for loading or error
            if isLoading {
                VStack {
                    ProgressView("Loading...")
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                }
            } else if let error = errorMessage {
                Color.black.opacity(0.2)
                    .ignoresSafeArea()
                VStack {
                    Text(error)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(12)
                }
            }
        }
    }
}