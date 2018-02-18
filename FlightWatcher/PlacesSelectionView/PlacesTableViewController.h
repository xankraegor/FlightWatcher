//
//  PlacesTableViewController.h
//  FlightWatcher
//
//  Created by Xan Kraegor on 02.02.2018.
//  Copyright © 2018 Xan Kraegor. All rights reserved.
//

#import "DataSourceTypeEnum.h"


@protocol PlaceViewControllerDelegate <NSObject>
- (void)selectPlace:(id)place withType:(bool)isOrigin andDataType:(DataSourceType)dataType;
@end

@interface PlacesTableViewController : UITableViewController
@property(nonatomic, strong) id <PlaceViewControllerDelegate> delegate;

- (instancetype)initWithStyle:(UITableViewStyle)style toReturnOrigin:(bool)isOrigin;
@end
