//
//  WNTextTranslator+Combine.swift
//  Wutnao
//
//  Created by Miguel Alcântara on 06/02/2020.
//  Copyright © 2020 Alcantech. All rights reserved.
//

// MARK: Imports

import Foundation
import Combine

// MARK: Subscription

/// A custom subscription to capture UIControl target events.
final class WNTextTranslatorSubscription<SubscriberType: Subscriber,
    Translator: WNTextTranslator>: Subscription where SubscriberType.Input == Translator {
    private var _subscriber: SubscriberType?
    private let _textTranslator: Translator
    private var _pathList: DetectedPathList

    init(subscriber: SubscriberType, textTranslator: Translator, pathList: DetectedPathList) {
        _subscriber = subscriber
        _textTranslator = textTranslator
        _pathList = pathList
    }

    func request(_ demand: Subscribers.Demand) {
        _textTranslator.translateTexts(for: _pathList.textList) { [weak self] modelList in
            guard let self = self else { return }
            _ = self._subscriber?.receive(self._textTranslator)
        }
    }

    func cancel() {
        _subscriber = nil
    }
    
}

// MARK: Publisher

struct WNTextTranslatorPublisher<Translator: WNTextTranslator>: Publisher {

    typealias Output = Translator
    typealias Failure = Never

    private let _translator: Output
    private let _pathList: DetectedPathList

    init(translator: Output, pathList: DetectedPathList) {
        _translator = translator
        _pathList = pathList
    }
    
    func receive<S>(subscriber: S) where S : Subscriber,
        S.Failure == WNTextTranslatorPublisher.Failure,
        S.Input == WNTextTranslatorPublisher.Output {
        let subscription = WNTextTranslatorSubscription(subscriber: subscriber,
                                                        textTranslator: _translator,
                                                        pathList: _pathList)
        
        subscriber.receive(subscription: subscription)
    }
}

// MARK: TextTranslator Combinable

extension WNTextTranslatorProtocol {
    private func publisher(for pathList: DetectedPathList) -> WNTextTranslatorPublisher<WNTextTranslator> {
        return WNTextTranslatorPublisher(translator: self as! WNTextTranslator,
                                         pathList: pathList)
    }
    
    func translateWords(for pathList: DetectedPathList) -> AnyPublisher<[DetectedPath], Never> {
        publisher(for: pathList)
            .receive(on: DispatchQueue.main)
            .map { pathList.updateTranslatedTexts(with: $0.translatedTexts) }
            .eraseToAnyPublisher()
    }
    
}
