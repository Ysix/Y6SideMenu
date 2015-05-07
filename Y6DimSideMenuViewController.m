//
//  Y6DimSideMenuViewController.m
//  rad
//
//  Created by Eddy Claessens on 01/01/2015.
//  Copyright (c) 2015 ysixapps. All rights reserved.
//

#import "Y6DimSideMenuViewController.h"

@interface Y6DimSideMenuViewController ()

@end

@implementation Y6DimSideMenuViewController

- (void)loadView
{
    [super loadView];

    dimmedView = [[UIView alloc] init];
    [dimmedView setBackgroundColor:[UIColor blackColor]];
    [mainView addSubview:dimmedView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self respondsToSelector:@selector(prefersStatusBarHidden)] && ![[UIApplication sharedApplication] isStatusBarHidden]) // if iOS >= 7 and statusBar visible
    {
        [dimmedView setFrame:CGRectMake(0, 0, mainView.frame.size.width, mainView.frame.size.height)];
    }
    else
    {
        [dimmedView setFrame:mainView.bounds];
    }
}

- (void)menuInTransitionAtOpeningPercent:(float)percent
{
    [super menuInTransitionAtOpeningPercent:percent];
    
    if (!([[mainView subviews] lastObject] == dimmedView) || dimmedView.hidden)
    {
        [dimmedView setHidden:NO];
        [mainView bringSubviewToFront:dimmedView];
    }
    
    [dimmedView setAlpha:MAX_DIM * percent / 100];
}

- (void)sideMenuDidClose
{
    [super sideMenuDidClose];
    
    [dimmedView setHidden:YES];
}

@end
