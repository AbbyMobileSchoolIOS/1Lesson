// Copyright (C) ABBYY (BIT Software), 1993-2018. All rights reserved.
// Описание: Расширения для протокола Resource в котором добавлена связь с ObjectMapper-om

import Foundation

extension Resource where ResourceType: Decodable {
	public init(url: URL, method: HttpMethod<Data> = .get, headers: [String : String]?) {
        self.headers = headers;
        self.url = url;
        self.method = method;
        self.parse = { try JSONDecoder().decode(ResourceType.self, from: $0) }
	}
}
