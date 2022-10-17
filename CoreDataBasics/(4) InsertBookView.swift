//
//  InsertBookView.swift
//  CoreDataBasics
//
//  Created by Hugo Silva on 13/10/22.
//

import SwiftUI

struct InsertBookView: View {
   // 4) Toda a interação entre nosso código e a persistent store acontece através do context. Se quisermos acessar, adicionar, remover ou modificar objetos nós temos que fazer isso no context e depois mover essas alterações para a persistent store. A property wrapper @FetchRequest automaticamente pega do environment uma referência do context, mas quando trabalhamos com coredata precisamos pegar a referencia do environment com a property wrapper @Environment e a managedObjectContext. No exemplo abaixo nós a chamamos de dbContext.
   // apesar de ja termos uma referencia do contexto na ContentView, quando trabalhamos com CoreData devemos pegar uma referencia do environment com a propriedade @Environment e a key managedObjectContext.
   @Environment(\.managedObjectContext) var dbContext
   @Environment(\.dismiss) var dismiss
   @State private var selectedAuthor: Authors? = nil
   @State private var inputTitle: String = ""
   @State private var inputYear: String = ""

   var body: some View {
      VStack(spacing: 12) {
         HStack {
            Text("Title:")
            TextField("Insert Title", text: $inputTitle)
               .textFieldStyle(.roundedBorder)
         }
         HStack {
            Text("Year:")
            TextField("Insert Year", text: $inputYear)
               .textFieldStyle(.roundedBorder)
         }
         HStack {
            Text("Author:")
            VStack (alignment: .leading, spacing: 8) {
               Text(selectedAuthor?.name ?? "Undefined")
                  .foregroundColor(selectedAuthor != nil ? .black : .gray)
               NavigationLink {
                  AuthorsView(selected: $selectedAuthor)
               } label: {
                  Text("Select author")
               }
            }
         }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
         Spacer()
      }.padding()
      .navigationBarTitle("Add Book")
      .toolbar {
         ToolbarItem(placement: .navigationBarTrailing) {
            Button("Save") {
               let newTitle = inputTitle.trimmingCharacters(in: .whitespaces)
               let newYear = Int32(inputYear)
               if !newTitle.isEmpty && newYear != nil {
                  Task(priority: .high) {
                     await storeBook(title: newTitle, year: newYear!)
                  }
               }
            }
         }
      }
   }
   func storeBook(title: String, year: Int32) async {
      // já temos uma referencia do contexto a partir de dbContext. A classe NSManagedObjectContext (dbContext) oferece o método perform, que é assíncrono e executa uma função diretamente na thread do context.
      await dbContext.perform {
         // Aqui começa o processo de adição de novos Books. Criamos um novo objeto Books, e adicionamos ao contexto informando no argumento context (dbContext). Depois disso ele estará "disponível" no contexto, então definimos suas propriedades.
         let newBook = Books(context: dbContext)
         newBook.title = title
         newBook.year = year
         newBook.author = selectedAuthor
         newBook.cover = UIImage(named: "bookcover")?.pngData()
         newBook.thumbnail = UIImage(named: "bookthumbnail")?.pngData()
         // Apesar disso, essa mudança não é permanente. Se fecharmos o aplicativo depois de definir as propriedades, o objeto é perdido. Para salvar de as mudanças de fato, precisamos chamar o método save.
         do {
            try dbContext.save()
            dismiss()
         } catch {
            print("Error saving record")
         }
      }
   }
}

struct InsertBookView_Previews: PreviewProvider {
    static var previews: some View {
        InsertBookView()
    }
}
