import Foundation
import Capacitor
import MLKitVision
import MLKitFaceDetection

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(GoogleMLKitVision)
public class GoogleMLKitVision: CAPPlugin {
    @objc func process(_ call: CAPPluginCall) {
        // An image or image buffer used for vision detection.
        let image: VisionImage
        // Options for specifying a face detector.
        let options: FaceDetectorOptions = FaceDetectorOptions()

        guard let content = call.getString("image") else {
            call.reject("Must provide an image")
            return
        }

        // Initializes a `VisionImage` object with the given image.
        image = VisionImage.init(
            // Image to use in vision detection.
            image: UIImage(
                // An object that manages image data in your app.
                data: Data(base64Encoded: content)!
            )!
        )

        if let optionsObject = call.getObject("options") {
            if let performanceMode = optionsObject["performanceMode"] {
                // The face detector performance mode that determines the accuracy of the results and the speed of the detection.
                options.performanceMode = FaceDetectorPerformanceMode(rawValue: performanceMode as! Int)
            }

            if let landmarkMode = optionsObject["landmarkMode"] {
                // The face detector landmark mode that determines the type of landmark results returned by detection.
                options.landmarkMode = FaceDetectorLandmarkMode(rawValue: landmarkMode as! Int)
            }
            if let contourMode = optionsObject["contourMode"] {
                // The face detector contour mode that determines the type of contour results returned by detection.
                options.contourMode = FaceDetectorContourMode(rawValue: contourMode as! Int)
            }

            if let classificationMode = optionsObject["classificationMode"] {
                // The face detector classification mode for characterizing attributes such as smiling.
                options.classificationMode = FaceDetectorClassificationMode(rawValue: classificationMode as! Int)
            }

            if let minFaceSize = optionsObject["minFaceSize"] {
                // The smallest desired face size.
                // The size is expressed as a proportion of the width of the head to the image width.
                options.minFaceSize = minFaceSize as! CGFloat
            }

            if let enableTracking = optionsObject["enableTracking"] {
                // Whether the face tracking feature is enabled for face detection.
                options.isTrackingEnabled = enableTracking as! Bool
            }
        }

        // Returns a face detector with the given options.
        let faceDetector = FaceDetector.faceDetector(
            // Options for configuring the face detector.
            options: options
        )

        // Array of face results in the given image.
        let faces: [Face]
        do {
            // Returns face results in the given image
            faces = try faceDetector.results(
                // The image to get results in.
                in: image
            )
        } catch let error {
            call.error(error.localizedDescription, error)
            return
        }

        var facesArray = [Any]()

        for face in faces {
            // A human face detected in an image.

            var faceObject = [String: Any]()

            do { // Bounds
                // The rectangle containing the detected face relative to the image in the view coordinate system.
                let bounds = face.frame

                var boundsObject = [String: Any]()

                boundsObject["x"] = bounds.origin.x
                boundsObject["y"] = bounds.origin.y
                boundsObject["width"] = bounds.size.width
                boundsObject["height"] = bounds.size.height

                boundsObject["left"] = bounds.origin.x
                boundsObject["top"] = bounds.origin.y
                boundsObject["right"] = bounds.origin.x + bounds.size.width
                boundsObject["bottom"] = bounds.origin.y + bounds.size.height

                faceObject["bounds"] = boundsObject
            }

            do { // Landmarks
                var landmarksArray = [Any]()

                // An array of all the landmarks in the detected face.
                for landmark in face.landmarks {
                    // A landmark on a human face detected in an image.

                    // 2D position of the facial landmark.
                    let point: VisionPoint = landmark.position

                    var landmarkObject = [String: Any]()

                    // The type of the facial landmark.
                    landmarkObject["type"] = landmarkType(type: landmark.type)
                    landmarkObject["position"] = pointHelper(point: point)

                    landmarksArray.append(landmarkObject)
                }

                if landmarksArray.count > 0 {
                    faceObject["landmarks"] = landmarksArray
                }
            }

            do { // Contours
                var contoursArray = [Any]()

                // An array of all the contours in the detected face.
                for contour in face.contours {
                    // A contour on a human face detected in an image.

                    // An array of 2D points that make up the facial contour.
                    let points: [VisionPoint] = contour.points

                    var pointsArray = [Any]()

                    for point in points {
                        pointsArray.append(pointHelper(point: point))
                    }

                    var contourObject = [String: Any]()

                    // The facial contour type.
                    contourObject["type"] = contourType(type: contour.type)
                    contourObject["points"] = pointsArray

                    contoursArray.append(contourObject)
                }

                if contoursArray.count > 0 {
                    faceObject["contours"] = contoursArray
                }
            }

            // Indicates whether the face has a tracking ID.
            if face.hasTrackingID {
                // The tracking identifier of the face.
                faceObject["trackingId"] = face.trackingID
            }

            // Indicates whether the detector found the head x euler angle.
            if face.hasHeadEulerAngleX {
                // Indicates the rotation of the face about the horizontal axis of the image. Positive x euler angle is when the face is turned upward in the image that is being processed.
                faceObject["headEulerAngleX"] = face.headEulerAngleX
            }
            // Indicates whether the detector found the head y euler angle.
            if face.hasHeadEulerAngleY {
                // Indicates the rotation of the face about the vertical axis of the image. Positive y euler angle is when the face is turned towards the right side of the image that is being processed.
                faceObject["headEulerAngleY"] = face.headEulerAngleY
            }
            // Indicates whether the detector found the head z euler angle.
            if face.hasHeadEulerAngleZ {
                // Indicates the rotation of the face about the axis pointing out of the image. Positive z euler angle is a counter-clockwise rotation within the image plane.
                faceObject["headEulerAngleZ"] = face.headEulerAngleZ
            }

            // Indicates whether a smiling probability is available.
            if face.hasSmilingProbability {
                // Probability that the face is smiling.
                faceObject["smilingProbability"] = face.smilingProbability
            }
            // Indicates whether a smiling probability is available.
            if face.hasLeftEyeOpenProbability {
                // Probability that the face's left eye is open.
                faceObject["leftEyeOpenProbability"] = face.leftEyeOpenProbability
            }
            // Indicates whether a right eye open probability is available.
            if face.hasRightEyeOpenProbability {
                // Probability that the face's right eye is open.
                faceObject["rightEyeOpenProbability"] = face.rightEyeOpenProbability
            }

            facesArray.append(faceObject)
        }

        call.success([
            "faces": facesArray
        ])
    }

