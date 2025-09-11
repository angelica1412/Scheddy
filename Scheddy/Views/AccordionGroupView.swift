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
    var showChevron: Bool = false
    var trailing: AnyView? = nil
    init(caddy: DailyCaddy, showChevron: Bool = true) {
        self.caddy = caddy
        self.showChevron = showChevron
        self.trailing = nil
    }

    init<Content: View>(caddy: DailyCaddy, showChevron: Bool = false, @ViewBuilder trailing: () -> Content) {
        self.caddy = caddy
        self.showChevron = showChevron
        self.trailing = AnyView(trailing())
    }

    var body: some View {
        HStack(spacing: 12) {
            Text(caddy.name.uppercased())
                .font(.body)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)

            if let trailing = trailing {
                trailing
            } else if showChevron {
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
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
