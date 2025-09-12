//
//  OnFieldView.swift
//  Scheddy
//
//  Created by Wardatul Amalia Safitri on 03/09/25.
//

import SwiftUI

struct OnFieldListView: View {

    let groupedCaddies: [CaddyGroupGeneric]
    let isLoading: Bool
    let errorMessage: String?

    @State private var selectedCaddy: Caddy? = nil

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(groupedCaddies.filter { !$0.caddies.isEmpty }) { group in
                        CollapsibleGroup(title: group.nama) {
                            VStack(spacing: 12) {
                                ForEach(group.caddies) { caddy in
                                    Button {
                                        selectedCaddy = Caddy(
                                            id: caddy.id,
                                            name: caddy.nama,
                                            caddy_type: 0,
                                            id_user: "",
                                            id_caddy_group: "",
                                            urutan: 0
                                        )
                                    } label: {
                                        CaddyRow(
                                            caddy: Caddy(
                                                id: caddy.id,
                                                name: caddy.nama,
                                                caddy_type: 0,
                                                id_user: "",
                                                id_caddy_group: "",
                                                urutan: 0
                                            )
                                        )
                                    }
                                    .buttonStyle(.plain)
                                    .accessibilityLabel(Text(caddy.nama))
                                    .accessibilityAddTraits(.isButton)
                                    .accessibilityHint(Text("Ketuk dua kali untuk check-out caddy"))
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical, 4)
                .padding(.horizontal, 16)
            }

            // Overlay for loading and error
            if isLoading {
                VStack {
                    ProgressView("Loading...")
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                }
            } else if let error = errorMessage {
                Color.black.opacity(0.3)
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
        .sheet(item: $selectedCaddy) { caddy in
            CheckOutView(caddyId: caddy.id)
        }
    }
}
