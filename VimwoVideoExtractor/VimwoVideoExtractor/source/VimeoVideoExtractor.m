//
//  VimeoVideoExtractor.m
//  HappyCoding
//
//  Created by Usman Nisar on 06/06/2018..
//

#import "VimeoVideoExtractor.h"

@implementation VimeoVideoExtractor

@synthesize pVideoTitle;
@synthesize videoURL;
@synthesize thumbnailURL;

+(void)extractVideoFromVideoID:(NSString *)videoID thumbQuality:(int)thumbQuality videoQuality:(int)videoQuality completion:(void (^)(BOOL, VimeoVideoExtractor *))completion
{
    NSString *requestString = [NSString stringWithFormat:@"https://player.vimeo.com/video/%@/config", videoID];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestString]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                        if (completion)
                                                        {
                                                            completion(NO, nil);
                                                        }
                                                        
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        
                                                        NSLog(@"%@", httpResponse);
                                                        if (completion)
                                                        {
                                                            VimeoVideoExtractor *videoObj = [[VimeoVideoExtractor alloc] init];
                                                            
                                                            //extract json dictionary from data
                                                            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                                            
                                                            //parse response and add desire data to object
                                                            if (responseDictionary != nil)
                                                            {
                                                                [videoObj parseVideoResponse:responseDictionary thumbQuality:thumbQuality videoQuality:videoQuality];
                                                                
                                                                //send object with extracted data in completion block
                                                                completion(YES, videoObj);
                                                            }
                                                            else
                                                            {
                                                                //error occured while parsing data into dictionary
                                                                NSLog(@"error occured while parsing data into dictionary");
                                                                completion(NO, nil);
                                                            }
                                                        }
                                                        
                                                    }
                                                }];
    [dataTask resume];
}


-(void)parseVideoResponse:(NSDictionary*)videoDictionary thumbQuality:(int)thumbQuality videoQuality:(int)videoQuality
{
    NSDictionary *videoData = [videoDictionary valueForKey:@"video"];
    if (videoData != nil)
    {
        //extract video title from video data
        if ([[videoData valueForKey:@"title"] isKindOfClass:[NSString class]])
        {
            self.pVideoTitle = [videoData valueForKey:@"title"];
        }
        
        //extract thumbnail from video data
        if ([[videoData valueForKey:@"thumbs"] isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *thumbData = [videoData valueForKey:@"thumbs"];
            
            //check for users desired thumb quality
            if ([[thumbData valueForKey:[self thumbQualityValue:thumbQuality]] isKindOfClass:[NSString class]])
            {
                self.thumbnailURL = [thumbData valueForKey:[self thumbQualityValue:thumbQuality]];
            }
            //if desired quality does not exists..
            //search for avialable quality
            else if ([[thumbData valueForKey:[self thumbQualityValue:eVimeoThumb640]] isKindOfClass:[NSString class]])
            {
                self.thumbnailURL = [thumbData valueForKey:[self thumbQualityValue:eVimeoThumb640]];
            }
            else if ([[thumbData valueForKey:[self thumbQualityValue:eVimeoThumb960]] isKindOfClass:[NSString class]])
            {
                self.thumbnailURL = [thumbData valueForKey:[self thumbQualityValue:eVimeoThumb960]];
            }
            else if ([[thumbData valueForKey:[self thumbQualityValue:eVimeoThumbBase]] isKindOfClass:[NSString class]])
            {
                self.thumbnailURL = [thumbData valueForKey:[self thumbQualityValue:eVimeoThumbBase]];
            }
        }
    }
    
    //now extract video playable url from data
    //its data object hierechi is: request -> files -> progressive
    NSDictionary *requestData = [videoDictionary valueForKey:@"request"];
    if (requestData != nil)
    {
        NSDictionary *filesData = [requestData valueForKey:@"files"];
        if (filesData != nil)
        {
            if ([[filesData valueForKey:@"progressive"] isKindOfClass:[NSArray class]])
            {
                NSArray *progressiveDataArray = [filesData valueForKey:@"progressive"];
                for(NSDictionary* progressiveData in progressiveDataArray)
                {
                    NSString *videoQualityStr = [progressiveData valueForKey:@"quality"];
                    if ([videoQualityStr isEqualToString:[self videoQualityValue:videoQuality]])
                    {
                        self.videoURL = [progressiveData valueForKey:@"url"];
                        break;
                    }
                }
            }
        }
    }
}

//this method will return string value for provide enum value of video quality
-(NSString*)videoQualityValue:(int)tag
{
    switch (tag) {
        case eVimeoVideo360:
            return @"360p";
            break;
        case eVimeoVideo540:
            return @"540p";
        case eVimeoVideo720:
            return @"720p";
            break;
        case eVimeoVideo960:
            return @"960p";
            break;
        case eVimeoVideo1080:
            return @"1080p";
            break;
            
        default:
            return @"unknown";
            break;
    }
    
    return @"";
}

//this method will return string value for provide enum value of thumb
-(NSString*)thumbQualityValue:(int)tag
{
    switch (tag) {
        case eVimeoThumb640:
            return @"640";
            break;
        case eVimeoThumb960:
            return @"960";
            break;
        case eVimeoThumbBase:
            return @"base";
            break;
            
        default:
            return @"unknown";
            break;
    }
    
    return @"";
}

@end
