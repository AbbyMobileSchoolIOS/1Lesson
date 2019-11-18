// Copyright (C) ABBYY (BIT Software), 1993-2019 . All rights reserved.
// Автор: Sergey Kharchenko
// Описание: @warning добавить описание
//Структура описывает данные которые пришли из интернета


import Foundation

struct JSONObject: Codable {
    let name: String
    let id: Int
  
    enum CodingKeys: String, CodingKey {
      case name = "Name"
      case id
    }

}
