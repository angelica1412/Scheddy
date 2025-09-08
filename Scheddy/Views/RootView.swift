//
//  RootView.swift
//  Scheddy
//
//  Created by Maria Regina Taufik on 08/09/25.
//

import SwiftUI

enum SidebarItem: String, CaseIterable, Identifiable {
    case status = "Aktivitas Caddy"
    case jadwal = "Jadwal"
    
    var id: String { rawValue }
}

struct RootView: View {
    @State private var selectedItem: SidebarItem? = .status
    
    var body: some View {
        HStack(spacing: 0) {
            // Sidebar
            VStack(alignment: .leading, spacing: 8) {
                Text(selectedItem?.rawValue ?? "Scheddy")
                    .font(.largeTitle.bold())
                    .padding(.top, 50)
                    .padding(.horizontal)

                Group{
                    if selectedItem == .status {
                        Text(Date(), style: .date)
                            .font(.title3)
                            .foregroundColor(.secondary)
                    } else {
                        Text("")
                    }
                }
                .frame(height: 30)
                .padding(.horizontal)
                
                // Sidebar menu
                VStack(spacing: 8) {
                    ForEach(SidebarItem.allCases) { item in
                        Button {
                            selectedItem = item
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: icon(for: item))
                                    .font(.system(size: 16, weight: .medium))
                                    .frame(width: 20)
                                    .foregroundColor(selectedItem == item ? .teal : .primary)
                                
                                Text(item.rawValue)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(selectedItem == item ? .teal : .primary)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(selectedItem == item ? Color.white : Color.clear)
                                .shadow(
                                    color: selectedItem == item ? Color.black.opacity(0.08) : Color.clear,
                                    radius: selectedItem == item ? 3 : 0,
                                    x: 0,
                                    y: selectedItem == item ? 2 : 0
                                )
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 16)
                
                Spacer()
                
                // Profile section
                HStack(spacing: 12) {
                    AsyncImage(url: nil) { _ in
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 44, height: 44)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .foregroundColor(.gray)
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Willas Tobing")
                            .font(.system(size: 15, weight: .semibold))
                        Text("Caddy Master")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                .padding()
            }
            .frame(width: 300)
            .background(Color(.systemGray6))
            
            // Detail View
            Group {
                switch selectedItem {
                case .status:
                    StatusView()
                case .jadwal:
                    ScheduleMainView()
                default:
                    Text("Pilih menu di sidebar")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
        }
        .ignoresSafeArea(.all, edges: .all)
    }
    
    private func icon(for item: SidebarItem) -> String {
        switch item {
        case .status: return "list.bullet"
        case .jadwal: return "calendar"
        }
    }
}

#Preview {
    RootView()
}
