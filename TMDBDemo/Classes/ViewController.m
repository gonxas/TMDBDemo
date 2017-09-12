//
//  ViewController.m
//  TMDBDemo
//
//  Created by Gonzalo Hardy on 9/11/17.
//  Copyright © 2017 Octocode. All rights reserved.
//

#import "ViewController.h"
#import "MovieCollectionViewCell.h"
#import "MoviesModel.h"
#import "Constants.h"
#import "MovieDto.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate> {
    NSArray* newMovies;
    NSArray* popularMovies;
    NSArray* highestRatedThisYear;
    
    IBOutlet UICollectionView* newMoviesCollection;
    IBOutlet UICollectionView* popularMoviesCollection;
    IBOutlet UICollectionView* highestRatedCollection;
    
    IBOutlet NSLayoutConstraint* contentViewWidhtConstrait;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[MoviesModel sharedInstance] getMovies];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newMoviesDownloaded:) name:kNewMoviesDownloaded object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popuplarMoviesDownloaded:) name:kPopularMoviesDownloaded object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(highestRatedMoviesDownloaded:) name:kHighestRatedMoviesDownloaded object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageDownloaded:) name:kImageDownloaded object:nil];
    
    contentViewWidhtConstrait.constant = self.view.frame.size.width;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>) coordinator {
    contentViewWidhtConstrait.constant = size.width;
}



- (void) imageDownloaded:(NSNotification*)notification {
    MovieDto* loadedDto = notification.object;
    
    for(NSIndexPath* indexPath in newMoviesCollection.indexPathsForVisibleItems ) {
        MovieDto* dto = newMovies[indexPath.row];
        if (loadedDto == dto) {
            [newMoviesCollection performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            [NSThread sleepForTimeInterval:0.3];
        }
    }
    
    for(NSIndexPath* indexPath in popularMoviesCollection.indexPathsForVisibleItems ) {
        MovieDto* dto = newMovies[indexPath.row];
        if (loadedDto == dto) {
            [popularMoviesCollection performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            [NSThread sleepForTimeInterval:0.3];
        }
    }
    
    for(NSIndexPath* indexPath in highestRatedCollection.indexPathsForVisibleItems ) {
        MovieDto* dto = newMovies[indexPath.row];
        if (loadedDto == dto) {
            [highestRatedCollection performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            [NSThread sleepForTimeInterval:0.3];
        }
    }
}

- (void) newMoviesDownloaded:(NSNotification*)notification {
    newMovies = notification.object;
    [newMoviesCollection performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (void) popuplarMoviesDownloaded:(NSNotification*)notification {
    popularMovies = notification.object;
    [popularMoviesCollection performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (void) highestRatedMoviesDownloaded:(NSNotification*)notification {
    highestRatedThisYear = notification.object;
    [highestRatedCollection performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (collectionView.tag) {
        case 0:
            return newMovies.count;
            
        case 1:
            return popularMovies.count;
            
        case 2:
            return highestRatedThisYear.count;
            
            
        default:
            return 0;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MovieCollectionViewCell* movieView = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionViewCell" forIndexPath:indexPath];
    
    if (!movieView) {
        movieView = [[MovieCollectionViewCell alloc] init];
    }
    
    MovieDto* dto = nil;
    switch (collectionView.tag) {
        case 0:
            dto = newMovies[indexPath.row];
            break;
        case 1:
            dto = popularMovies[indexPath.row];
            break;
        case 2:
            dto = highestRatedThisYear[indexPath.row];
            break;
            
        default:
            break;
    }
    
    if (dto) {
        movieView.movieTitle.text = dto.title;
        movieView.movieImage.image = dto.image;
    }

    return movieView;
}


@end
