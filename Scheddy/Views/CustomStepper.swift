//
//  SwiftUIView.swift
//  Scheddy
//
//  Created by Wardatul Amalia Safitri on 02/09/25.
//

import SwiftUI

struct ItemStepper: View {
    var title: String
    @Binding var count: Int
    
    var body: some View {
        HStack(spacing: 15) {
            Button(action: {
                if count > 0 {
                    count -= 1
                }
            }) {
                Image(systemName: "minus")
                    .font(.body)
                    .foregroundColor(.black)
                    .frame(width: 30, height: 30)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(Rectangle())
                    .cornerRadius(8)
            }
            
            Text("\(count)")
                .font(.system(size: 16))
                .frame(minWidth: 20)
            
            Button(action: {
                count += 1
            }) {
                Image(systemName: "plus")
                    .font(.body)
                    .foregroundColor(.black)
                    .frame(width: 30, height: 30)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(Rectangle())
                    .cornerRadius(8)
            }
        }
    }
}

