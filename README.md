# VimeoVideoExtractor
VimeoVideoExtractor is an easy way to extract the Vimeo video details like title, thumbnail and playable mp4 URL which then can be used to play using AVPlayer

Integration:

Simply import source folder into your project and use bellow method to extract vimeo video details

+(void)extractVideoFromVideoID:(NSString *)videoID thumbQuality:(int)thumbQuality videoQuality:(int)videoQuality completion:(void (^)(BOOL, VimeoVideoExtractor *))completion

for example:

[VimeoVideoExtractor extractVideoFromVideoID:videoID thumbQuality:eVimeoThumb640 videoQuality:eVimeoVideo540 completion:^(BOOL success, VimeoVideoExtractor *videoObj) {
            //
            if (success)
            {
                if (videoObj != nil)
                {
//                    write your code here
                    
                    
                }
            }
        }];
        
        
I used object class VimeoVideoExtractor to store extracted data to properly elaborate extracted video information

thumbQuality: and videoQuality can be changed as per requirement. 

see enums defined in VimeoVideoExtractor.h file for all possible video or thumbnail qualities.


Happy coding.... 
