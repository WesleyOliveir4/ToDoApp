
import SwiftUI
import CoreData

struct ToDoView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Items.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Items.descricao, ascending: true)]
    ) private var items: FetchedResults<Items>
    @State private var newItemDescription: String = ""

    var body: some View {
        VStack {
            HStack {
                TextField("New item", text: $newItemDescription)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: addItem) {
                    Image(systemName: "plus")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
                .padding()
            }

            List {
                ForEach(items) { item in
                    HStack {
                        Text(item.descricao ?? "")
                        Spacer()
                        Button(action: {
                            toggleCompletion(for: item)
                        }) {
                            Image(systemName: item.isCompleted ? "checkmark.square.fill" : "square")
                                .foregroundColor(item.isCompleted ? .green : .primary)
                        }
                        .buttonStyle(BorderlessButtonStyle())

                        Button(action: {
                            deleteItem(item)
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
                .onDelete(perform: deleteItems)
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private func addItem() {
        guard !newItemDescription.isEmpty else { return }
        let newItem = Items(context: viewContext)
        newItem.id = UUID()
        newItem.descricao = newItemDescription
        newItem.isCompleted = false

        do {
            try viewContext.save()
            newItemDescription = ""
        } catch {
            print("Failed to save item: \(error.localizedDescription)")
        }
    }

    private func toggleCompletion(for item: Items) {
        item.isCompleted.toggle()
        do {
            try viewContext.save()
        } catch {
            print("Failed to update item: \(error.localizedDescription)")
        }
    }

    private func deleteItem(_ item: Items) {
        viewContext.delete(item)
        do {
            try viewContext.save()
        } catch {
            print("Failed to delete item: \(error.localizedDescription)")
        }
    }

    private func deleteItems(offsets: IndexSet) {
        offsets.map { items[$0] }.forEach(viewContext.delete)
        do {
            try viewContext.save()
        } catch {
            print("Failed to delete items: \(error.localizedDescription)")
        }
    }
}

struct ToDoView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
