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
    public func load<A>(resource: Resource<A>, repeatTime: Int, delayTime: TimeInterval,
                        completion: @escaping (OperationCompletion<A>) -> ()) -> Cancellation? {
        
        let CancellationContainer = RequestCancelContainer()
        var attemptsLeft = repeatTime
        Timer.scheduledTimer(withTimeInterval: delayTime, repeats: true) { timer in
            attemptsLeft -= 1 // Повторяем пока не кончатся попытки
            CancellationContainer.requestCancel = self.load(resource: resource, completion: { result in
                switch result {
                case .success:
                    timer.invalidate()
                    completion(result)
                case .failure:
                    if attemptsLeft == 0 {
                        timer.invalidate()
                        completion(result) // Можно ли заменить комплишн методом в RequestCancelContainer принимающим на вход result?
                        // Было бы лучше убраться из метода @escaping таким образом выключив таймер (не возвращать Cancelation)?
                    }
                }
            })
        }
        return CancellationContainer
    }
}
