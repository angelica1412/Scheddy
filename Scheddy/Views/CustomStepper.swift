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
        HStack {
            Text(title)
                .frame(width: 100, alignment: .leading)
            
            Spacer()
            
            Button(action: {
                if count > 0 { count -= 1 }
            }) {
                Image(systemName: "minus")
                    .frame(width: 32, height: 32)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            Text("\(count)")
                .frame(width: 30)
            
            Button(action: {
                count += 1
            }) {
                Image(systemName: "plus")
                    .frame(width: 32, height: 32)
                    .background(Color.teal)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }
}

