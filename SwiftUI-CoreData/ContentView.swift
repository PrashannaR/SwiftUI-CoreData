//
//  ContentView.swift
//  SwiftUI-CoreData
//
//  Created by Prashanna Rajbhandari on 22/03/2023.
//

import CoreData
import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State var TextFieldText: String = ""

    @FetchRequest(
        entity: FruitEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \FruitEntity.name, ascending: true)]
    )
    var fruits: FetchedResults<FruitEntity>

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Add Fruit Here", text: $TextFieldText)
                    .padding()

                Button {
                    addItem()
                } label: {
                    Text("Add Fruit")
                        .padding()
                        .foregroundColor(.white)
                        .background(.blue)
                        .cornerRadius(10)
                }

                List {
                    ForEach(fruits) { fruit in
                        Text(fruit.name ?? "")
                            .onTapGesture {
                                updateItems(fruit: fruit)
                            }
                    }
                    .onDelete(perform: deleteItems)
                }.listStyle(PlainListStyle())
            }

            .navigationTitle("Fruits")
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newFruit = FruitEntity(context: viewContext)
            newFruit.name = TextFieldText
            saveItems()
            TextFieldText = ""
        }
    }
    
    private func updateItems(fruit:FruitEntity){
        withAnimation{
            let currName = fruit.name ?? ""
            let newName =  currName + "!"
            fruit.name = newName
            
            
            saveItems()
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            guard let index = offsets.first else { return }
            let fruitEntity = fruits[index]
            viewContext.delete(fruitEntity)

            saveItems()
        }
    }

    private func saveItems() {
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
