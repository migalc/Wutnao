//
//  WNActivityIndicatorViewModel.swift
//  Wutnao
//
//  Created by Miguel Alcântara on 06/02/2020.
//  Copyright © 2020 Alcantech. All rights reserved.
//

// MARK: - Imports

import Foundation

// MARK: - View Model Implementation

class WNActivityIndicatorViewModel: WNBaseViewModel {
    
    // MARK: - Properties
    
    @Published var isLoading: Bool = false
    
    // MARK: - Initializers
    
    init(isLoading: Bool) {
        self.isLoading = isLoading
    }
    
}
