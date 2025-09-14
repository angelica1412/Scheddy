//
//  AccordionFeeGroupView.swift
//  Scheddy
//
//  Created by Wardatul Amalia Safitri on 14/09/25.
//

import SwiftUI

struct AccordionFeeGroupView: View {
    let group: CaddyFeeData
    @State private var isExpanded: Bool = false
    var isEdit: Bool = false
    
    var body: some View {
        Section {
            if isExpanded {
                ForEach(group.caddies, id: \.id) { caddy in
                    AccordionFeeRow(caddy: caddy)
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
                        Text(group.group_name.uppercased())
                            .font(.headline)
                            .foregroundColor(.white)
                        Spacer()
                        Text(group.caddy_group_type) // "Part-Time" / "Casual"
                            .padding(.horizontal, 12)
                            .padding(.vertical, 5)
                            .fontWeight(.medium)
                            .background(group.caddy_group_type == "Part-Time" ? Color.green : Color.orange)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .foregroundColor(.white)
                        
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
                
                if isEdit {
                    Button {
                        // action edit fee group
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .foregroundColor(.teal)
                            .padding(25)
                    }
                    .background(Color.teal.opacity(0.2))
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
    }
}

struct AccordionFeeRow: View {
    let caddy: Caddies
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(caddy.name.uppercased())
                    .font(.body)
                    .foregroundColor(.black)
                Text("\(caddy.total_turun)x Turun")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text("Rp \(caddy.total_fee)")
                .fontWeight(.bold)
                .foregroundColor(.black)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.white)
        )
    }
}
