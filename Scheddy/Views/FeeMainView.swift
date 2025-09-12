//
//  FeeMainView.swift
//  Scheddy
//
//  Created by Maria Regina Taufik on 10/09/25.
//

import SwiftUI

struct FeeMainView: View {
    @State var viewModel = CaddyFeeViewModel()
    @State private var draggedGroup: CaddyFeeData? = nil
    
    var groupedGroup: [String: [CaddyFeeData]] {
        Dictionary(
            grouping: viewModel.caddyFees,
            by: { $0.caddy_group_type }
        )
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
//                } else if let error = viewModel.errorMessage {
//                    Text("❌ \(error)")
//                        .foregroundColor(.red)
                } else {
                    ForEach(groupedGroup.keys.sorted(), id: \.self) { groupType in
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Group Type: \(groupType.capitalized)")
                                .font(.headline)
                                .foregroundColor(.black)
                                .padding(.leading, 10)
                            
                            HStack {
                                Rectangle()
                                    .fill(Color.teal.opacity(0.7))
                                    .frame(width: 4)
                                    .frame(maxHeight: .infinity, alignment: .top)
                                    .padding(.trailing, 8)
                                
                                VStack {
                                    ForEach(groupedGroup[groupType] ?? [], id: \.id_group) { caddyGroup in
                                        AccordionGroupView(
                                            title: "\(caddyGroup.group_name) | Total Rp \(caddyGroup.total_group_fee)",
                                            caddies: caddyGroup.caddies.map {
                                                "\($0.name) - Holes: \($0.total_holes), Fee: Rp \($0.total_fee)"
                                            },
                                        )
                                    }
                                }
                            }
                            .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .padding()
                    .cornerRadius(10)
                    
                    Spacer()
                }
            }
        }
        .onAppear {
            viewModel.caddyFees = CaddyFeeViewModel.dummy // load dummy data
        }
    }
}

#Preview {
    FeeMainView()
}
