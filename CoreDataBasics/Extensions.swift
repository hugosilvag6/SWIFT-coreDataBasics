//
//  Extensions.swift
//  CoreDataBasics
//
//  Created by Hugo Silva on 13/10/22.
//
import SwiftUI

extension Books {
   var showTitle: String {
      return title ?? "Undefined"
   }
   var showYear: String {
      return String(year)
   }
   // Aqui incluimos uma propriedade para retornar uma string com o nome do autor, para que as views não precisem ler do objeto author mais, mas direto daqui.
   var showAuthor: String {
      return author?.name ?? "Undefined"
   }
   var showCover: UIImage {
      if let data = cover, let image = UIImage(data: data) {
         return image
      } else {
         return UIImage(named: "nopicture")!
      }
   }
   var showThumbnail: UIImage {
      if let data = thumbnail, let image = UIImage(data: data) {
         return image
      } else {
         return UIImage(named: "nopicture")!
      }
   }
}
extension Authors {
   var showName: String {
      return name ?? "Undefined"
   }
}

