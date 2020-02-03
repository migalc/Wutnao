//
//  WNModelManager+Combine.swift
//  Wutnao
//
//  Created by Miguel Alcântara on 06/02/2020.
//  Copyright © 2020 Alcantech. All rights reserved.
//

// MARK: Imports

import Foundation
import Combine
import FirebaseMLNLTranslate

// MARK: Check and Download Subscription

/// A custom subscription to capture UIControl target events.
final class WNCheckAndDownloadModelSubscription<SubscriberType: Subscriber,
    ModelManager: WNModelManager>: Subscription where SubscriberType.Input == Bool {
    private var _subscriber: SubscriberType?
    private let _modelManager: ModelManager
    private let _language: TranslateLanguage

    init(subscriber: SubscriberType, modelManager: ModelManager, language: TranslateLanguage) {
        _subscriber = subscriber
        _modelManager = modelManager
        _language = language
    }

    func request(_ demand: Subscribers.Demand) {
        _modelManager.checkAndDownloadIfNeeded(for: _language) { [weak self] in
            guard let self = self else { return }
            _ = self._subscriber?.receive($0)
            self._subscriber?.receive(completion: .finished)
        }
    }

    func cancel() {
        _subscriber = nil
    }
    
}

// MARK: Check and Download Publisher

struct WNCheckAndDownloadModelPublisher<ModelManager: WNModelManager>: Publisher {

    typealias Output = Bool
    typealias Failure = Never

    private let _modelManager: ModelManager
    private let _language: TranslateLanguage

    init(modelManager: ModelManager, language: TranslateLanguage) {
        _modelManager = modelManager
        _language = language
    }
    
    func receive<S>(subscriber: S) where S : Subscriber,
        S.Failure == WNCheckAndDownloadModelPublisher.Failure,
        S.Input == WNCheckAndDownloadModelPublisher.Output {
        let subscription = WNCheckAndDownloadModelSubscription(subscriber: subscriber,
                                                               modelManager: _modelManager,
                                                               language: _language)
        
        subscriber.receive(subscription: subscription)
    }
}


/// A custom subscription to capture UIControl target events.
final class WNDeleteModelSubscription<SubscriberType: Subscriber,
    ModelManager: WNModelManager>: Subscription where SubscriberType.Input == Bool {
    private var _subscriber: SubscriberType?
    private let _modelManager: ModelManager
    private let _language: TranslateLanguage

    init(subscriber: SubscriberType, modelManager: ModelManager, language: TranslateLanguage) {
        _subscriber = subscriber
        _modelManager = modelManager
        _language = language
    }

    func request(_ demand: Subscribers.Demand) {
        _modelManager.removeDownloadedModel(for: _language) { [weak self] error in
            guard let self = self else { return }
            _ = self._subscriber?.receive(error == nil)
            self._subscriber?.receive(completion: .finished)
        }
    }

    func cancel() {
        _subscriber = nil
    }
    
}

// MARK: Check and Download Publisher

struct WNDeleteModelPublisher<ModelManager: WNModelManager>: Publisher {

    typealias Output = Bool
    typealias Failure = Never

    private let _modelManager: ModelManager
    private let _language: TranslateLanguage

    init(modelManager: ModelManager, language: TranslateLanguage) {
        _modelManager = modelManager
        _language = language
    }
    
    func receive<S>(subscriber: S) where S : Subscriber,
        S.Failure == WNDeleteModelPublisher.Failure,
        S.Input == WNDeleteModelPublisher.Output {
        let subscription = WNDeleteModelSubscription(subscriber: subscriber,
                                                     modelManager: _modelManager,
                                                     language: _language)
        
        subscriber.receive(subscription: subscription)
    }
}


// MARK: ModelManager Combinable

extension WNModelManagerProtocol {
    
    func checkAndDownloadModel(for language: TranslateLanguage) -> AnyPublisher<Bool, Never> {
        return WNCheckAndDownloadModelPublisher(modelManager: self as! WNModelManager, language: language)
            .eraseToAnyPublisher()
    }
    
    func deleteModel(for language: TranslateLanguage) -> AnyPublisher<Bool, Never> {
        return WNDeleteModelPublisher(modelManager: self as! WNModelManager, language: language)
            .eraseToAnyPublisher()
    }
    

}
