//
//  SMMoviePlayerClass.h
//  SmartManager
//
//  Created by Sandeep on 18/11/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface SMMoviePlayerClass : NSObject


+(MPMoviePlayerViewController *)allocMoviePlayerView:(NSString *)moviePath;
@end
