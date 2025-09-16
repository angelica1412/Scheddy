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
    
    var onCheckOutSuccess: (() async -> Void)? = nil

    @State private var selectedCaddy: Caddy? = nil
    
    @State private var hiddenCaddyIDs: Set<String> = []

    private func hideCaddy(_ id: String) {
        hiddenCaddyIDs.insert(id)
    }
    
    // Helper untuk membuat instance Caddy ringkas (mengurangi beban type-checker)
    private func makeCaddy(id: String, nama: String) -> Caddy {
        Caddy(
            id: id,
            name: nama,
            caddy_type: 0,
            id_user: "",
            id_caddy_group: "",
            urutan: 0
        )
    }
    
    // Kelompok yang punya item (mengurangi ekspresi kompleks di body)
    private var nonEmptyGroups: [CaddyGroupGeneric] {
        groupedCaddies.filter { !$0.caddies.isEmpty }
    }

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(nonEmptyGroups, id: \.id) { group in
                        CollapsibleGroup(title: group.nama) {
                            VStack(spacing: 12) {
                                ForEach(group.caddies, id: \.id) { caddy in
                                    if !hiddenCaddyIDs.contains(caddy.id) {
                                        let compact = makeCaddy(id: caddy.id, nama: caddy.nama)
                                        Button {
                                            selectedCaddy = compact
                                        } label: {
                                            CaddyRow(caddy: compact)
                                        }
                                    }
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
            CheckOutView(caddyId: caddy.id, onSuccess: {
                hideCaddy(caddy.id)
                await onCheckOutSuccess?()
            })
        }
    }
}
