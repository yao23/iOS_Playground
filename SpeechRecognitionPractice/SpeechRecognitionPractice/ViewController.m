//
//  ViewController.m
//  SpeechRecognitionPractice
//
//  Created by Yao Li on 2/23/17.
//  Copyright © 2017 clouds. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _microphoneBtn.enabled = NO;
    _speechRecognizer.delegate = self;
    _audioEngine = [[AVAudioEngine alloc] init];
    [self configSpeechRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configSpeechRecognizer {
    _speechRecognizer = [[SFSpeechRecognizer alloc] initWithLocale:[NSLocale localeWithLocaleIdentifier:@"en-US"]];
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus authStatus) {
        BOOL isButtonEnabled = NO;
        switch (authStatus) {
            case SFSpeechRecognizerAuthorizationStatusAuthorized:
                //User gave access to speech recognition
                NSLog(@"Authorized");
                isButtonEnabled = YES;
                break;

            case SFSpeechRecognizerAuthorizationStatusDenied:
                //User denied access to speech recognition
                NSLog(@"SFSpeechRecognizerAuthorizationStatusDenied");
                break;

            case SFSpeechRecognizerAuthorizationStatusRestricted:
                //Speech recognition restricted on this device
                NSLog(@"SFSpeechRecognizerAuthorizationStatusRestricted");
                break;

            case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                //Speech recognition not yet authorized
                NSLog(@"SFSpeechRecognizerAuthorizationStatusNotDetermined");
                break;

            default:
                NSLog(@"Default");
                break;
        }

        // http://stackoverflow.com/questions/31951704/this-application-is-modifying-the-autolayout-engine-from-a-background-thread-wh
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            _microphoneBtn.enabled = isButtonEnabled;
        }];
    }];
}


- (IBAction)microphoneTapped:(id)sender {
    if ([_audioEngine isRunning]) {
        NSLog(@"AUDIO ENGINE IS RUNNING");
        [_audioEngine stop];
        [_recognitionRequest endAudio];
        _microphoneBtn.enabled = NO;
        [_microphoneBtn setTitle:@"Start Recording" forState:UIControlStateNormal];
    } else {
        NSLog(@"AUDIO ENGINE IS WORKING");
        [self startRecording];
        [_microphoneBtn setTitle:@"Stop Recording" forState:UIControlStateNormal];
    }
}


-(void)startRecording { // http://stackoverflow.com/questions/37821826/continuous-speech-recogn-with-sfspeechrecognizer-ios10-beta
    if (_recognitionTask != nil) {
        [_recognitionTask cancel];
        _recognitionTask = nil;
    }

    NSError * outError;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    @try {
        [audioSession setCategory:AVAudioSessionCategoryRecord error:&outError];
        [audioSession setMode:AVAudioSessionModeMeasurement error:&outError];
        [audioSession setActive:true withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation  error:&outError];
    } @catch (NSException * e) {
        NSLog(@"audioSession properties weren't set because of an error. %@", e);
    }

    _recognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
    _inputNode = [_audioEngine inputNode];
    if (_inputNode == nil) {
        NSLog(@"Audio engine has no input node");
    }
    if (_recognitionRequest == nil) {
        NSLog(@"Unable to created a SFSpeechAudioBufferRecognitionRequest object");
    }
    _recognitionRequest.shouldReportPartialResults = YES;
    _recognitionTask = [_speechRecognizer recognitionTaskWithRequest:_recognitionRequest
                                                       resultHandler:^(SFSpeechRecognitionResult *result, NSError *error) {
                                                           BOOL isFinal = NO;
                                                           if (result != nil) {
                                                               _textView.text = result.bestTranscription.formattedString;
                                                               isFinal = result.isFinal;
                                                           }
                                                           if (error != nil || isFinal) {
                                                               [_audioEngine stop];
                                                               [_inputNode removeTapOnBus:0];
                                                               _recognitionRequest = nil;
                                                               _recognitionTask = nil;
                                                               _microphoneBtn.enabled = YES;
                                                           }
                                                       }];

    AVAudioFormat *recordingFormat = [_inputNode outputFormatForBus:0];
    [_inputNode installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer *buffer, AVAudioTime *when) {
        [_recognitionRequest appendAudioPCMBuffer:buffer];
    }];

    [_audioEngine prepare];

    @try {
        [_audioEngine startAndReturnError:&outError];
    } @catch (NSException *e) {
        NSLog(@"audioEngine couldn't start because of an error. %@", e);
    }

    _textView.text = @"Say something, I'm listening!";
}

- (void)speechRecognizer:(SFSpeechRecognizer*)speechRecognizer availabilityDidChange:(BOOL)available {
    _microphoneBtn.enabled = available;
    NSLog(@"AVAILABLE: %@", (available?@"YES":@"NO"));
}
@end
