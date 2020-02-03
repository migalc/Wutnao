//
//  TextTranslationModel.swift
//  Wutnao
//
//  Created by Miguel Alcântara on 05/02/2020.
//  Copyright © 2020 Alcantech. All rights reserved.
//

// MARK: - Imports

import Foundation

// MARK: - Model

struct TextTranslationModel: WNObject {
    
    // MARK: - Properties
    
    let originText: String
    var translatedText: String
    
    // MARK: - Computed variables
    
    var modelId: String { originText }
}
