//
//  HolePicker.swift
//  Scheddy
//
//  Created by Maria Angelica Vinesytha Chandrawan on 11/09/25.
//

import SwiftUI

struct HolePicker: View {
    let options: [Int] = [9, 18, 27]
    @Binding var selection: Int?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if selection == nil {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                        .font(.subheadline)
                    Text("Pilih jumlah hole yang dimainkan")
                        .foregroundColor(.red)
                        .font(.subheadline)
                }
                .padding(.bottom, 4)
            }
            HStack(alignment: .top, spacing: 12) {
                Text("Jumlah Hole")
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(width: 120, alignment: .leading)
                HStack(spacing: 12) {
                    ForEach(options, id: \.self) { hole in
                        Button { selection = hole } label: {
                            Text("\(hole)")
                                .font(.body)
                                .frame(maxWidth: 120, minHeight: 30)
                                .multilineTextAlignment(.center)
                                .background(selection == hole ? Color.hijauMuda : Color.clear)
                                .foregroundColor(selection == hole ? .white : .black)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(selection == hole ? Color.hijauMuda : Color.gray.opacity(0.3), lineWidth: 1)
                                )
                                .cornerRadius(20)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.vertical, 8)
        .overlay(Divider().background(Color.gray.opacity(0.15)), alignment: .bottom)
    }
}