    private func landmarkType(
        type: FaceLandmarkType
    ) -> Int? {
        switch type {
        // The center of the bottom lip.
        case .mouthBottom: return 0
        // The left cheek.
        case .leftCheek: return 1
        // The midpoint of the left ear tip and left ear lobe.
        case .leftEar: return 3
        // The left eye.
        case .leftEye: return 4
        // The left corner of the mouth
        case .mouthLeft: return 5
        // The midpoint between the nostrils where the nose meets the face.
        case .noseBase: return 6
        // The right cheek.
        case .rightCheek: return 7
        // The midpoint of the right ear tip and right ear lobe.
        case .rightEar: return 9
        // The right eye.
        case .rightEye: return 10
        // The right corner of the mouth
        case .mouthRight: return 11
        default:
            return nil
        }
    }

    private func contourType(
        type: FaceContourType
    ) -> Int? {
        switch type {
        // A set of points that outline the face oval.
        case .face: return 1
        // A set of points that outline the top of the left eyebrow.
        case .leftEyebrowTop: return 2
        // A set of points that outline the bottom of the left eyebrow.
        case .leftEyebrowBottom: return 3
        // A set of points that outline the top of the right eyebrow.
        case .rightEyebrowTop: return 4
        // A set of points that outline the bottom of the right eyebrow.
        case .rightEyebrowBottom: return 5
        // A set of points that outline the left eye.
        case .leftEye: return 6
        // A set of points that outline the right eye.
        case .rightEye: return 7
        // A set of points that outline the top of the upper lip.
        case .upperLipTop: return 8
        // A set of points that outline the bottom of the upper lip.
        case .upperLipBottom: return 9
        // A set of points that outline the top of the lower lip.
        case .lowerLipTop: return 10
        // A set of points that outline the bottom of the lower lip.
        case .lowerLipBottom: return 11
        // A set of points that outline the nose bridge.
        case .noseBridge: return 12
        // A set of points that outline the bottom of the nose.
        case .noseBottom: return 13
        // A center point on the left cheek.
        case .leftCheek: return 14
        // A center point on the right cheek.
        case .rightCheek: return 15
        default:
            return nil
        }
    }

    private func pointHelper(
        // A two-dimensional point in an image.
        point: VisionPoint
    ) -> [String: Any] {
        var pointObject = [String: Any]()

        // The x-coordinate of the point.
        pointObject["x"] = point.x
        // The y-coordinate of the point.
        pointObject["y"] = point.y

        return pointObject
    }
}
