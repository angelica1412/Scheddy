//
//  PrimaryButton.swift
//  Scheddy
//
//  Created by Maria Angelica Vinesytha Chandrawan on 11/09/25.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    var disabled: Bool = false
    var loading: Bool = false
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            if loading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(25)
            } else {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(disabled ? Color.gray.opacity(0.5) : Color.hijauMuda)
                    .cornerRadius(25)
            }
        }
        .disabled(disabled || loading)
    }
}
