//
//  Y6SideMenuViewController.m
//  Y6SideMenuViewController
//
//  Created by Ysix on 07/04/2014.
//
//

#import "Y6SideMenuViewController.h"



@interface Y6SideMenuViewController () <UIScrollViewDelegate>
{
	UIView			*dimissSideMenuView;
}

@end

@implementation Y6SideMenuViewController

@synthesize mainView, sideMenuView, closeMenuOnAppear;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
	[super loadView];

    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)])
	{
		[self setAutomaticallyAdjustsScrollViewInsets:NO];
	}

	sideMenuView = [[UIView alloc] init];
    [self.view addSubview:sideMenuView];

    globalSV = [[UIScrollView alloc] init];
    [globalSV setDelegate:self];
//	[globalSV setPagingEnabled:YES];
	[globalSV setBounces:NO];
	[globalSV setDecelerationRate:UIScrollViewDecelerationRateFast];
    [globalSV setShowsHorizontalScrollIndicator:NO];
	if ([globalSV respondsToSelector:@selector(setKeyboardDismissMode:)])
		[globalSV setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];

    mainView =  [[UIView alloc] init];

	dimissSideMenuView = [[UIView alloc] init];
	[dimissSideMenuView	addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sideMenuClicked)]];
	[mainView addSubview:dimissSideMenuView];

	[globalSV addSubview:mainView];


    [self.view addSubview:globalSV];


	[globalSV setFrame:self.view.frame];

    [sideMenuView setFrame:CGRectMake((OPEN_ON_RIGHT ? self.view.frame.size.width - [self getSideMenuWidth] : 0), 0, [self getSideMenuWidth], self.view.frame.size.height)];

    [mainView setFrame:CGRectMake((OPEN_ON_RIGHT ? 0 : sideMenuView.frame.size.width), 0, globalSV.frame.size.width, globalSV.frame.size.height)];
	[dimissSideMenuView setFrame:mainView.bounds];

    [globalSV setContentSize:CGSizeMake(mainView.frame.size.width + sideMenuView.frame.size.width, self.view.frame.size.height)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (!closeMenuOnAppear)
    {
        [globalSV setContentOffset:GLOBALSV_MENU_CLOSED_OFFSET animated:NO];
    }
    else
    {
        [globalSV setContentOffset:GLOBALSV_MENU_OPENED_OFFSET animated:NO];
    }

	[self scrollViewDidScroll:globalSV];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	if (closeMenuOnAppear)
    {
        [globalSV setContentOffset:GLOBALSV_MENU_CLOSED_OFFSET animated:YES];
        closeMenuOnAppear = NO;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];

	[globalSV setContentOffset:GLOBALSV_MENU_CLOSED_OFFSET];
}

#pragma mark - Menu Opening Methods

- (void)sideMenuClicked
{
	[dimissSideMenuView setHidden:YES];

    if (globalSV.contentOffset.x == GLOBALSV_MENU_CLOSED_OFFSET.x)
    {
        [globalSV setContentOffset:GLOBALSV_MENU_OPENED_OFFSET animated:YES];
    }
    else if (globalSV.contentOffset.x == GLOBALSV_MENU_OPENED_OFFSET.x)
    {
        [globalSV setContentOffset:GLOBALSV_MENU_CLOSED_OFFSET animated:YES];
    }
}

- (void)sideMenuDidOpen
{

    if (dimissSideMenuView.hidden)
	{
		[dimissSideMenuView setHidden:NO];
		[dimissSideMenuView.superview bringSubviewToFront:dimissSideMenuView];
	}

}

- (void)sideMenuDidClose
{
	[dimissSideMenuView setHidden:YES];
}

- (void)menuInTransitionAtOpeningPercent:(float)percent
{

}

#pragma mark - ScrollView Delegates Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	if (scrollView == globalSV)
	{
		float openedPercent = (scrollView.contentOffset.x * 100.0 / [self getSideMenuWidth]);

		if (!OPEN_ON_RIGHT)
			openedPercent = 100 - openedPercent;

		NSLog(@"endDecelerating : %f", openedPercent);

		if (openedPercent >= 50)
		{
			[globalSV setContentOffset:GLOBALSV_MENU_OPENED_OFFSET animated:YES];
		}
		else
		{
			[globalSV setContentOffset:GLOBALSV_MENU_CLOSED_OFFSET animated:YES];
		}
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (scrollView == globalSV && decelerate == NO)
	{
		float openedPercent = (scrollView.contentOffset.x * 100.0 / [self getSideMenuWidth]);

		if (!OPEN_ON_RIGHT)
			openedPercent = 100 - openedPercent;

		NSLog(@"endDragging : %f, decelerate : %d", openedPercent, decelerate);

		if (openedPercent >= 50)
		{
			[globalSV setContentOffset:GLOBALSV_MENU_OPENED_OFFSET animated:YES];
		}
		else
		{
			[globalSV setContentOffset:GLOBALSV_MENU_CLOSED_OFFSET animated:YES];
		}
	}
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
	if (scrollView == globalSV)
	{
		float openedPercent = (scrollView.contentOffset.x * 100.0 / [self getSideMenuWidth]);

		if (!OPEN_ON_RIGHT)
			openedPercent = 100 - openedPercent;

		NSLog(@"endScrollingAnimation : %f", openedPercent);

		if (openedPercent >= 50)
		{
			[globalSV setContentOffset:GLOBALSV_MENU_OPENED_OFFSET animated:YES];
		}
		else
		{
			[globalSV setContentOffset:GLOBALSV_MENU_CLOSED_OFFSET animated:YES];
		}
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == globalSV)
    {
		float openedPercent = (scrollView.contentOffset.x * 100.0 / [self getSideMenuWidth]);

		if (!OPEN_ON_RIGHT)
			openedPercent = 100 - openedPercent;

        [self menuInTransitionAtOpeningPercent:(openedPercent < 0 ? 0 : openedPercent)];

//        if ((OPEN_ON_RIGHT && scrollView.contentOffset.x < GLOBALSV_MENU_CLOSED_OFFSET.x) || (!OPEN_ON_RIGHT && scrollView.contentOffset.x > GLOBALSV_MENU_CLOSED_OFFSET.x))
//            [scrollView setContentOffset:GLOBALSV_MENU_CLOSED_OFFSET animated:NO];

        if (scrollView.contentOffset.x == GLOBALSV_MENU_OPENED_OFFSET.x)
        {
            [self.view bringSubviewToFront:sideMenuView];
            [self sideMenuDidClose];
        }
        else
            [self.view sendSubviewToBack:sideMenuView];

        if (scrollView.contentOffset.x == GLOBALSV_MENU_CLOSED_OFFSET.x)
            [self sideMenuDidOpen];
    }
}

- (CGFloat)getSideMenuWidth
{
	return DEFAULT_SIDE_MENU_WIDTH;
}


@end
