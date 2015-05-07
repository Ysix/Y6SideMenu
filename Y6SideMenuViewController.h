//
//  Y6SideMenuViewController.h
//  Y6SideMenuViewController
//
//  Created by Ysix on 07/04/2014.
//
//

#import <UIKit/UIKit.h>

#define SIDE_MENU_EXIST

#define DEFAULT_SIDE_MENU_WIDTH 270 // in pixels

#define OPEN_ON_RIGHT NO // for changing the side of the menu

#define GLOBALSV_MENU_CLOSED_OFFSET ((OPEN_ON_RIGHT ? CGPointMake(0, 0) : CGPointMake(sideMenuView.frame.size.width, 0)))
#define GLOBALSV_MENU_OPENED_OFFSET ((OPEN_ON_RIGHT ? CGPointMake(sideMenuView.frame.size.width, 0) : CGPointMake(0, 0)))


@interface Y6SideMenuViewController : UIViewController
{
    UIView          *sideMenuView;
    UIView          *mainView;
    UIView			*dimissSideMenuView;

    BOOL            closeMenuOnAppear;
    UIScrollView    *globalSV;
}

@property	(nonatomic) 	BOOL            closeMenuOnAppear; // if set to YES the view controller will be shown with the menu open and will be closing it with an animation, basically set this to YES when the user change the current section in the side menu, this will be re-set to NO on each viewWillAppear 

@property (nonatomic, strong) UIView *mainView; // must be used instead of self.superview

@property (nonatomic, strong) UIView *sideMenuView; // the side menu view

- (CGFloat)getSideMenuWidth;

- (void)sideMenuDidClose; // called when the menu is full closed
- (void)sideMenuDidOpen; // called when the menu is full opened
- (void)menuInTransitionAtOpeningPercent:(float)percent; // called when the menu is in transition with the opening percent in parameters
- (void)sideMenuClicked; // call it to close/open the menu via a button or any user action


@end
