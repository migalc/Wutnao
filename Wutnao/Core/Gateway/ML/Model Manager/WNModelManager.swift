//
//  WNModelManager.swift
//  Wutnao
//
//  Created by Miguel Alcântara on 06/02/2020.
//  Copyright © 2020 Alcantech. All rights reserved.
//

// MARK: Imports

import Foundation
import FirebaseMLNLTranslate
import Combine

// MARK: Typealias

typealias WNModelManagerDownloadModelCompletionType = ((Bool) -> Void)
typealias WNModelManagerDeleteModelCompletionType = ((Error?) -> Void)

// MARK: Protocols

protocol WNModelManagerProtocol: Combinable {
    func checkDownloadedModel(for language: TranslateLanguage) -> Bool
    func checkAndDownloadIfNeeded(for language: TranslateLanguage, completion: WNModelManagerDownloadModelCompletionType?)
    func removeDownloadedModel(for language: TranslateLanguage, completion: WNModelManagerDeleteModelCompletionType?)
}

// MARK: Text Translator Implementation

class WNModelManager: NSObject, WNModelManagerProtocol {
    
    deinit {
        _progressObserver.invalidate()
        _progressObserver = nil
    }
    
    // MARK: Singleton
    
    static let current: WNModelManager = WNModelManager()
    
    // MARK: Properties
    
    private lazy var _modelManager: ModelManager = ModelManager.modelManager()
    private var _progressObserver: NSKeyValueObservation!
    
    // MARK: Functions
    
    func checkDownloadedModel(for language: TranslateLanguage) -> Bool {
        _modelManager.downloadedTranslateModels.contains(where: { $0.language == language })
    }
        
    func checkAndDownloadIfNeeded(for language: TranslateLanguage, completion: WNModelManagerDownloadModelCompletionType?) {
        guard !checkDownloadedModel(for: language) else {
            completion?(true)
            return
        }
        
        let progress = _modelManager.download(TranslateRemoteModel.translateRemoteModel(language: language),
                               conditions: ModelDownloadConditions(allowsCellularAccess: false,
            allowsBackgroundDownloading: false))
        
        _progressObserver = progress.observe(\.fractionCompleted, changeHandler: { (progress, value) in
            guard progress.fractionCompleted == 1 else { return }
            completion?(true)
        })
        
    }
            
    func removeDownloadedModel(for language: TranslateLanguage, completion: WNModelManagerDeleteModelCompletionType?) {
        guard let model = _modelManager.downloadedTranslateModels.first(where: { $0.language == language }) else { return }
        _modelManager.deleteDownloadedModel(model, completion: { completion?($0) })
    }
    
    // MARK: Combine functions
    
    
    func checkDownloadedModel(for language: TranslateLanguage) -> AnyPublisher<Bool, Never> {
        Just<Bool>(checkDownloadedModel(for: language))
            .eraseToAnyPublisher()
    }
    
}
