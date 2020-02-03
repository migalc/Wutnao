//
//  WNVideoCamera.swift
//  Wutnao
//
//  Created by Miguel Alcântara on 03/02/2020.
//  Copyright © 2020 Alcantech. All rights reserved.
//

// MARK: - Imports

import SwiftUI

// MARK: - SwiftUI Video Camera

struct WNVideoCamera: UIViewRepresentable {
    
    // MARK: - View Model
    
    @ObservedObject var viewModel: WNVideoCameraViewModel
    
    /// Creates a `UIView` instance to be presented.
    func makeUIView(context: Context) -> UIView {
        
        print(#function)
        let bgView = UIView()
        bgView.backgroundColor = .blue
        
        let videoCamera = LegacyVideoCamera(parentView: bgView)
        videoCamera.prepareCamera()
        videoCamera.delegate = viewModel
        
        bgView.addSubview(videoCamera)
        videoCamera.translatesAutoresizingMaskIntoConstraints = false
        videoCamera.centerXAnchor.constraint(equalTo: bgView.centerXAnchor).isActive = true
        videoCamera.centerYAnchor.constraint(equalTo: bgView.centerYAnchor).isActive = true
        videoCamera.widthAnchor.constraint(equalTo: bgView.widthAnchor).isActive = true
        videoCamera.heightAnchor.constraint(equalTo: bgView.heightAnchor).isActive = true
        return bgView
    }

    /// Updates the presented `UIView` (and coordinator) to the latest
    /// configuration.
    func updateUIView(_ uiView: UIView, context: Context) {
        let videoCamera = uiView.subviews.filter { $0 is LegacyVideoCamera }.first as? LegacyVideoCameraProtocol
        
        if viewModel.isCameraOn { videoCamera?.startReading() }
        else { videoCamera?.stopReading() }
    }
    
}
