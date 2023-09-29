# SBB ML iOS

[![Generic badge](https://img.shields.io/badge/platform-iOS%2014+-blue.svg)](https://www.apple.com/ios/ios-15/)
[![Generic badge](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![GPLv3 license](https://img.shields.io/badge/License-MIT-blue.svg)](https://spdx.org/licenses/MIT.html)

This framework simplifies the integration of SBB generated Core ML Object Detection models into iOS Apps using Combine. It displays a CameraStream Preview in your SwiftUI View and publishes detected objects, which you can then draw over the CameraStream preview or use for further app logic.

![SBB ML in use](SBBML/Documentation.docc/Resources/SBBML_iPhone13Pro.png)

## Maintainers
- [Jeanne Fleury](mailto:jeanne.fleury@sbb.ch)

## Supported platforms
<div id="supported_platforms">
  <img src="https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=apple&logoColor=white" alt="iOS">
</div>

## Precondition

### Minimum supported iOS Version

* iOS 14.0

## Setup

Add the SBBML package to your project using Swift Package Manager.

For HTTPS:
```
https://github.com/SchweizerischeBundesbahnen/mobile-ios-ml.git
```

For SSH:
```
ssh://git@github.com:SchweizerischeBundesbahnen/mobile-ios-ml.git
```

## Usage
### Documentation

* DocC documentation can be created in XCode by selecting "Product" -> "Build Documentation".


### Minimal example
Create a ViewModel that will take care of declaring the ObjectDetectionService, and will publish the detected objects.

```
class ExampleViewModel: ObservableObject {

	// Published objects (e.g. we can have the detected objects, the errors and the inference time)
	@Published var detectedObjects: [DetectedObject]?
	@Published var objectDetectionError: ObjectDetectionError?
	@Published var currentObjectDetectionInferenceTime: TimeInterval = 0
    
    // Declare the ObjectDetectionService and its configuration
	var objectDetectionServiceConfiguration: ObjectDetectionServiceConfiguration
	var objectDetectionService: ObjectDetectionService
	
	// Subscriptions
	private var detectedObjectsSubscription: AnyCancellable!
	private var errorSubscription: AnyCancellable!
	private var currentObjectDetectionInferenceTimeSubscription: AnyCancellable!
   
   init() {
   		// Initialize service
   		self.objectDetectionServiceConfiguration = objectDetectionServiceConfiguration
  		self.objectDetectionService = ObjectDetectionService(modelFileName: MODEL_FILE_NAME, configuration: objectDetectionServiceConfiguration)
  		
  		// Setup subscriptions
  		let detectedObjectsSubscription = objectDetectionService.detectedObjectsPublisher
			.sink(receiveValue: { [weak self] detectedObjects in
				self?.detectedObjects = detectedObjects
		})
		let errorSubscription = objectDetectionService.errorPublisher
			.sink(receiveValue: { [weak self] objectDetectionError in
				self?.objectDetectionError = objectDetectionError
        })
            
		let currentObjectDetectionInferenceTimeSubscription = objectDetectionService.currentObjectDetectionInferenceTimePublisher
			.sink(receiveValue: { [weak self] inferenceTime in
				self?.currentObjectDetectionInferenceTime = inferenceTime
        }

}
```
The SBBML Lib is composed of the following components (which are typically used in a view model, to deal with the logic):

- **ObjectDetectionService**: the service that publishes the detected objects, errors and metrics.
- **ObjectDetectionServiceConfiguration**: a struct that contains all tunable parameters for the object detection.
- It has three publishers:
	- **detectedObjectsPublisher**: publishes a list of DetectedObject
	- **errorPublisher**: publishes the errors that may occur in the framework
	- **currentObjectDetectionInferenceTimePublisher**: publishes the last inference time

Here is how we would display the camera stream, as well as some more information about the detected objects (e.g. bounding box, inference time).

```
struct ExampleView: View {

@ObservedObject var exampleViewModel: ExampleViewModel

	var body: some View {
		if let error = exampleViewModel.objectDetectionError {
			// Plot an error view
		} else {
			CameraStreamView(objectDetectionService: exampleViewModel.objectDetectionService)
			.overlay(
				ZStack {
					if exampleViewModel.detectedObjects != nil {
						ForEach(exampleViewModel.detectedObjects) { detectedObject in
							// Plot the bounding box
						}
					}
				}
			)
		}
	}
}
```

For the UI, we have the following component:

- **CameraStreamView**: the view that displays the live CameraStream which is also processed for the object detection. Typically, and as shown in the example, you would use .overlay to draw the bounding boxes on top of this view.

## Example
* A more complete sample app SBB ML Demo is included in Xcode project.

## Getting involved

Generally speaking, we are welcoming contributions improving existing UI elements or fixing certain bugs. We will also consider contributions introducing new design elements, but might reject them, if they do not reflect our vision of SBB Design System.

General instructions on _how_ to contribute can be found under [Contributing](Contributing.md).
