//
//  WNDetectionsDrawingViewViewModel.swift
//  Wutnao
//
//  Created by Miguel Alcântara on 05/02/2020.
//  Copyright © 2020 Alcantech. All rights reserved.
//

// MARK: - Imports

import Foundation
import Shank
import Combine

// MARK: - Class Implementation

class WNDetectionsDrawingViewViewModel: WNBaseViewModel {
    
    // MARK: - Properties
    
    @Published var paths: [DetectedPath] = []
    private var _disposables = Set<AnyCancellable>()
    @Inject private var _mlManager: WNMLManagerProtocol
    
    // MARK: - Initializers
    
    init() {
        _mlManager.detectionPaths
            .sink(receiveValue: { self.paths = $0 })
            .store(in: &_disposables)
    }
    
}
