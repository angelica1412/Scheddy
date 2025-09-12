//
//  StandByView.swift
//  Scheddy
//
//  Created by Wardatul Amalia Safitri on 03/09/25.
//

import SwiftUI

struct StandByListView: View {
    let groupedCaddies: [CaddyGroupData]
    let isLoading: Bool
    let errorMessage: String?

    @State private var selectedCaddy: Caddy? = nil

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(groupedCaddies) { group in
                        CollapsibleGroup(title: group.caddy_group.group_name) {
                            VStack(spacing: 12) {
                                ForEach(group.caddies) { caddy in
                                    Button {
                                        selectedCaddy = caddy
                                        print (caddy)
                                    } label: {
                                        CaddyRow(caddy: caddy)
                                    }
                                    .buttonStyle(.plain)
                                    .accessibilityLabel(Text(caddy.name))
                                    .accessibilityAddTraits(.isButton)
                                    .accessibilityHint(Text("Ketuk dua kali untuk check-in caddy"))
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical, 4)
                .padding(.horizontal, 16)
            }
            
            if isLoading {
                VStack {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                }
                .background(Color.white)
                .cornerRadius(10)
                .padding(40)
            } else if let error = errorMessage {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                VStack {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .background(Color.white)
                .cornerRadius(10)
                .padding(40)
            }
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

