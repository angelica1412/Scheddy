//
//  BagItemsEditor.swift
//  Scheddy
//
//  Created by Maria Angelica Vinesytha Chandrawan on 11/09/25.
//

import SwiftUI

struct BagItemsEditor: View {
    @Binding var wood: Int
    @Binding var iron: Int
    @Binding var putter: Int
    @Binding var umbrella: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Bag Items")
                .font(.headline)
                .foregroundColor(.black)
                .padding(.bottom, 4)

            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .center, spacing: 16) {
                    CustomStepper(title: "Wood", count: $wood)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    CustomStepper(title: "Putter", count: $putter)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                HStack(alignment: .center, spacing: 16) {
                    CustomStepper(title: "Iron", count: $iron)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    CustomStepper(title: "Umbrella", count: $umbrella)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.horizontal, 8)
        }
        .padding(.vertical, 8)
    }

    private func row(leftTitle: String, left: Binding<Int>, rightTitle: String, right: Binding<Int>) -> some View {
        HStack {
            stepper(title: leftTitle, value: left)
            Spacer(minLength: 16)
            stepper(title: rightTitle, value: right)
        }
    }

    private func stepper(title: String, value: Binding<Int>) -> some View {
        CustomStepper(title: title, count: value)
    }
}
