// Copyright (C) ABBYY (BIT Software), 1993-2018. All rights reserved.
// Описание: Расширения для протокола Resource в котором добавлена связь с ObjectMapper-om

import Foundation

extension Resource where ResourceType: Decodable {
	public init(url: URL, method: HttpMethod<Data> = .get, headers: [String : String]?) {
		//#error("Реализовать инициализатор для Decodable(парсинг ответа от сервера)")
        self.url = url
        self.headers = headers
        self.method = method
        // как-то объявить парс
	}
}
