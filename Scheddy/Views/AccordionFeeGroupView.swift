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
                            .foregroundColor(.group)
                        
                        Spacer()
                        
                        Text(group.caddy_group_type)
                            .frame(width: 100)
                            .padding(.vertical, 5)
                            .fontWeight(.medium)
                            .background(group.caddy_group_type == "Part-Time" ? Color.hijauMuda : Color.group)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .foregroundColor(.white)
                        
                        Image(systemName: "chevron.down")
                            .foregroundColor(.group)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .padding(.trailing, isEdit ? 60 : 0)
                }
                .tint(.white)
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity, alignment: .leading)
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
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            Text("Rp \(caddy.total_fee)")
                .fontWeight(.bold)
                .foregroundColor(Color.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.white)
        )
        .padding(.horizontal, 20) // narrower than header row
    }
}
