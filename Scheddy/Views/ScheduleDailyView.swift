//
//  ScheduleDailyView.swift
//  Scheddy
//
//  Created by Rafi Abhista  on 03/09/25.
//

import SwiftUI

struct DailyCaddyGroup: Codable, Identifiable, Equatable {
    let id: String
    var name: String
    var caddies: [Caddy]
    var shift: String? = "Pagi"
    var notOnFieldCount: Int? = 0
    var group_order: Int? = 0
}

struct ScheduleItem: Codable {
    var id_caddy_group: String
    var urutan: Int
    var date: Date
    var shift: String
}

struct ScheduleDailyView: View {
    @State private var draggedCaddy: DailyCaddyGroup?
    @State private var isStart: Bool = true
    @State private var isEdit: Bool = false
    @State private var showSaveAlert = false

    var caddiesDummy: [Caddy] = [
        Caddy(id: "1", name: "Alice", status: "Available"),
        Caddy(id: "2", name: "Bob", status: "Busy"),
        Caddy(id: "3", name: "Charlie", status: "Available"),
    ]

    @StateObject private var viewModel = DailyScheduleViewModel()
    @StateObject private var dummyVM = CaddyStatusViewModel()

    @State private var dailyCaddyGroups: [DailyCaddyGroup] = []

    init() {
        _dailyCaddyGroups = State(initialValue: [
            DailyCaddyGroup(id: "1", name: "Caddy 1", caddies: caddiesDummy, shift: "Pagi"),
            DailyCaddyGroup(id: "2", name: "Caddy 2", caddies: caddiesDummy, shift: "Pagi"),
            DailyCaddyGroup(id: "6", name: "Caddy 6", caddies: caddiesDummy, shift: "Siang"),
            DailyCaddyGroup(id: "7", name: "Caddy 7", caddies: caddiesDummy, shift: "Siang"),
        ])
    }

    var groupedGroup: [String: [DailyCaddyGroup]] {
        Dictionary(grouping: dailyCaddyGroups, by: { $0.shift ?? "Pagi" })
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(groupedGroup.keys.sorted(), id: \.self) {
                            shift in
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Shift \(shift)")
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
                                        ForEach(groupedGroup[shift] ?? [], id: \.id) { caddyGroup in
                                            AccordionGroupView(title: caddyGroup.name, caddies: caddyGroup.caddies, isEdit: isEdit)
                                                .onDrag {
                                                    self.draggedCaddy = caddyGroup
                                                    return NSItemProvider(object: caddyGroup.id as NSString)
                                                }
                                                .onDrop(
                                                    of: [.text],
                                                    delegate: DropViewDelegate(
                                                        destinationItem: caddyGroup,
                                                        caddieGroups: $dailyCaddyGroups,
                                                        draggedItem: $draggedCaddy,
                                                        targetShift: shift
                                                    )
                                                )
                                        }
                                    }
                                }.fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        .padding()
                        .cornerRadius(10)
                        Spacer()
                    }
                }
                VStack {
                    Spacer()
                    Button {
                        Task {
                            await viewModel.loadGeneratedSchedule()
                        }
                    } label: {
                        Text("Print API Result")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .padding()
                    .shadow(radius: 10)

                    if isStart {
                        Button {
                            withAnimation(.spring()) {
                                isEdit.toggle()
                                isStart.toggle()
                            }
                        } label: {
                            Text("Ubah Jadwal")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.teal)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .padding()
                        .shadow(radius: 15)
                    }

                    if isEdit {
                        Button {
                            withAnimation(.spring()) {
                                showSaveAlert.toggle()
                            }
                        } label: {
                            Text("Simpan Jadwal")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.teal)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .padding()
                        .shadow(radius: 15)
                    }
                }
            }
            .navigationTitle("Shift")
            .toolbar {
                if isEdit {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Cancel") {
                            withAnimation(.spring()) {
                                isEdit = false
                                isStart = true
                            }
                        }
                    }
                }
            }
            .alert("Yakin simpan jadwal caddy?", isPresented: $showSaveAlert) {
                Button("OK", role: .cancel) {
                    isEdit.toggle()
                    printScheduleJSON()
                }
                Button("Cancel", role: .destructive) {}
            } message: {
                Text("Jadwal yang disimpan tidak dapat diubah")
            }
        }
    }
}

extension ScheduleDailyView {
    func shiftCode(from shift: String?) -> Int {
        switch shift {
        case "Pagi":
            return 0
        case "Siang":
            return 1
        default:
            return 0 // default Pagi kalau nil/unknown
        }
    }

    func printScheduleJSON() {
        let today = Date()
        let dataToSend: [[String: Any]] = dailyCaddyGroups.enumerated().map { index, group in
            [
                "id_caddy_group": group.id,
                "urutan": index + 1,
                "date": ISO8601DateFormatter().string(from: today),
                "shift": shiftCode(from: group.shift), // ← pakai kode angka
            ]
        }

        // convert dictionary ke JSON string
        if let jsonData = try? JSONSerialization.data(withJSONObject: dataToSend,
                                                      options: [.prettyPrinted, .sortedKeys]),
            let jsonString = String(data: jsonData, encoding: .utf8)
        {
            print("Generated JSON:\n\(jsonString)")
        }
    }
}

struct DropViewDelegate: DropDelegate {
    let destinationItem: DailyCaddyGroup?
    @Binding var caddieGroups: [DailyCaddyGroup]
    @Binding var draggedItem: DailyCaddyGroup?
    let targetShift: String

    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }

    func performDrop(info: DropInfo) -> Bool {
        if let draggedItem {
            print("✅ Drop selesai untuk item: \(draggedItem.name) (id: \(draggedItem.id))")
        }
        DispatchQueue.main.async {
            self.draggedItem = nil
        }
        return true
    }

    func dropEntered(info: DropInfo) {
        guard let draggedItem,
              let fromIndex = caddieGroups.firstIndex(of: draggedItem),
              let destinationItem,
              let toIndex = caddieGroups.firstIndex(of: destinationItem)
        else { return }

        print("➡️ Drag masuk: \(draggedItem.name) (index \(fromIndex)) -> \(destinationItem.name) (index \(toIndex))")

        if caddieGroups[fromIndex].shift != targetShift {
            print("🔄 Pindah shift dari \(caddieGroups[fromIndex].shift ?? "-") ke \(targetShift)")
            caddieGroups[fromIndex].shift = targetShift
        }

        DispatchQueue.main.async {
            if fromIndex != toIndex {
                withAnimation {
                    caddieGroups.move(
                        fromOffsets: IndexSet(integer: fromIndex),
                        toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex
                    )
                    print("📌 Reorder: \(draggedItem.name) dipindah dari index \(fromIndex) ke \(toIndex)")
                }
            }
        }
    }
}

#Preview {
    ScheduleDailyView()
}
