//
//  CoreDataBasicsApp.swift
//  CoreDataBasics
//
//  Created by Hugo Silva on 06/10/22.
//

import SwiftUI

@main
struct CoreDataBasicsApp: App {
   
   @StateObject var appData = ApplicationData()

   var body: some Scene {
      WindowGroup {
         ContentView()
         // 2) Depois que temos o container, precisamos pegar o contexto e compartilhar com as views, para que elas possam adicionar, ler ou remover objetos da Persistent Store. O environment oferece o managedObjectContext para esse propósito, e para injetar a referência para o contexto no environment do app, fazemos o seguinte:
            .environmentObject(appData)
            .environment(\.managedObjectContext, appData.container.viewContext)
         
         // Dessa forma o model é inicializado e injetado no environment. Para prover acesso ao Context da core data, pegamos uma referência da propriedade viewContext do NSPersistentContainer e então a atribuímos à propriedade managedObjectContext do environment. De agora em diante, as views podem acessar o contexto do core data a partir do environment para carregar, adicionar ou remover objetos da persistent store.
      }
   }
}
