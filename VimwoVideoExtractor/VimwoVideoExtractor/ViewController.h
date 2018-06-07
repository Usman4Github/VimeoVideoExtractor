//
//  ViewController.h
//  VimwoVideoExtractor
//
//  Created by Usman Nisar on 6/7/18.
//  Copyright © 2018 Usman Nisar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UITextField *urlInputField;
    IBOutlet UIImageView *thumbnailImageView;
    IBOutlet UILabel *videoTitle;
    
    NSURL        *videoExtractedURL;
}

- (IBAction)extractButtonClicked:(id)sender;
- (IBAction)playButtonClicked:(id)sender;

@end

