//
//  ViewController.m
//  HealthTest
//
//  Created by BJ on 2017/6/14.
//  Copyright © 2017年 BJHealthTest. All rights reserved.
//

#import "ViewController.h"
#import "HealthKitManage.h"
#import <MediaPlayer/MediaPlayer.h>



@interface ViewController ()

{
    UILabel *stepLabel;
    UILabel *distanceLabel;
    UILabel *timeLabel;
}
@property (nonatomic, strong) MPMoviePlayerController *moviePlayerController;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {

    [self.moviePlayerController play];

    [self onClickBtn1];
    [self onClickBtn2];
}

- (void)viewWillDisappear:(BOOL)animated {

    [self.moviePlayerController pause];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"keep" ofType:@"mp4"];
    
    self.moviePlayerController.contentURL = [[NSURL alloc] initFileURLWithPath:moviePath];
    
    [self.moviePlayerController play];
    
//    [self.moviePlayerController.view bringSubviewToFront:self.keepView];
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    
    NSString *str = [dateFormatter stringFromDate:date];
    

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    imageView.backgroundColor = [UIColor clearColor];
//    imageView.image = [UIImage imageNamed:@"3.jpg"];
     [self.view addSubview:imageView];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(50, 160, 100, 40);
    [btn1 setTitle:@"计步" forState:UIControlStateNormal];
    btn1.backgroundColor = [UIColor cyanColor];
    [imageView addSubview:btn1];
    [btn1 addTarget:self action:@selector(onClickBtn1) forControlEvents:UIControlEventTouchUpInside];
    btn1.userInteractionEnabled = NO;
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(50, 280, 100, 40);
    [btn2 setTitle:@"距离" forState:UIControlStateNormal];
    btn2.backgroundColor = [UIColor cyanColor];
    [imageView addSubview:btn2];
    btn2.userInteractionEnabled = NO;
    [btn2 addTarget:self action:@selector(onClickBtn2) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(self.view.frame.size.width / 2 - 50, self.view.frame.size.height - 80, 100, 50);
    [btn3 setTitle:@"刷新" forState:UIControlStateNormal];
    btn3.backgroundColor = [UIColor cyanColor];
    [imageView addSubview:btn3];
    [btn3 addTarget:self action:@selector(onClickBtn3) forControlEvents:UIControlEventTouchUpInside];
    
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 100, 80, 200, 40)];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.font = [UIFont systemFontOfSize:20];
    timeLabel.textAlignment = 1;
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.text = str;
    [imageView addSubview:timeLabel];
    
    stepLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, self.view.frame.size.height - 100, 200, 40)];
//    stepLabel.backgroundColor = [UIColor cyanColor];
    stepLabel.textColor = [UIColor whiteColor];
//    stepLabel.alpha = 0.4f;
    stepLabel.layer.cornerRadius = 3.0f;
    [imageView addSubview:stepLabel];
    
    distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 , self.view.frame.size.height - 100, 200, 40)];
//    distanceLabel.backgroundColor = [UIColor cyanColor];
    distanceLabel.textColor = [UIColor whiteColor];
    distanceLabel.layer.cornerRadius = 3.0f;
//    distanceLabel.alpha = 0.4f;
    [imageView addSubview:distanceLabel];
//    [self.view bringSubviewToFront:imageView];
    
    btn1.hidden = YES;
    
    btn2.hidden = YES;
    btn3.hidden = YES;
    
    

}

#pragma mark - NSNotificationCenter
- (void)playbackStateChanged
{
    MPMoviePlaybackState playbackState = [self.moviePlayerController playbackState];
    if (playbackState == MPMoviePlaybackStateStopped || playbackState == MPMoviePlaybackStatePaused) {
        [self.moviePlayerController play];
    }
}

#pragma mark - setter and getter
- (MPMoviePlayerController *)moviePlayerController
{
    if (!_moviePlayerController) {
        _moviePlayerController = [[MPMoviePlayerController alloc] init];
        _moviePlayerController.movieSourceType = MPMovieSourceTypeFile;
        _moviePlayerController.controlStyle = MPMovieControlStyleNone;
        _moviePlayerController.view.frame = [UIScreen mainScreen].bounds;
        [_moviePlayerController setFullscreen:YES];
        [_moviePlayerController setShouldAutoplay:YES];
        [_moviePlayerController setRepeatMode:MPMovieRepeatModeOne];
        [self.view addSubview:self.moviePlayerController.view];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackStateChanged) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
        
    }
    return _moviePlayerController;
}



- (void)onClickBtn1
{
    HealthKitManage *manage = [HealthKitManage shareInstance];
    [manage authorizeHealthKit:^(BOOL success, NSError *error) {
        
        if (success) {
            NSLog(@"success");
            [manage getStepCount:^(double value, NSError *error) {
                NSLog(@"1count-->%.0f", value);
                NSLog(@"1error-->%@", error.localizedDescription);
                dispatch_async(dispatch_get_main_queue(), ^{
                    stepLabel.text = [NSString stringWithFormat:@"步数：%.0f步", value];
                });
                
            }];
        }
        else {
            NSLog(@"fail");
        }
    }];
}

- (void)onClickBtn2
{
    HealthKitManage *manage = [HealthKitManage shareInstance];
    [manage authorizeHealthKit:^(BOOL success, NSError *error) {
        
        if (success) {
            NSLog(@"success");
            [manage getDistance:^(double value, NSError *error) {
                NSLog(@"2count-->%.2f", value);
                NSLog(@"2error-->%@", error.localizedDescription);
                dispatch_async(dispatch_get_main_queue(), ^{
                    distanceLabel.text = [NSString stringWithFormat:@"公里数：%.2f公里", value];
                });
                
            }];
        }
        else {
            NSLog(@"fail");
        }
    }];
}

- (void)onClickBtn3 {

    [self onClickBtn1];
    [self onClickBtn2];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
