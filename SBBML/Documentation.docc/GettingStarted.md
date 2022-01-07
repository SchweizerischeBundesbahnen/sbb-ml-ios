# Getting Started

Add SBBML to your SwiftUI app and show the live camerastream and detected objects directly on a View.

## Overview

This tutorial will guide you step-by-step through the process of integrating SBBML to your SwiftUI app.

After adding the SBB ML framework in your app you need to follow the following steps:
1. Add a camera usage description to your app's target info.plist.
2. Add the desired CoreML model to your app's target.
3. Initialize an instance of ``ObjectDetectionService`` in your app (typically inside a ViewModel).
4. Add a ``CameraStreamView`` in your SwiftUI's view hierarchy and pass the initialized ``ObjectDetectionService`` as init parameter.
5. Subscribe to the desired publishers of the ``ObjectDetectionService`` instance (DetectedObject, error, performance metrics) (typically inside a ViewModel).

![Architecture overview of SBB ML.](SBBML_Architecture_Overview.png)

### Add the library to your project

Start by adding the SBBML package to your project using Swift Package Manager.

For HTTPS:
```
https://github.com/SchweizerischeBundesbahnen/mobile-ios-ml.git
```

For SSH:
```
ssh://git@github.com:SchweizerischeBundesbahnen/mobile-ios-ml.git
```

### Add a camera usage description

Add a camera usage description to your app's target info.plist:

```
<key>NSCameraUsageDescription</key>
<string>SBB ML uses your camera to detect objects around you.</string>
```

### Add the CoreML model

Add the desired CoreML model to your app's target.


### Create an ObjectDetectionService instance

Initialize an instance of ``ObjectDetectionService`` in your app (typically inside a ViewModel) and subscribe to the ``ObjectDetectionService`` publishers:

```swift
class DetectedObjectsViewModel: ObservableObject {
    
    @Published var detectedObjects = [DetectedObject]()
    private var detectedObjectsSubscription: AnyCancellable!

    var objectDetectionService: ObjectDetectionService
    
    init() {
        let modelFileName = "yolov5-iOS-2"  // 
        let configuration = ObjectDetectionServiceConfiguration()     // use custom config if desired
        self.objectDetectionService = ObjectDetectionService(modelFileName: modelFileName, configuration: configuration)
        
        detectedObjectsSubscription = objectDetectionService.detectedObjectsPublisher
            .sink(receiveValue: { [weak self] detectedObjects in
                self?.detectedObjects = detectedObjects
            })
    }
}
```

### Add a CameraStreamView

Add a ``CameraStreamView`` in your SwiftUI's view hierarchy and pass the initialized ``ObjectDetectionService`` as init parameter.

```swift
struct ObjectDetectionView: View {
    
    @ObservedObject var detectedObjectsViewModel: DetectedObjectsViewModel
    
    var body: some View {
        CameraStreamView(objectDetectionService: detectedObjectsViewModel.objectDetectionService)
    }
}
```

### Optionally show BoundingBoxes

If desired, draw BoundingBoxes around detected objects:

```swift
CameraStreamView(objectDetectionService: detectedObjectsViewModel.objectDetectionService)
    .overlay(
        Group {
            ForEach(detectedObjectsViewModel.detectedObjects) { detectedObject in
                Rectangle()
                    .strokeBorder(Color.red, lineWidth: 4)
                    .frame(width: detectedObject.rectInPreviewLayer.width, height: detectedObject.rectInPreviewLayer.height)
                    .position(x: detectedObject.rectInPreviewLayer.midX, y: detectedObject.rectInPreviewLayer.midY)
            }
        }
    )
```

### Configure everything to your use case

SBBML offers a wide range of configuration options (e.g. to set a confidence threshold) using ``ObjectDetectionServiceConfiguration`` which you pass as an init parameter in ``ObjectDetectionService``.
