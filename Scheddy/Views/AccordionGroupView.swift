//
// AccordionGroupView.swift
// Scheddy
//
// Created by Mahardika Putra Wardhana on 08/09/25.
//

import SwiftUI

struct AccordionGroupView: View {
    let title: String
    var caddies: [DailyCaddy] = []
    @State private var isExpanded: Bool = false
    var isEdit: Bool = true

    var body: some View {
        Section {
            if isExpanded {
                ForEach(caddies, id: \.id) { caddy in
                    DailyCaddyRow(caddy: caddy)
                }
            }
        } header: {
            ZStack(alignment: .trailing) {
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
                    .padding(.horizontal, 12)
                    .padding(.trailing, isEdit ? 60 : 0)
                }
                .tint(.teal)
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity, alignment: .leading)

                Button {
                    // action edit
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .foregroundColor(.teal)
                        .padding(20)
                }
                .background(Color.teal.opacity(0.2))
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .opacity(isEdit ? 1 : 0)
            }
        }
    }
}

struct DailyCaddyRow: View {
    let caddy: DailyCaddy
    init(caddy: DailyCaddy) {
        self.caddy = caddy
    }

    var body: some View {
        HStack(spacing: 12) {
            Text(caddy.name.uppercased())
                .font(.body)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)

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


#Preview {
    AccordionGroupView(title: "Oyy", isEdit: true)
}
