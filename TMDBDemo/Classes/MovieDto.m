//
//  MovieDto.m
//  TMDBDemo
//
//  Created by Gonzalo Hardy on 9/11/17.
//  Copyright © 2017 Octocode. All rights reserved.
//

#import "MovieDto.h"
#import "Constants.h"

@implementation MovieDto

- (void) setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [weakSelf downloadImage];
        [[NSNotificationCenter defaultCenter] postNotificationName:kImageDownloaded object:self];
    });
}

- (void) downloadImage {
    
    NSError* downloadError = nil;
    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageUrl]
                                         options:kNilOptions
                                           error:&downloadError];
    
    if (downloadError) {
        NSLog(@"Failed to download image for movie: %@, url:%@, error:%@",self.title,self.imageUrl,downloadError.localizedDescription);
    }
    
    self.image = [UIImage imageWithData:data];
}

- (UIImage*) image {
    if (_image)
        return _image;
    
    return [UIImage imageNamed:@"placeholder"];
}

@end
