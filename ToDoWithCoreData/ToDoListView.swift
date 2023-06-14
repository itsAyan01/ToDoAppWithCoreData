//
//  ToDoListView.swift
//  ToDoWithCoreData
//
//  Created by Dr.Mac on 14/11/22.
//

import SwiftUI

struct ToDoListView: View {
    
    @StateObject var vm: CoreDataViewModel = CoreDataViewModel()
    @State var textFieldText: String = ""
    @State var showUpdateDialog: Bool = false
    @State var selectedRowText: String = ""
    @State var selectedEntity = ListEntity()
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    addNewItemView
                    
                    listView
                }
                
                if showUpdateDialog {
                    UpdateDialogView(selectedEntity: selectedEntity, text: selectedRowText, vm: vm, showUpdateDialog: $showUpdateDialog)
                        .transition(.scale)
                }
                
            }
            .navigationBarTitle("ToDo")
        }
    }
}


extension ToDoListView {
    
    var addNewItemView: some View {
        VStack {
            TextField("Add new item", text: $textFieldText)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.4))
                )
                .padding()
            
            Button {
                if !textFieldText.isEmpty {
                    vm.addItem(text: textFieldText)
                    textFieldText = ""
                }
            } label: {
                Text("Add to list")
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.brown)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
        }
    }
    
    var listView: some View {
        VStack {
            List {
                ForEach(Array(vm.savedEntities.enumerated()), id: \.element) { index, element in
                    
                    HStack {
                        Text("\(index + 1). ")
                            .fontWeight(.bold)
                            
                        Text(element.workDescription ?? "")
                            .font(.body)
                        
                        Spacer()
                        
                        Image(systemName: element.isCompleted ? "checkmark.seal.fill" : "checkmark.seal")
                            .foregroundColor(element.isCompleted ? Color.green : Color.red)
                            .onTapGesture {
                                vm.markItemCompleted(entity: element)
                            }
                    }
                    .onLongPressGesture(minimumDuration: 0.5) {
                        selectedEntity = element
                        selectedRowText = element.workDescription ?? ""
                        withAnimation {
                            showUpdateDialog = true
                        }
                    }
                    
                }
                .onDelete(perform: vm.deleteItem)
            }
        }
    }
    
}

struct ToDoListView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListView()
    }
}

struct UpdateDialogView: View {
    
    var selectedEntity: ListEntity
    @State var text: String
    @ObservedObject var vm: CoreDataViewModel
    @Binding var showUpdateDialog: Bool
    
    var body: some View {
        VStack {
            Text("Update")
                .underline()
                .font(.title)
                .bold()
                .foregroundColor(.brown)
            
            TextField("", text: $text)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.4))
                )
                .padding()
            
            Button {
                if !text.isEmpty {
                    vm.updateItem(text: text, entity: selectedEntity)
                }
                showUpdateDialog = false
            } label: {
                Text("Update Description")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.brown)
                    .cornerRadius(12)
            }

        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.brown.opacity(0.4))
        )
        .padding()
    }
}
