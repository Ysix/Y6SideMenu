//
//  Y6SideMenuNavigationController.m
//
//
//  Created by Ysix on 18/04/2014.
//
//

#import "Y6SideMenuNavigationController.h"

#import "Y6SideMenuViewController.h"

@interface Y6SideMenuNavigationController ()
{
	NSMutableArray *navigationControllerAR;

	int currentSection;

	NSArray *sectionsInfosAR;
}

@end

@implementation Y6SideMenuNavigationController

@synthesize popToRootOnChange, currentSection;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization

		navigationControllerAR = [[NSMutableArray alloc] init];
		currentSection = -1;

		[self setNavigationBarHidden:YES];
    }
    return self;
}

- (void)addSectionWithViewController:(UIViewController *)rootViewController name:(NSString *)name
{
	[self addSectionWithViewController:rootViewController name:name andAnyInfos:nil];
}


- (void)addSectionWithViewController:(UIViewController *)rootViewController name:(NSString *)name andAnyInfos:(NSDictionary *)infos
{
	NSMutableDictionary *infosDict = [[NSMutableDictionary alloc] init];

	if (!rootViewController)
		return;
	[infosDict setObject:@[rootViewController] forKey:@"viewControllers"];

	if (!name)
		return;
	[infosDict setObject:name forKey:@"name"];

	if (infos)
		[infosDict setObject:infos forKey:@"infos"];

	[navigationControllerAR addObject:infosDict];

	if (currentSection == -1)
	{
		[self setViewControllers:@[rootViewController]];
		currentSection = 0;
	}
}

- (NSArray *)getSectionInfos
{
	if (sectionsInfosAR && [sectionsInfosAR count] == [navigationControllerAR count])
		return sectionsInfosAR;

	NSMutableArray *infosAR = [[NSMutableArray alloc] init];

	for (NSDictionary *dict in navigationControllerAR)
	{
		NSMutableDictionary *infosDict = [NSMutableDictionary dictionaryWithDictionary:[dict objectForKey:@"infos"]];
		[infosDict setValue:[dict objectForKey:@"name"] forKey:@"name"];

		[infosAR addObject:infosDict];
	}

	sectionsInfosAR = infosAR;

	return infosAR;
}

- (void)goToSectionAtIndex:(int)sectionIndex
{
    [self goToSectionAtIndex:sectionIndex animated:YES];
}

- (void)goToSectionAtIndex:(int)sectionIndex animated:(BOOL)animated
{
	if (sectionIndex == currentSection)
	{
		if ([[self viewControllers] count] > 1)
		{
			if ([[[[navigationControllerAR objectAtIndex:currentSection] objectForKey:@"viewControllers"] firstObject] respondsToSelector:@selector(setCloseMenuOnAppear:)])
			{
				[(Y6SideMenuViewController *)[[[navigationControllerAR objectAtIndex:currentSection] objectForKey:@"viewControllers"] firstObject] setCloseMenuOnAppear:animated];
			}
			[self popToRootViewControllerAnimated:NO];
		}
		else if ([[[[navigationControllerAR objectAtIndex:currentSection] objectForKey:@"viewControllers"] firstObject] respondsToSelector:@selector(sideMenuClicked)])
		{
			[(Y6SideMenuViewController *)[[[navigationControllerAR objectAtIndex:currentSection] objectForKey:@"viewControllers"] firstObject] sideMenuClicked];
		}
		return;
	}

	if (!popToRootOnChange)
		[[navigationControllerAR objectAtIndex:currentSection] setObject:self.viewControllers forKey:@"viewControllers"];

	if ([[[[navigationControllerAR objectAtIndex:sectionIndex] objectForKey:@"viewControllers"] lastObject] respondsToSelector:@selector(setCloseMenuOnAppear:)])
	{
		[(Y6SideMenuViewController *)[[[navigationControllerAR objectAtIndex:sectionIndex] objectForKey:@"viewControllers"] lastObject] setCloseMenuOnAppear:animated];
	}
    
	[self setViewControllers:[[navigationControllerAR objectAtIndex:sectionIndex] objectForKey:@"viewControllers"]];
    
	currentSection = sectionIndex;
}



@end
