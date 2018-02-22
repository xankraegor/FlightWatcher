//
//  PlacesTableViewController.h
//  FlightWatcher
//
//  Created by Xan Kraegor on 02.02.2018.
//  Copyright © 2018 Xan Kraegor. All rights reserved.
//

#import "DataSourceTypeEnum.h"
#import "PlaceSelectionReturnType.h"
#import "PlaceSelectionReturnType.h"


@protocol PlaceViewControllerDelegate <NSObject>
- (void)selectPlace:(id)place withType:(PlaceSelectionReturnType)returnType andDataType:(DataSourceType)dataType;
@end

@interface PlacesTableViewController : UITableViewController
@property(nonatomic, strong) id <PlaceViewControllerDelegate> delegate;

- (instancetype)initWithStyle:(UITableViewStyle)style toReturnOrigin:(PlaceSelectionReturnType)returnType;
@end
