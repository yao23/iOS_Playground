//
//  ViewController.h
//  SpeechRecognitionPractice
//
//  Created by Yao Li on 2/23/17.
//  Copyright © 2017 clouds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Speech/Speech.h>
#import <Speech/SFSpeechRecognizer.h>

@interface ViewController : UIViewController <SFSpeechRecognizerDelegate>
@property (nonatomic) SFSpeechRecognizer *speechRecognizer;
@property (nonatomic) SFSpeechAudioBufferRecognitionRequest *recognitionRequest;
@property (nonatomic) SFSpeechRecognitionTask *recognitionTask;
@property (nonatomic) AVAudioEngine *audioEngine;
@property (nonatomic) AVAudioInputNode *inputNode;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *microphoneBtn;
- (IBAction)microphoneTapped:(id)sender;

@end

