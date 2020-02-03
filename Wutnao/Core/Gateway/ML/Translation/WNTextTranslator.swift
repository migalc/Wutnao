//
//  TextTranslator.swift
//  Wutnao
//
//  Created by Miguel Alcântara on 04/02/2020.
//  Copyright © 2020 Alcantech. All rights reserved.
//

// MARK: Imports

import Foundation
import FirebaseMLNLTranslate

// MARK: Typealias

typealias WNTextTranslatorTranslateTextsCompletionType = (([TextTranslationModel]) -> Void)

// MARK: Protocols

protocol WNTextTranslatorProtocol: Combinable {
    func translateTexts(for textList: [String], completionHandler: WNTextTranslatorTranslateTextsCompletionType?)
}

// MARK: Text Translator Implementation

class WNTextTranslator: NSObject, WNTextTranslatorProtocol {
    
    // MARK: Singleton
    
    static let current: WNTextTranslator = WNTextTranslator()
    
    // MARK: Properties
    
    var translatedTexts: [TextTranslationModel] = []
    
    private lazy var _translator: Translator = {
        let options = TranslatorOptions(sourceLanguage: .en, targetLanguage: .pt)
        return NaturalLanguage.naturalLanguage().translator(options: options)
    }()
    
    // MARK: Functions
    
    func translateTexts(for textList: [String], completionHandler: WNTextTranslatorTranslateTextsCompletionType?) {
        
        let group = DispatchGroup()
        var translationModelList = [TextTranslationModel]()
        
        textList.forEach { originalText in
            group.enter()
            translateText(for: originalText, completionHandler: { translatedText in
                translationModelList.append(TextTranslationModel(originText: originalText, translatedText: translatedText))
                group.leave()
            })
        }
        
        group.notify(queue: .main) {
            self.translatedTexts = translationModelList
            completionHandler?(translationModelList)
        }
    }
    
    // MARK: Private functions
    
    private func translateText(for text: String, languages: [String] = [], completionHandler: ((String) -> Void)?) {
        
        _translator.downloadModelIfNeeded(with: ModelDownloadConditions(allowsCellularAccess: false, allowsBackgroundDownloading: false), completion: { [weak self] (error) in
            guard let self = self else { return }
            guard error == nil else {
                print(error)
                return
            }
            self._translator.translate(text) { (translatedText, error) in
                guard error == nil else {
                    print(error)
                    return
                }
                completionHandler?(translatedText ?? "none")
            }
        })
    }
    
}
