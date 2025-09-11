//
//  RootView.swift
//  Scheddy
//
//  Created by Maria Regina Taufik on 08/09/25.
//

import SwiftUI

enum SidebarItem: String, CaseIterable, Identifiable {
    case status = "Aktivitas\nCaddy"
    case jadwal = "Jadwal\nCaddy"
    case fee = "Manajemen\nCaddy"
    
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
                        Text(Date(), style: .date)
                            .font(.title3)
                            .foregroundColor(.secondary)
                            .hidden()
                    }
                }
//                .frame(height: 80)
                .padding(.horizontal)
                
                // Sidebar menu
                VStack(spacing: 8) {
                    ForEach(SidebarItem.allCases) { item in
                        SidebarButton(
                            item: item,
                            isSelected: selectedItem == item,
                            action: { selectedItem = item }
                        )
                    }
                }
                .padding(.horizontal, 16)
                
                Spacer()
                
//                // Profile section
//                HStack(spacing: 12) {
//                    AsyncImage(url: nil) { _ in
//                        Circle()
//                            .fill(Color.gray.opacity(0.3))
//                            .frame(width: 44, height: 44)
//                            .overlay(
//                                Image(systemName: "person.fill")
//                                    .foregroundColor(.gray)
//                            )
//                    }
//                    
//                    VStack(alignment: .leading, spacing: 2) {
//                        Text("Willas Tobing")
//                            .font(.system(size: 15, weight: .semibold))
//                        Text("Caddy Master")
//                            .font(.system(size: 13))
//                            .foregroundColor(.secondary)
//                    }
//                    Spacer()
//                }
//                .padding()
            }
            .padding(.leading)
            .frame(width: 310)
            .background(Color("BgPrimary"))
            
            // Detail View
            Group {
                switch selectedItem {
                case .status:
                    StatusView()
                case .jadwal:
                    ScheduleMainView()
                case .fee:
                    FeeMainView()
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
    
    struct SidebarButton: View {
        let item: SidebarItem
        let isSelected: Bool
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                HStack(spacing: 12) {
                    Image(systemName: icon(for: item))
                        .font(.body.weight(.medium))
                        .foregroundColor(isSelected ? Color("ButtonLabel") : .primary)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                    
                    Text(labelName(for: item))
                        .font(.body.weight(.medium))
                        .foregroundColor(isSelected ? Color("ButtonLabel") : .primary)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)

                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? Color("Button") : Color.clear)
                        .shadow(
                            color: isSelected ? Color.black.opacity(0.08) : Color.clear,
                            radius: isSelected ? 3 : 0,
                            x: 0,
                            y: isSelected ? 2 : 0
                        )
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
        
        private func icon(for item: SidebarItem) -> String {
            switch item {
            case .status: return "list.bullet"
            case .jadwal: return "calendar"
            case .fee: return "person.fill"
            }
        }
        private func labelName(for item: SidebarItem) -> String {
            switch item {
            case .status: return "Aktivitas Caddy"
            case .jadwal: return "Jadwal Caddy"
            case .fee: return "Manajemen Caddy"
            }
        }
    }
}

#Preview {
    RootView()
}
