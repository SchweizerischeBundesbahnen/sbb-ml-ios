# ``SBBML``

Easily integrate SBB ML Models into your SwiftUI app.

## Overview

This framework simplifies the integration of SBB generated CoreML ObjectDetection models into iOS Apps using Combine. It displays a CameraStream Preview in your SwiftuI View and publishes detected objects, which you can then draw over the CameraStream Preview or use for further app logic.

![A device showing SBB ML in use.](SBBML_iPhone13Pro.png)

## Features

SBBML offers 3 key features:
* Detect objects with CoreML and make them available throug a publisher in ``ObjectDetectionService`` (and visualizing it in ``CameraStreamView``)
* (Optionally) track objects with ObjectTracking between object detection iterations in order to limit battery usage (hint: works very well with a small number of objects, for more than 5 objects, ObjectDetection seems to perform better).
* (Optionally) measure the distance to the center of detected objects using DepthData (only available on devices with 2 or more backfacing cameras).

## Topics

### First steps

- <doc:GettingStarted>
