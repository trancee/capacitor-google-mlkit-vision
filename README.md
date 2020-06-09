# Face Detection

[Face Detection](https://developers.google.com/ml-kit/vision/face-detection)

With ML Kit's face detection API, you can detect faces in an image, identify key facial features, and get the contours of detected faces. Note that the API detects faces, it does not recognize people.

With face detection, you can get the information you need to perform tasks like embellishing selfies and portraits, or generating avatars from a user's photo. Because ML Kit can perform face detection in real time, you can use it in applications like video chat or games that respond to the player's expressions.

[Face Detection Concepts](https://developers.google.com/ml-kit/vision/face-detection/face-detection-concepts)

## Android

[Detect faces with ML Kit on Android](https://developers.google.com/ml-kit/vision/face-detection/android)

There are two ways to integrate face detection: a bundled model which is part of your app and an unbundled model that depends on Google Play Services. The two models are the same. If you select the unbundled model your app will be smaller.

**For bundling the model in your app**:
add the dependencies for the ML Kit Android libraries to your module's app-level gradle file, which is usually `app/build.gradle`:

```java
    dependencies {
      // ...
      // Use this dependency to bundle the model with your app
      implementation 'com.google.mlkit:face-detection:16.0.0'
    }
```

**If you choose to use the Google Play Service way**:
you can configure your app to automatically download the model to the device after your app is installed from the Play Store. To do so, add the following declaration to your app's `AndroidManifest.xml` file:

```java
      <application ...>
        ...
      <meta-data
          android:name="com.google.mlkit.vision.DEPENDENCIES"
          android:value="face" />
      <!-- To use multiple models: android:value="face,model2,model3" -->
      </application>
```

If you don't enable install-time model downloads, the model is downloaded the first time you run the scanner. Requests you make before the download has completed produce no results.

## iOS
[Detect faces with ML Kit on iOS](https://developers.google.com/ml-kit/vision/face-detection/ios)

You can use ML Kit to detect faces in images and video.
