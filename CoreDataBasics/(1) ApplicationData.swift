//
//  CoreData.swift
//  CoreDataBasics
//
//  Created by Hugo Silva on 06/10/22.
//

import SwiftUI
import CoreData

// 1) Depois de criar o Model (xcdatamodel), criamos esse arquivo. Nosso código vai interagir com o context para gerenciar os objetos que queremos acessar, e o Context pede ao Persistent Store para ler ou adicionar novos objetos ao gráfico de objetos.
// O Framework core data oferece classes para criar objetos que representam cada parte dessa Stack.
//
// - NSManagedObjectModel: gerencia o modelo
// - NSPersistentStore: gerencia a Persistent Store
// - NSPersistentStoreCoordinator: é usada para gerenciar todos os Persistent Store disponíveis (um stack core data pode ter múltiplos persistent stores)
// - NSManagedObjectContext: cria e gerencia o contexto que intermedia nosso app e o armazenamento
// Podemos criar esse objeto nós mesmos, mas o container faz isso por nós.
class ApplicationData: ObservableObject {
   
   let container: NSPersistentContainer
   
   // Criamos uma propriedade de tipo chamada preview para criar uma Persistent Store na memória das previews. A closure designada a essa propriedade inicializa a ApplicationData com o valor true. Usada somente para as previews. Não é necessário se não quiser testar nas previews.
   static var preview: ApplicationData = {
      let model = ApplicationData(preview: true)
      return model
   }()
   
   init (preview: Bool = false) {
      
      // Esse inicializador cria um NSPersistentContainer e armazena uma referência ao persistent store, e o argumento name corresponde ao nome do arquivo xcdatamodel
      container = NSPersistentContainer(name: "Stash")
      
      // Para caso de persistent store da preview
      if preview {
         container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
      }
      
      // Configuramos para mergear as mudanças entre o context e o persistent store
      container.viewContext.automaticallyMergesChangesFromParent = true
      
      // Precisamos carregar as persistent stores (por padrão só uma). Como podem demorar a carregar, a classe oferece o método loadPersistentStores para isso. Esse processo carrega as persistent stores e executa uma closure quando o processo acabou. Essa closure recebe dois argumentos: um NSPersistentStoreDescription com a configuração da stack e um optional Error.
      container.loadPersistentStores { storeDescription, error in
         if let error = error {
            fatalError("Unresolved error \(error.localizedDescription)")
         }
      }
   }
}
