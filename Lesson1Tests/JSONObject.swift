// Copyright (C) ABBYY (BIT Software), 1993-2019 . All rights reserved.
// Автор: Sergey Kharchenko
// Описание: @warning добавить описание

import Foundation

fileprivate enum ObjectKeys: String, CodingKey {
    case name = "Name"
    case id = "id"
}

struct JSONObject: Codable { // Как вообще лучше? десериализовывать if let'ами или вот таким образом парсить?
	let name: String
	let id: Int
    
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: ObjectKeys.self)

            self.init(name: try container.decode(String.self, forKey: .name),
                      id: try container.decode(Int.self, forKey: .id))
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: ObjectKeys.self)
            try container.encode(self.id, forKey: .id)
            try container.encode(self.name, forKey: .name)
        }
    }
}
