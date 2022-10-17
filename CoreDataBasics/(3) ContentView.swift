//
//  ContentView.swift
//  CoreDataBasics
//
//  Created by Hugo Silva on 06/10/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
   
   // 3) Pegamos uma referência do contexto (está "injetada" no environment), e instanciamos a classe NSFetchRequest a partir do propery wrapper @FetchRequest. Ela cuida da fetch request e funciona como um @State, atualizando as views sempre que um valor muda
   // Um fetch request carrega todos os objetos disponíveis na persist store. Isso não é um problema quando o número de objetos é pequeno. Porém, uma persist store pode conter milhares de objetos, o que pode consumir muitos recursos. Portanto, em vez da fetch request, o property wrapper @FetchRequest produz um valor do tipo FetchedResults. Essa é uma estrutura que se encarrega de só jogar no contexto os objetos requisitados pela view quando ela precisar.
   //  Essa propriedade produz uma estrutura do tipo FetchedResults, e essa estrutura é genérica. É o ato de tipar essa propriedade que define o tipo de objeto que ela deve fetchear (FetchedResults<Books>).
   @FetchRequest(sortDescriptors: [], predicate: nil) private var listOfBooks: FetchedResults<Books>
   // Para buscas
   @State private var search = ""
   // Para deletar
   @Environment(\.managedObjectContext) var dbContext

   var body: some View {
      NavigationStack {
         List {
             ForEach(listOfBooks) { book in
                NavigationLink {
                   ModifyBookView(book: book)
                } label: {
                   RowBook(book: book)
                      .id(UUID())
                }
            }
             .onDelete { indexes in
                Task(priority: .high) {
                   await deleteBook(indexes: indexes)
                }
             }
         }
         .navigationBarTitle("Books")
         .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
               Menu("Sort") {
                  Button("Sort by Title", action: {
                     let sort = SortDescriptor(\Books.title, order: .forward)
                     listOfBooks.sortDescriptors = [sort]
                  })
                  Button("Sort by Author", action: {
                     let sort = SortDescriptor(\Books.author?.name, order: .forward)
                     listOfBooks.sortDescriptors = [sort]
                  })
                  Button("Sort by Year", action: {
                     let sort = SortDescriptor(\Books.year, order: .forward)
                     listOfBooks.sortDescriptors = [sort]
                  })
               }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
               NavigationLink(destination: InsertBookView(), label: {
                  Image(systemName: "plus")
               })
            }
         }
         .searchable(text: $search, prompt: Text("Insert year"))
         .onChange(of: search) { value in
            if value.count == 4 {
               if let year = Int32(value) {
                  listOfBooks.nsPredicate = NSPredicate(format: "year = %@", NSNumber(value: year))
               }
            } else {
               listOfBooks.nsPredicate = nil
            }
         }
      }
   }
   
   func deleteBook(indexes: IndexSet) async {
      await dbContext.perform {
         for index in indexes {
            dbContext.delete(listOfBooks[index])
         }
         do {
            try dbContext.save()
         } catch {
            print("Error deleting objects")
         }
      }
   }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
          .environment(\.managedObjectContext, ApplicationData.preview.container.viewContext)
    }
}
