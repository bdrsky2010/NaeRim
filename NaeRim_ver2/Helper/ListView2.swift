//
//  ListView.swift
//  NaeRim
//
//  Created by Minjae Kim on 2023/03/20.
//

import SwiftUI

struct ListView2: View {
	@State private var contacts = [
		"제 1주차장",
		"제 2주차장",
		"제 3주차장",
		"제 4주차장",
		"제 5주차장",
		"제 6주차장"
	]
	@State private var multiSelection = Set<String>()
	@State private var editMode = EditMode.inactive
	@State private var isEditMode = false
	@Binding var isShow: Bool
	var body: some View {
		NavigationView {
			List(selection: $multiSelection) {
				ForEach(contacts, id: \.self) { contact in
					Text(contact)
				}
				.onDelete { indexSet in
					contacts.remove(atOffsets: indexSet)
				}
				.onMove(perform: onMove)
			}
			//listStyle을 정해줌
			.listStyle(DefaultListStyle())
			.navigationBarTitle("즐겨찾기")
			.navigationBarItems(leading: deleteButton, trailing: editButton)
			.environment(\.editMode, $editMode)
			.animation(.easeInOut, value: isEditMode)
		}
	}
	
	private var editButton: some View {
		if editMode == .inactive {
			return Button(action: {
				self.editMode = .active
				self.multiSelection = Set<String>()
				self.isEditMode.toggle()
			}) {
				Text("Edit")
					.foregroundColor(.black)
			}
		}
		else {
			return Button(action: {
				self.editMode = .inactive
				self.multiSelection = Set<String>()
				self.isEditMode.toggle()
			}) {
				Text("Done")
					.foregroundColor(.black)
			}
		}
	}
	
	private var deleteButton: some View {
		if editMode == .inactive {
			return Button {
				isShow = false
			} label: {
				Image(systemName: "xmark")
					.foregroundColor(.black)
			}
		} else {
			return Button(action: deleteNumbers) {
				Image(systemName: "trash.fill")
					.foregroundColor(.red)
			}
		}
	}
	
	private func deleteNumbers() {
		for id in multiSelection {
			if let index = contacts.lastIndex(where: { $0 == id })  {
				contacts.remove(at: index)
			}
		}
		multiSelection = Set<String>()
	}
	// 3.
	private func onMove(source: IndexSet, destination: Int) {
		contacts.move(fromOffsets: source, toOffset: destination)
	}
}
