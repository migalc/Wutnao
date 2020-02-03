//
//  WNVideoCameraViewModel.swift
//  Wutnao
//
//  Created by Miguel Alcântara on 05/02/2020.
//  Copyright © 2020 Alcantech. All rights reserved.
//

// MARK: - Imports

import Foundation
import AVFoundation
import Shank

// MARK: - View Model

class WNVideoCameraViewModel: NSObject, WNBaseViewModel {
    
    // MARK: - Properties
    
    @Published var isCameraOn: Bool = false
    @Inject private var _mlManager: WNMLManagerProtocol
    
    // MARK: - Initializers
    
    init(isCameraOn: Bool) {
        self.isCameraOn = isCameraOn
    }
    
}

// MARK: - LegacyVideoCamera Delegate

extension WNVideoCameraViewModel: LegacyVideoCameraDelegate {
    
    func videoCapture(buffer: CMSampleBuffer?, bounds: CGRect) {
        _mlManager.translateText(from: buffer, bounds: bounds)
    }
    
}
