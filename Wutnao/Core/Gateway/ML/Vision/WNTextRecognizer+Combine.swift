//
//  WNTextRecognizer+Combine.swift
//  Wutnao
//
//  Created by Miguel Alcântara on 06/02/2020.
//  Copyright © 2020 Alcantech. All rights reserved.
//

// MARK: Imports

import Foundation
import Combine
import UIKit

// MARK: Subscription

/// A custom subscription to capture UIControl target events.
final class WNTextRecognizerSubscription<SubscriberType: Subscriber,
    Recognizer: WNTextRecognizer>: Subscription where SubscriberType.Input == Recognizer {
    private var subscriber: SubscriberType?
    private let textRecognizer: Recognizer
    private let image: UIImage

    init(subscriber: SubscriberType, textRecognizer: Recognizer, image: UIImage) {
        self.subscriber = subscriber
        self.textRecognizer = textRecognizer
        self.image = image
    }

    func request(_ demand: Subscribers.Demand) {
        textRecognizer.translateText(for: image) { [weak self] paths in
            guard let self = self else { return }
            _ = self.subscriber?.receive(self.textRecognizer)
            self.subscriber?.receive(completion: .finished)
        }
    }

    func cancel() {
        subscriber = nil
    }
    
}

// MARK: Publisher

struct WNTextRecognizerPublisher<Recognizer: WNTextRecognizer>: Publisher {

    typealias Output = Recognizer
    typealias Failure = Never

    let recognizer: Output
    let image: UIImage

    init(recognizer: Output, image: UIImage) {
        self.recognizer = recognizer
        self.image = image
    }
    
    func receive<S>(subscriber: S) where S : Subscriber,
        S.Failure == WNTextRecognizerPublisher.Failure,
        S.Input == WNTextRecognizerPublisher.Output {
        let subscription = WNTextRecognizerSubscription(subscriber: subscriber,
                                                        textRecognizer: recognizer,
                                                        image: image)
        
        subscriber.receive(subscription: subscription)
    }
}

// MARK: TextTranslator Combinable

extension WNTextRecognizerProtocol {
    private func publisher(for image: UIImage) -> WNTextRecognizerPublisher<WNTextRecognizer> {
        return WNTextRecognizerPublisher(recognizer: self as! WNTextRecognizer, image: image)
    }
    
    func detectPaths(for image: UIImage) -> AnyPublisher<DetectedPathList, Never> {
        publisher(for: image)
            .receive(on: DispatchQueue.main)
            .map { $0.pathList }
            .eraseToAnyPublisher()
    }
    
}
