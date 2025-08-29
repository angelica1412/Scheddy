//
//  SidebarView.swift
//  Scheddy
//
//  Created by Maria Angelica Vinesytha Chandrawan on 29/08/25.
//


import SwiftUI

struct SidebarView: View {
    @Binding var isVisible: Bool
    @Binding var selection: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            // Background hitam transparan
            if isVisible {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isVisible = false
                        }
                    }
            }
            
            // Sidebar Content
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    // Menu Items
                    Group {
                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(selection == "Status" ? .blue : .blue)
                            Text("Status")
                                .foregroundColor(selection == "Status" ? .blue : .primary)
                                .fontWeight(selection == "Status" ? .bold : .regular)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            selection == "Status" ?
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                                .shadow(radius: 4)
                            : nil
                        )
                        .onTapGesture {
                            selection = "Status"
                            withAnimation { isVisible = false }
                        }
                        
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(selection == "Jadwal" ? .blue : .blue)
                            Text("Jadwal")
                                .foregroundColor(selection == "Jadwal" ? .blue : .primary).fontWeight(selection == "Jadwal" ? .bold : .regular)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            selection == "Jadwal" ?
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                                .shadow(radius: 4)
                            : nil
                        )
                        .onTapGesture {
                            selection = "Jadwal"
                            withAnimation { isVisible = false }
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 20)
                .frame(width: 270)
                .background(Color(UIColor.systemBackground))
//                .shadow(radius: 4)
                .offset(x: isVisible ? 0 : -300)
                .animation(.easeInOut, value: isVisible)
                Spacer()
            }
        }
    }
}
