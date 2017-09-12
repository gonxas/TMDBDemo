//
//  MoviesModel.h
//  TMDBDemo
//
//  Created by Gonzalo Hardy on 9/11/17.
//  Copyright © 2017 Octocode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoviesModel : NSObject

+ (MoviesModel*) sharedInstance;
- (void) getMovies;

@end
