//
//  RowBook.swift
//  CoreDataBasics
//
//  Created by Hugo Silva on 13/10/22.
//

import SwiftUI

struct RowBook: View {
   let book: Books

   var body: some View {
      HStack(alignment: .top) {
         Image(uiImage: book.showThumbnail)
            .resizable()
            .scaledToFit()
            .frame(width: 80, height: 100)
            .cornerRadius(10)
         VStack(alignment: .leading, spacing: 2) {
            Text(book.showTitle)
               .bold()
            Text(book.showAuthor)
            Text(book.showYear)
               .font(.caption)
            Spacer()
         }.padding(.top, 5)
         Spacer()
      }.padding(.top, 10)
   }
}
