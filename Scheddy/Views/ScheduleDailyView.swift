//
//  ScheduleDailyView.swift
//  Scheddy
//
//  Created by Rafi Abhista  on 03/09/25.
//

import SwiftUI

struct ScheduleDailyView: View {
    @State private var draggedCaddy: DailyCaddyGroup?
    @State private var isStart: Bool = true
    @State private var isEdit: Bool = false
    @State private var showSaveAlert = false

    @StateObject private var viewModel = DailyScheduleViewModel()

    var groupedGroup: [String: [DailyCaddyGroup]] {
        Dictionary(grouping: viewModel.dailyGroups, by: { $0.shift ?? "Pagi" })
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack {
                        if let error = viewModel.errorMessage {
                            Text("❌ \(error)")
                                .foregroundColor(.red)
                        } else {
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
                                                if !isEdit {
                                                    AccordionGroupView(title: caddyGroup.group_name, caddies: caddyGroup.allCaddiesDetail, isEdit: isEdit, notOnField: caddyGroup.notOnFieldCount!)
                                                } else {
                                                    AccordionGroupView(title: caddyGroup.group_name, caddies: caddyGroup.allCaddiesDetail, isEdit: isEdit, notOnField: caddyGroup.notOnFieldCount!)
                                                        .onDrag {
                                                            self.draggedCaddy = caddyGroup
                                                            return NSItemProvider(object: caddyGroup.id as NSString)
                                                        }
                                                        .onDrop(
                                                            of: [.text],
                                                            delegate: DropViewDelegate(
                                                                destinationItem: caddyGroup,
                                                                caddieGroups: $viewModel.dailyGroups,
                                                                draggedItem: $draggedCaddy,
                                                                targetShift: shift
                                                            )
                                                        )
                                                }
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
                }
                .task {
                    await viewModel.loadGeneratedSchedule()
                }
                .toolbar {
                    if isEdit && !viewModel.hasSaved {
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
                        Task {
                            await viewModel.postSchedule() // ← simpan ke backend
                        }
                        printScheduleJSON()
                    }
                    Button("Cancel", role: .destructive) {}
                } message: {
                    Text("Jadwal yang disimpan tidak dapat diubah")
                }
                VStack {
                    Spacer()
                    if isStart && !viewModel.isLoading && !viewModel.hasSaved {
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
                                .background(Color.hijauMuda)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .padding()
                        .shadow(radius: 4)
                    }

                    if isEdit && !viewModel.hasSaved {
                        Button {
                            withAnimation(.spring()) {
                                showSaveAlert.toggle()
                            }
                        } label: {
                            Text("Simpan Jadwal")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.hijauMuda)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .padding()
                        .shadow(radius: 4)
                    }
                }

                if viewModel.isLoading {
                    VStack(alignment: .center) {
                        Spacer()
                        ProgressView("Loading...")
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(radius: 8)
                        Spacer()
                    }
                }
            }
        }
    }
}

extension ScheduleDailyView {
    func printScheduleJSON() {
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let formatter = ISO8601DateFormatter()

        let dataToSend: [[String: Any]] = viewModel.dailyGroups.enumerated().map { index, group in
            [
                "id_caddy_group": group.id_group,
                "urutan": index + 1,
                "date": formatter.string(from: tomorrow),
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
            print("✅ Drop selesai untuk item: \(draggedItem.group_name) (id: \(draggedItem.id_group))")
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

        print("➡️ Drag masuk: \(draggedItem.group_name) (index \(fromIndex)) -> \(destinationItem.group_name) (index \(toIndex))")

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
                    print("📌 Reorder: \(draggedItem.group_name) dipindah dari index \(fromIndex) ke \(toIndex)")
                }
            }
        }
    }
}

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

#Preview {
    ScheduleDailyView()
}
