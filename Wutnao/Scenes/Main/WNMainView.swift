//
//  WNMainView.swift
//  Wutnao
//
//  Created by Miguel Alcântara on 03/02/2020.
//  Copyright © 2020 Alcantech. All rights reserved.
//

// MARK: - Imports

import SwiftUI

// MARK: - Main View

struct WNMainView: View {
    
    // MARK: - View Model
    
    @ObservedObject var viewModel: WNMainViewViewModel
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            videoCamera
            textDetectionBoxView
            if viewModel.isLoading {
                loadingView
            }
        }
    }
    
    var loadingView: some View {
        GeometryReader { proxy in
            WNLoading(viewModel: WNLoadingViewModel(isLoading: self.viewModel.isLoading, loadingMessage: "Downloading Models..."))
                .frame(width: proxy.size.width, height: proxy.size.height)
        }
    }
    
    // MARK: - Video Camera
    
    var videoCamera: some View {
        WNVideoCamera(viewModel: WNVideoCameraViewModel(isCameraOn: viewModel.isOn))
            .onAppear { self.viewModel.isOn = true }
            .onDisappear { self.viewModel.isOn = false }
    }
    
    // MARK: - Detections
    
    var textDetectionBoxView: some View {
        WNDetectionsDrawingView(viewModel: WNDetectionsDrawingViewViewModel())
    }
    
}

struct WNMainView_Previews: PreviewProvider {
    static var previews: some View {
        WNMainView(viewModel: WNMainViewViewModel())
    }
}
