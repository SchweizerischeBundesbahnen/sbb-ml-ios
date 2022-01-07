//
// Copyright (C) Schweizerische Bundesbahnen SBB, 2021.
//

import UIKit
import SwiftUI

final class CameraStreamViewController: UIViewController {
    
    var objectDetectionService: ObjectDetectionService
    var previewView: UIView!
    
    init(objectDetectionService: ObjectDetectionService) {
        self.objectDetectionService = objectDetectionService
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoder")
    }
    
    override func viewDidLoad() {
                    
        previewView = UIView()
        previewView.contentMode = UIView.ContentMode.scaleAspectFit
        view.addSubview(previewView)
        
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addPreviewLayer()
        objectDetectionService.requestCameraAuthorization()
        objectDetectionService.updatePreviewLayer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removePreviewLayer()
    }
    
    override func viewDidLayoutSubviews() {
        objectDetectionService.cameraController.updatePreview(for: view.bounds, deviceOrientation:  UIDevice.current.orientation)
        objectDetectionService.updatePreviewLayer()
    }
    
    func addPreviewLayer() {
        objectDetectionService.cameraController.displayPreview(on: self.previewView)
        objectDetectionService.updatePreviewLayer()
    }
    
    func removePreviewLayer() {
        objectDetectionService.cameraController.removePreview()
    }
    
    private func setupConstraints() {
        previewView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: previewView!, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: previewView!, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: previewView!, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: previewView!, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)
        view.addConstraints([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
    }
}
