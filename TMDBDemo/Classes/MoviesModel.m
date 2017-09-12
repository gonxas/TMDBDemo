//
//  MoviesModel.m
//  TMDBDemo
//
//  Created by Gonzalo Hardy on 9/11/17.
//  Copyright © 2017 Octocode. All rights reserved.
//

#import "MoviesModel.h"
#import "Constants.h"
#import "MovieDto.h"

@interface MoviesModel () {
    NSString* imagesBaseUrl;
    NSString* desiredImageSize;
}



@end

static MoviesModel* moviesModelInstance;

@implementation MoviesModel

+ (MoviesModel*) sharedInstance {
    if (!moviesModelInstance)
        moviesModelInstance = [MoviesModel alloc];
    
    
    return moviesModelInstance;
}

- (void) getMovies {
    [self getConfig];
    
    [self getNewMovies];
    [self getPopularMovies];
    [self getHighestMovies];
}

- (void) getConfig {
    NSString *configUrl = [NSString stringWithFormat:@"https://api.themoviedb.org/3/configuration?api_key=%@",kTMDBApiKey];
    
    
    [self getDictionaryFromUrl:configUrl withCompletition:^(NSDictionary* jsonDictionary, NSError* error){
        if (error) {
            [self showAlertWithMessage:@"Error getting configs parameter. Please try again later"];
            return ;
        }
            
        
        NSDictionary* imagesDic = jsonDictionary[@"images"];
        imagesBaseUrl = imagesDic[@"secure_base_url"];
        
        NSArray* backdropSizes = imagesDic[@"backdrop_sizes"];
        if (backdropSizes.count > 0) {
            desiredImageSize = backdropSizes.firstObject;
        }
    }];
    
    
}


- (void) getNewMovies {
    NSDate* date = [NSDate date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString* toDate = [dateFormatter stringFromDate:date];
    
    [date dateByAddingTimeInterval:-kNewMoviesPreviousTime];
    
    NSString* fromDate = [dateFormatter stringFromDate:date];
    
    NSString *newUrl = [NSString stringWithFormat:@"https://api.themoviedb.org/3/discover/movie?primary_release_date.gte=%@&primary_release_date.lte=%@&api_key=%@",fromDate,toDate,kTMDBApiKey];
    
    
    [self getDictionaryFromUrl:newUrl withCompletition:^(NSDictionary* jsonDictionary, NSError* error){
        if (error) {
            [self showAlertWithMessage:@"Error getting New Releases. Please try again later"];
            return ;
        }
        
        NSArray* array = [self parseMovies:jsonDictionary];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNewMoviesDownloaded object:array];
        
    }];
}

- (void) getPopularMovies {
    NSString *newUrl = [NSString stringWithFormat:@"https://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc&api_key=%@",kTMDBApiKey];
    
    
    [self getDictionaryFromUrl:newUrl withCompletition:^(NSDictionary* jsonDictionary, NSError* error){
        if (error) {
            [self showAlertWithMessage:@"Error getting Popular Movies. Please try again later"];
            return ;
        }
        
        NSArray* array = [self parseMovies:jsonDictionary];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kPopularMoviesDownloaded object:array];
        
    }];
}

- (void) getHighestMovies {
    
    NSDate* date = [NSDate date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    
    NSString* year = [dateFormatter stringFromDate:date];
    
    
    NSString *newUrl = [NSString stringWithFormat:@"https://api.themoviedb.org/3/discover/movie?sort_by=vote_average.desc&vote_count.gte=500&primary_release_year=%@&api_key=%@",year,kTMDBApiKey];
    
    
    [self getDictionaryFromUrl:newUrl withCompletition:^(NSDictionary* jsonDictionary, NSError* error){
        if (error) {
            [self showAlertWithMessage:@"Error getting Highest Rated movies. Please try again later"];
            return ;
        }
        
        NSArray* array = [self parseMovies:jsonDictionary];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kHighestRatedMoviesDownloaded object:array];
        
    }];
}

- (NSArray*) parseMovies:(NSDictionary*)jsonDictionary {
    NSArray* results = jsonDictionary[@"results"];
    
    NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:results.count];
    
    for (NSDictionary* movieDictionary in results) {
        MovieDto* dto = [[MovieDto alloc] init];
        dto.title = movieDictionary[@"title"];
        
        NSString* imageUrl = movieDictionary[@"backdrop_path"];
        if ([imageUrl isKindOfClass:[NSNull class]] || imageUrl.length == 0)
            imageUrl = movieDictionary[@"poster_path"];
        
        if ([imageUrl isKindOfClass:[NSString class]] && imageUrl.length > 0) {
            imageUrl = [NSString stringWithFormat:@"%@%@%@",imagesBaseUrl,desiredImageSize,imageUrl];
            dto.imageUrl = imageUrl;
        }
        
        [array addObject:dto];
    }
    
    return array;
}



- (void) getDictionaryFromUrl:(NSString*)urlString withCompletition:(void(^)(NSDictionary* dictionary, NSError* error))completition {
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession]
                                  dataTaskWithURL:url
                                  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                      
                                      if (error) {
                                          completition(nil,error);
                                          return;
                                      }
                                      
                                      NSError* jsonError;
                                      NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                                           options:kNilOptions
                                                                                             error:&jsonError];
                                      
                                      if (jsonError)
                                          completition(nil,error);
                                      else
                                          completition(json,nil);
                                  }];
    
    [task resume];
}
                                  
- (void) showAlertWithMessage:(NSString*)message {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@""
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Ok"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {}];
    
    
    [alert addAction:ok];

    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

@end
