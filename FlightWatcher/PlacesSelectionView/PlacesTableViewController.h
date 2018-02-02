//
//  PlacesTableViewController.h
//  FlightWatcher
//
//  Created by Xan Kraegor on 02.02.2018.
//  Copyright © 2018 Xan Kraegor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"

@interface PlacesTableViewController : UITableViewController
- (instancetype)initWithStyle:(UITableViewStyle)style toReturnOrigin:(bool)isOrigin;
@end
