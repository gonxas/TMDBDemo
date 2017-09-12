//
//  MovieDto.h
//  TMDBDemo
//
//  Created by Gonzalo Hardy on 9/11/17.
//  Copyright © 2017 Octocode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieDto : NSObject

@property (nonatomic,strong) NSString* title;
@property (nonatomic,strong) NSString* imageUrl;
@property (nonatomic,strong) UIImage* image;

@end
