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
                        .font(.body.weight(.medium))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .foregroundColor(selection == item ? Color("SegmentLabel") : .gray)
                        .background(
                            Capsule()
                                .fill(selection == item ? Color("Segment") : Color.clear)
                        )
                }
                .accessibilityLabel(Text("Tampilan \(label(item))"))
                .accessibilityAddTraits(.isButton)
                .accessibilityValue(selection == item ? "Dipilih" : "Tidak Dipilih")
            }
        }
        .padding(3)
        .background(
            Capsule().fill(Color(.systemGray5))
        )
    }
}



