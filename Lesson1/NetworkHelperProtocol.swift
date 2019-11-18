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
     //Реализация метода загрузки с повторениями(*)
    public func load<A>(resource: Resource<A>, repeatTime: Int, delayTime: TimeInterval, completion: @escaping (OperationCompletion<A>) -> ()) -> Cancellation? {
        
        for index in 0..<repeatTime {
                Timer.scheduledTimer(withTimeInterval: delayTime, repeats: false) { timer in
                switch resource.method {
                case .get:
                    print("get")
                case .post(let data):
                    do {
                        let result = try resource.parse(data)
                        completion(.success(result))
                        break
                    } catch let error {
                        if index == repeatTime - 1 {
                            completion(.failure(error))
                        }
                        
                    }
                }
            }
        }
       
        return nil
    }
}
