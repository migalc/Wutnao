//
//  WNDetectionPathViewViewModel.swift
//  Wutnao
//
//  Created by Miguel Alcântara on 05/02/2020.
//  Copyright © 2020 Alcantech. All rights reserved.
//

// MARK: - Imports

import Foundation
import UIKit

// MARK: - View Model Implementation

class WNDetectionPathViewViewModel: WNBaseViewModel {
    
    // MARK: - Properties
    
    private let _detectedPath: DetectedPath
    
    // MARK: - Initializers
    
    init(detectedPath: DetectedPath) {
        _detectedPath = detectedPath
    }
    
    // MARK: - Computed variables
    
    var path: CGRect { _detectedPath.path }
    var textOrigin: CGPoint { path.origin.applying(.init(translationX: path.width / 2, y: path.height / 2))  }
    var text: String { _detectedPath.text }
    
}
