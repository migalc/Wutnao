//
//  DetectedPath.swift
//  Wutnao
//
//  Created by Miguel Alcântara on 04/02/2020.
//  Copyright © 2020 Alcantech. All rights reserved.
//

// MARK: - Imports

import Foundation
import SwiftUI
import Combine

// MARK: - Detected Path

struct DetectedPath {
    
    // MARK: - Properties
    
    var path: CGRect
    var id: String
    var text: String
    
}

// MARK: - Detected Path List

struct DetectedPathList: WNObject {
    
    // MARK: - Properties
    
    private var _detectedPaths: [DetectedPath] = []
    var translatedPaths: [DetectedPath] = []
    
    // MARK: - Computed variables
    
    var textList: [String] {
        _detectedPaths.map { $0.text }
    }
    
    // MARK: - Functions
    
    mutating func updateDetectedPaths(with pathList: [DetectedPath]) {
        _detectedPaths = pathList
    }
    
    func updateTranslatedTexts(with translationList: [TextTranslationModel]) -> [DetectedPath] {
        _detectedPaths.compactMap { path in
            let translatedModel = translationList.filter { path.id == $0.modelId }.first
            guard let translatedText = translatedModel?.translatedText else { return nil }
            return DetectedPath(path: path.path, id: path.id, text: translatedText)
        }
    }
    
}
