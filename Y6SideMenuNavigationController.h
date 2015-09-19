//
//  Y6SideMenuNavigationController.h
//
//
//  Created by Ysix on 18/04/2014.
//
//

#import <UIKit/UIKit.h>

@interface Y6SideMenuNavigationController : UINavigationController

@property (nonatomic) BOOL popToRootOnChange;
@property (nonatomic, readonly) int currentSection;


- (void)addSectionWithViewController:(UIViewController *)rootViewController name:(NSString *)name andAnyInfos:(NSDictionary *)infos;

- (void)addSectionWithViewController:(UIViewController *)rootViewController name:(NSString *)name;

- (NSArray *)getSectionInfos;

- (void)goToSectionAtIndex:(int)sectionIndex;
- (void)goToSectionAtIndex:(int)sectionIndex animated:(BOOL)animated;
- (UIViewController *)rootViewControllerForSection:(int)sectionIndex;

@end
