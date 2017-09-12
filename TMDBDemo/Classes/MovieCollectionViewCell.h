//
//  MovieCollectionViewCell.h
//  TMDBDemo
//
//  Created by Gonzalo Hardy on 9/11/17.
//  Copyright © 2017 Octocode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel* movieTitle;
@property (nonatomic, weak) IBOutlet UIImageView* movieImage;

@end
