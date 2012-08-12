//
//  AppDelegate.h
//  QuickVelov
//
//  Created by AW2P on 10/08/12.
//  Copyright (c) 2012 AW2P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    MainViewController* _mainViewController;
    
    
}

@property (strong, nonatomic) UIWindow *window;

@end
