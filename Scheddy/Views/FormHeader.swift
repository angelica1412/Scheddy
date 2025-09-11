//
//  FormHeader.swift
//  Scheddy
//
//  Created by Maria Angelica Vinesytha Chandrawan on 11/09/25.
//

import SwiftUI

struct FormHeader: View {
    let title: String
    var onCancel: () -> Void
    
    var body: some View {
        ZStack {
            HStack {
                Button(action: onCancel) {
                    Text("Batal")
                        .foregroundColor(.hijauMuda)
                }
                Spacer()
            }
            Text(title)
                .font(.headline)
                .foregroundColor(.black)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
}
