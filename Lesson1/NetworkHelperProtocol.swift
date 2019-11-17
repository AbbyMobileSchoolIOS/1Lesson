// Copyright (C) ABBYY (BIT Software), 1993-2017. All rights reserved.
// Описание: Протокол для работы с сервером на основе ресурсов

import Foundation

public typealias OperationCompletion<A> = Result<A, Error>

/// Протокол для работы с сервером на основе ресурсов
public protocol NetworkHelperProtocol: class {
	/// Метод загрузки данных на основе Resource(ресурс далее)
	///
	/// - Parameters:
	///   - resource: ресурс
	///   - completion: результат выполнения операции
	/// - Returns: объект отмены операции загрузки данных
	func load<A>(resource: Resource<A>, completion: @escaping (OperationCompletion<A>) -> ()) -> Cancellation?
	
	/// Метод загрузки данных на основе Resource(ресурс далее) с возможностью повторения
	///
	/// - Parameters:
	///   - resource: ресурс
	///   - repeatTime: количество повторов
	///   - delayTime: задержка между повторами
	///   - completion: результат выполнения операции
	/// - Returns: объект отмены операции загрузки данных
	func load<A>(resource: Resource<A>, repeatTime: Int, delayTime: TimeInterval, completion: @escaping (OperationCompletion<A>) -> ()) -> Cancellation?
}

// MARK: - Реализация методов по умолчанию
extension NetworkHelperProtocol {
	// Реализация метода загрузки с повторениями(*)
	public func load<A>(resource: Resource<A>, repeatTime: Int, delayTime: TimeInterval, completion: @escaping (OperationCompletion<A>) -> ()) -> Cancellation? {
        let cancellation = RequestCancelContainer()
        var count = 0
        
        while repeatTime > count && !cancellation.isCanceled {
            cancellation.requestCancel = self.load(resource: resource, completion: { c in
                switch c {
                case .failure:
                    //if is last cycle
                    if(count + 1 == repeatTime) { completion(c) }
                case .success:
                    completion(c)
                }
            })
            count = count + 1
        }
        
        return cancellation
	}
}
