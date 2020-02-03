//
//  WNMainViewViewModel.swift
//  Wutnao
//
//  Created by Miguel Alcântara on 05/02/2020.
//  Copyright © 2020 Alcantech. All rights reserved.
//

// MARK: - Imports

import Foundation
import Shank
import Combine

// MARK: - View Model

class WNMainViewViewModel: WNBaseViewModel {
    
    // MARK: - Properties
    
    @Published var isOn: Bool = true
    @Published var isLoading: Bool = true
    
    @Inject private var _frameManager: WNMLManagerProtocol
    
    private var _disposables = Set<AnyCancellable>()
    
    init() {
        Publishers.Zip(_frameManager.checkAndDownloadModelIfNeeded(for: .en), _frameManager.checkAndDownloadModelIfNeeded(for: .pt))
            .map { $0.0 && $0.1 }
            .sink(receiveValue: { self.isLoading = !$0 })
            .store(in: &_disposables)
        
    }
    
}
