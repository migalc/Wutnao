//
//  WNDetectionsDrawingView.swift
//  Wutnao
//
//  Created by Miguel Alcântara on 04/02/2020.
//  Copyright © 2020 Alcantech. All rights reserved.
//

// MARK: - Imports

import SwiftUI

// MARK: - Detection Drawing View

struct WNDetectionsDrawingView: View {
    
    // MARK: - View Model
    
    @ObservedObject var viewModel: WNDetectionsDrawingViewViewModel
    
    // MARK: - Body
    
    var body: some View {
        ForEach<[DetectedPath], String, WNDetectionPathView>(viewModel.paths, id: \.id) {
            WNDetectionPathView(viewModel: WNDetectionPathViewViewModel(detectedPath: $0))
        }
    }
    
}

struct WNDetectionsDrawingView_Previews: PreviewProvider {
    static var previews: some View {
        WNDetectionsDrawingView(viewModel: WNDetectionsDrawingViewViewModel())
    }
}
