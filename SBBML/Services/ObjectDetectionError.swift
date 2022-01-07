//
// Copyright (C) Schweizerische Bundesbahnen SBB, 2021.
//

import Foundation

/// The type of Error that occured while trying to run SBB ML.
public enum ObjectDetectionError: Swift.Error {
    
    /// The camera input could not be added to the CaptureSession. This typically happens when you select a sessionPreset or cameraInput that is not supported by the current device.
    case inputsAreInvalid
    
    /// The camera output could not be added to the CaptureSessionl.
    case outputsAreInvalid
    
    /// The current device does not seem to feature a camera (e.g. iOS Simulator).
    case noCamerasAvailable
    
    ///The user did not grant access to the device's camera.
    case deniedCameraAuthorization
    
    /// An error occured while trying to convert the captured CMSampleBuffer to a CVImageBuffer.
    case cannotCreateImageBuffer
    
    /// There was no CoreML model found with the specified filename in the app's target.
    case cannotLoadModel
    
    /// A localiced (en/de/fr/it) String describing the Error that occured while trying to run SBB ML.
    public var localizedDescription: String {
        switch self {
        case .inputsAreInvalid, .outputsAreInvalid, .cannotCreateImageBuffer, .cannotLoadModel:
            return "An internal error occured in SBB ML."
        case .noCamerasAvailable:
            return "Your device doesn't seem to have a camera."
        case .deniedCameraAuthorization:
            return "You haven't granted us the authorization to access your camera."
        }
    }
}
