//
//  ViewController.m
//  VimwoVideoExtractor
//
//  Created by Usman Nisar on 6/7/18.
//  Copyright © 2018 Usman Nisar. All rights reserved.
//

#import "ViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "VimeoVideoExtractor.h"
@import AVFoundation;
@import AVKit;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
    [urlInputField setText:@"https://vimeo.com/channels/staffpicks/272806748"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [urlInputField resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return true;
}

- (IBAction)extractButtonClicked:(id)sender
{
    NSString *inputText = urlInputField.text;
    
    NSString *videoID = [inputText lastPathComponent];
    
    if (![videoID isEqualToString:@""])
    {
        [VimeoVideoExtractor extractVideoFromVideoID:videoID thumbQuality:eVimeoThumb640 videoQuality:eVimeoVideo540 completion:^(BOOL success, VimeoVideoExtractor *videoObj) {
            //
            if (success)
            {
                if (videoObj != nil)
                {
                    [self performSelectorOnMainThread:@selector(populateVideoData:) withObject:videoObj waitUntilDone:false];
                    
                    
                }
            }
        }];
    }
}

-(void)populateVideoData:(VimeoVideoExtractor *)videoObj
{
    [videoTitle setText:videoObj.pVideoTitle];
    
    if (![videoObj.thumbnailURL isEqualToString:@""])
    {
        [thumbnailImageView sd_setImageWithURL:[NSURL URLWithString:videoObj.thumbnailURL]
                     placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }
    
    videoExtractedURL = [NSURL URLWithString:videoObj.videoURL];
}

- (IBAction)playButtonClicked:(id)sender
{
    if (videoExtractedURL != nil)
    {
        // create an AVPlayer
        AVPlayer *player = [AVPlayer playerWithURL:videoExtractedURL];
        
        // create a player view controller
        AVPlayerViewController *controller = [[AVPlayerViewController alloc]init];
        controller.player = player;
        [player play];
        
        [self presentViewController:controller animated:true completion:nil];
    }
}

@end
