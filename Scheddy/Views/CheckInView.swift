//
//  CheckInView.swift
//  Scheddy
//
//  Created by Wardatul Amalia Safitri on 02/09/25.
//

import SwiftUI

struct CheckInView: View {
    @Environment(\.dismiss) var dismiss
    
    // Caddy yang dipilih dikirim dari luar
    let caddyId: Int
    let caddyName: String
    
    @State private var playerName = ""
    @State private var playerID = ""
    @State private var holeCount = 18
    @State private var caddyRequest = false
    
    @State private var wood = 0
    @State private var iron = 3
    @State private var putter = 0
    @State private var umbrella = 3
    @State private var otherItem = ""
    
    var body: some View {
        // Cancel Button
        HStack {
            Button("Kembali") {
                dismiss()
            }
            Spacer()
        }.padding(.leading)
        .padding(.top)
        
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // Title (dinamis)
                Text(caddyName)
                    .font(.title)
                    .bold()
                
                
                Grid(alignment: .leading, horizontalSpacing: 12, verticalSpacing: 12) {
                    // Player Name
                    GridRow {
                        Text("Nama Pemain")
                            .font(.headline)
                        TextField("Nama Pemain", text: $playerName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    // Player ID
                    GridRow {
                        Text("ID Pemain")
                            .font(.headline)
                        TextField("ID Pemain", text: $playerID)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    // Caddy Request
                    GridRow {
                        Text("Caddy Request")
                            .font(.headline)
                        Toggle("", isOn: $caddyRequest) // hanya switch
                            .labelsHidden() // sembunyikan label default
                    }
                    
                    Text("Bag Items")
                        .font(.headline)
                    
                    HStack (spacing: 0){
                        Grid(alignment: .leading, horizontalSpacing: 50, verticalSpacing: 12) {
                            GridRow {
                                HStack {
                                    Text("Wood")
                                    ItemStepper(title: "", count: $wood)
                                }.padding(.trailing, 50)
                            }
                            
                            GridRow {
                                HStack {
                                    Text("Iron")
                                    ItemStepper(title: "", count: $iron)
                                }.padding(.trailing, 50)
                            }
                        }

                        Grid(alignment: .leading, horizontalSpacing: 50, verticalSpacing: 12) {
                            GridRow {
                                HStack {
                                    Text("Putter")
                                    ItemStepper(title: "", count: $putter)
                                }.padding(.trailing, 50)
                            }

                            GridRow {
                                HStack {
                                    Text("Umbrella")
                                    ItemStepper(title: "", count: $umbrella)
                                }.padding(.trailing, 50)
                            }
                        }
                    }

                    // Extra ID Field
                    GridRow {
                        Text("Barang Lainnya")
                            .font(.headline)
                        TextField("Tambahkan barang lainnya", text: $otherItem)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                
                // Hole Picker
                //                VStack(alignment: .leading) {
                //                    Text("Jumlah Hole")
                //                        .font(.headline)
                //                    Picker("Jumlah Hole", selection: $holeCount) {
                //                        Text("9").tag(9)
                //                        Text("18").tag(18)
                //                    }
                //                    .pickerStyle(.segmented)
                //                }
                
                // Check-In Button
                Button(action: {
                    dismiss()
                }) {
                    Text("CHECK-IN")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.teal)
                        .cornerRadius(12)
                }
                .padding(.top)
            }
            .padding()
        
        }
        .frame(maxWidth:.infinity)
    }
}

#Preview {
    CheckInView(caddyId: 1, caddyName: "Intan Permata")
}
