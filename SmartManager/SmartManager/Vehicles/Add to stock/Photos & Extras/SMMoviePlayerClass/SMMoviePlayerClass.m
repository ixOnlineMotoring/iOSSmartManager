//
//  SMMoviePlayerClass.m
//  SmartManager
//
//  Created by Sandeep on 18/11/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMMoviePlayerClass.h"

@implementation SMMoviePlayerClass

+(MPMoviePlayerViewController *)allocMoviePlayerView:(NSString *)moviePath;
{
    MPMoviePlayerViewController *moviePlayerView = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:moviePath]];
    moviePlayerView.moviePlayer.controlStyle =  MPMovieControlStyleFullscreen;
    moviePlayerView.moviePlayer.shouldAutoplay=YES;
    [moviePlayerView.moviePlayer prepareToPlay];
    
    return moviePlayerView;
}
@end
