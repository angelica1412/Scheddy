//
//  CustomSegmentedControl.swift
//  Scheddy
//
//  Created by Maria Regina Taufik on 01/09/25.
//


import SwiftUI

struct CustomSegmentedControl<Selection: Hashable>: View {
    let items: [Selection]
    @Binding var selection: Selection
    let label: (Selection) -> String
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(items, id: \.self) { item in
                Button {
                    selection = item
                } label: {
                    Text(label(item))
                        .font(.body)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .foregroundColor(selection == item ? .black : .gray)
                        .background(
                            Capsule()
                                .fill(selection == item ? Color.white : Color.clear)
                        )
                }
            }
        }
        .padding(1)
        .background(
            Capsule().fill(Color(.systemGray5))
        )
    }
}



