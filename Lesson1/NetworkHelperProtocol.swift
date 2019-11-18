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
        
        let requestCancelContainer = RequestCancelContainer()
        var repeatTime = repeatTime
        
        let tryLoad = { (timer: Timer ) -> () in
            guard requestCancelContainer.isCanceled != true, repeatTime > 0
                else {
                    let error = NSError(domain:"", code: 400, userInfo:[ NSLocalizedDescriptionKey: "isCanceled==true or repeatTime == 0"])
                    completion(.failure(error))
                    timer.invalidate()
                    return
            }
            
            switch resource.method {
            case .get:
                print("get")
            case .post(let data):
                do {
                    let result = try resource.parse(data)
                    requestCancelContainer.cancel()
                    timer.invalidate()
                    completion(.success(result))
                } catch {
                    repeatTime-=1
                }
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: delayTime, repeats: true, block: tryLoad)
        
        return requestCancelContainer
    }
}
