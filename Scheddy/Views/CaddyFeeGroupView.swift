//
//  CaddyFeeGroupView.swift
//  Scheddy
//
//  Created by Wardatul Amalia Safitri on 15/09/25.
//

import SwiftUI

struct CaddyFeeGroupView: View {
    let type: String
    let groups: [CaddyFeeData]
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            // Vertical rectangle
            RoundedRectangle(cornerRadius:8)
                .fill(type == "Part-Time" ? Color.hijauMuda : Color.group)
                .frame(width: 5)
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.trailing, 8)
            
            VStack(alignment: .leading, spacing: 8) {
                // Each group card
                ForEach(groups, id: \.id_group) { group in
                    AccordionFeeGroupView(group: group)
                }
            }
        }
        .padding(.horizontal)
    }
}
