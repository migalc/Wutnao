//
//  TextRecognizer.swift
//  Wutnao
//
//  Created by Miguel Alcântara on 03/02/2020.
//  Copyright © 2020 Alcantech. All rights reserved.
//

// MARK: Imports

import Foundation
import Vision
import FirebaseMLVision
import Combine
import Shank

// MARK: Typealias

typealias WNTextTranslationCompletionHandler = ((DetectedPathList) -> Void)

// MARK: Protocols

protocol WNTextRecognizerProtocol: Combinable {
    func translateText(for image: UIImage, completionHandler: WNTextTranslationCompletionHandler?)
}

// MARK: Class Implementation

class WNTextRecognizer: NSObject, WNTextRecognizerProtocol {
    
    // MARK: Singleton
    
    static let current: WNTextRecognizer = WNTextRecognizer()
    
    // MARK: Properties
    
    private lazy var _firebaseTextRecognitionRequest = Vision.vision().onDeviceTextRecognizer()
    var pathList: DetectedPathList = DetectedPathList()
    
    // MARK: Functions
    
    func translateText(for image: UIImage, completionHandler: WNTextTranslationCompletionHandler?) {
        _firebaseTextRecognitionRequest.process(VisionImage(image: image)) { [weak self] (visionText, error) in
            guard let self = self else { return }
            guard error == nil else {
                print(error)
                return
            }
            
            let detectedPaths = visionText?.blocks.flatMap {
                $0.lines.flatMap {
                    $0.elements.flatMap {
                        DetectedPath(path: $0.pathRect,
                                     id: $0.text,
                                     text: $0.text)
                    }
                }
            } ?? []
            
            self.pathList.updateDetectedPaths(with: detectedPaths)
            completionHandler?(self.pathList)
        }
    }
    
}

