//
//  MainViewController.h
//  QuickVelov
//
//  Created by AW2P on 10/08/12.
//  Copyright (c) 2012 AW2P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VelovManager.h"

@interface MainViewController : UITableViewController
{
    VelovManager* _velovManager;
}

@property(readonly, strong) VelovManager* velovManager;

- (void)reloadStations;

@end
