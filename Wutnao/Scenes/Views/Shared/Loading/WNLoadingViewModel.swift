//
//  WNLoadingViewModel.swift
//  Wutnao
//
//  Created by Miguel Alcântara on 06/02/2020.
//  Copyright © 2020 Alcantech. All rights reserved.
//

// MARK: - Imports

import Foundation

// MARK: - View Model Implementation

class WNLoadingViewModel: WNBaseViewModel {
    
    // MARK: - Properties
    
    @Published var isLoading: Bool = false
    @Published var loadingMessage: String = ""
    
    // MARK: - Initializers
    
    init(isLoading: Bool, loadingMessage: String) {
        self.isLoading = isLoading
        self.loadingMessage = loadingMessage
    }
    
}
