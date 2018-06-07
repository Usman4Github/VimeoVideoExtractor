//
//  VimeoVideoExtractor.h
//  HappyCoding
//
//  Created by Usman Nisar on 06/06/2018..
//

#import <Foundation/Foundation.h>

//for vimeo video thumbnail extraction
enum VimeoThumbnailQuality {
    eVimeoThumbUnknown = 0,
    eVimeoThumb640 = 1,
    eVimeoThumb960 = 2,
    eVimeoThumb1280 = 3,
    eVimeoThumbBase = 4
};

//for vimeo video extraction
enum VimeoVideoQuality {
    eVimeoVideoUnknown = 0,
    eVimeoVideo360 = 1,
    eVimeoVideo540 = 2,
    eVimeoVideo640 = 3,
    eVimeoVideo720 = 4,
    eVimeoVideo960 = 5,
    eVimeoVideo1080 = 6
};


@interface VimeoVideoExtractor : NSObject

@property (nonatomic, strong) NSString *pVideoTitle;
@property (nonatomic, strong) NSString *thumbnailURL;
@property (nonatomic, strong) NSString *videoURL;

+(void)extractVideoFromVideoID:(NSString *)videoID thumbQuality:(int)thumbQuality videoQuality:(int)videoQuality completion:(void (^)(BOOL, VimeoVideoExtractor *))completion;

-(void)parseVideoResponse:(NSDictionary*)videoDictionary thumbQuality:(int)thumbQuality videoQuality:(int)videoQuality;

-(NSString*)videoQualityValue:(int)tag;
-(NSString*)thumbQualityValue:(int)tag;

@end
