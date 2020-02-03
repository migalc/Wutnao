//
//  MLManager.swift
//  Wutnao
//
//  Created by Miguel Alcântara on 05/02/2020.
//  Copyright © 2020 Alcantech. All rights reserved.
//

// MARK: - Imports

import Foundation
import AVFoundation
import UIKit
import Combine
import Shank
import FirebaseMLNLTranslate

// MARK: - Protocols

protocol WNMLManagerProtocol {
    func translateText(from imageBuffer: CMSampleBuffer?, bounds: CGRect)
    func checkAndDownloadModelIfNeeded(for language: TranslateLanguage) -> AnyPublisher<Bool, Never>
    
    var detectionPaths: AnyPublisher<[DetectedPath], Never> { get }
}

// MARK: - ML Manager Implementation

class WNMLManager: NSObject, WNMLManagerProtocol {
    
    // MARK: - Singleton
    
    static let current: WNMLManager = WNMLManager()
    
    // MARK: - Properties
    
    @Inject private var _textRecognizer: WNTextRecognizerProtocol
    @Inject private var _textTranslator: WNTextTranslatorProtocol
    @Inject private var _modelManager: WNModelManagerProtocol
    private lazy var _disposables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Combine Subjects
    
    private var _detectionPathsSubject: PassthroughSubject<[DetectedPath], Never> = PassthroughSubject()
    
    var detectionPaths: AnyPublisher<[DetectedPath], Never> {
        _detectionPathsSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Protocol Functions
    
    func translateText(from imageBuffer: CMSampleBuffer?, bounds: CGRect = UIScreen.main.bounds) {
        guard let buffer = imageBuffer,
            let uiImage = buffer.uiImage,
            let scaledImage = uiImage.resizeImage(image: uiImage, newSize: bounds.size),
            let rotatedImage = scaledImage.rotatedImage(deviceOrientation: UIDevice.current.orientation)
            else { return }
        
        _textRecognizer.detectPaths(for: rotatedImage)
            .flatMap(maxPublishers: .max(1)) { [unowned self] list in self._textTranslator.translateWords(for: list) }
            .sink(receiveValue: { [unowned self] in self._detectionPathsSubject.send($0) })
            .store(in: &_disposables)
    }
    
    func checkAndDownloadModelIfNeeded(for language: TranslateLanguage) -> AnyPublisher<Bool, Never> {
        return _modelManager.checkAndDownloadModel(for: language)
    }
}
