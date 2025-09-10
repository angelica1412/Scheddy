//
//  CollapsibleGroupView.swift
//  Scheddy
//
//  Created by Maria Regina Taufik on 01/09/25.
//

import SwiftUI

struct CollapsibleGroup<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content
    @State private var isExpanded: Bool = false
    
    var body: some View {
        Section {
            if isExpanded {
                content
            }
        } header: {
            Button {
                withAnimation(.spring()) {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    Text(title.uppercased())
                        .font(.headline)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .foregroundColor(.white)
                }
                .padding(.vertical, 8)
            }
            .tint(Color.group)
            .buttonStyle(.borderedProminent)
        }
    }
}

