# ESTA library: Machine Learning for iOS

[![Generic badge](https://img.shields.io/badge/platform-iOS%2014+-blue.svg)](https://www.apple.com/ios/ios-15/)
[![Generic badge](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![GPLv3 license](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://spdx.org/licenses/GPL-3.0-or-later.html)

This framework simplifies the integration of SBB generated CoreML ObjectDetection models into iOS Apps using Combine. It displays a CameraStream Preview in your SwiftuI View and publishes detected objects, which you can then draw over the CameraStream Preview or use for further app logic.

![SBB ML in use](SBBML/Documentation.docc/Resources/SBBML_iPhone13Pro.png)

## Minimum supported iOS Version

* iOS 14.0

## Add the library to your project with Swift package manager

Start by adding the SBBML package to your project using Swift Package Manager.

For HTTPS:
```
https://github.com/SchweizerischeBundesbahnen/mobile-ios-ml.git
```

For SSH:
```
ssh://git@github.com:SchweizerischeBundesbahnen/mobile-ios-ml.git
```

## How to use

The main documentation (DocC) on how to use SBB ML can be created directly from the project in XCode by selecting "Product" -> "Build Documentation".

### Documentation

* DocC documentation can be created in XCode by selecting "Product" -> "Build Documentation".
* Sample app SBB ML Demo is included in Xcode project.

### SBB internal documentation

A the moment, the following documents are only available to persons internal to SBB:
*  [AppBakery libraries](https://sbb.sharepoint.com/sites/app-bakery/SitePages/Mobile-Libraries.aspx "AppBakery liraries")
*  [SBB ML Bitbucket](https://code.sbb.ch/scm/kd_esta_mobile/esta-mobile-ios-ml/ "SBB ML Bitbucket") contains the following documentation: DocC documentation can be created in XCode by selecting "Product" -> "Build Documentation".
* Sample app SBB ML Demo is included in Xcode project

## Getting help

If you need help, you can reach out to us by e-mail: [mobile@sbb.ch](mailto:mobile@sbb.ch?subject=[GitHub]%20MDS%20SwiftUI)

## Getting involved

Generally speaking, we are welcoming contributions improving existing UI elements or fixing certain bugs. We will also consider contributions introducing new design elements, but might reject them, if they do not reflect our vision of SBB Design System.

General instructions on _how_ to contribute can be found under [Contributing](Contributing.md).

## Authors

* **Brunner Nicolas**

## License

Code released under the [GPL-3.0-or-later license](LICENSE).
