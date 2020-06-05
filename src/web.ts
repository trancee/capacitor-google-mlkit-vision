import { WebPlugin } from '@capacitor/core';
import { GoogleMLKitVisionPlugin } from './definitions';

import {
  FaceDetectorOptions,
  ProcessResult,
} from './definitions';

export class GoogleMLKitVisionWeb extends WebPlugin implements GoogleMLKitVisionPlugin {
  constructor() {
    super({
      name: 'GoogleMLKitVision',
      platforms: ['web']
    });
  }

  // Detects human faces from the supplied image.
  async process(options: {
    // Represents an image object.
    image: string,
    // The options for the face detector.
    options?: FaceDetectorOptions,
  }): Promise<ProcessResult> {
    console.log("process", options);
    throw new Error("Method not implemented.");
  }
}

const GoogleMLKitVision = new GoogleMLKitVisionWeb();

export { GoogleMLKitVision };

import { registerWebPlugin } from '@capacitor/core';
registerWebPlugin(GoogleMLKitVision);
