//
//  PNSmartTableViewCell.h
//  SmartTableCell
//
//  Created by mac on 13-11-5.
//  Copyright (c) 2013年 bjpowernode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QYSmartTableViewCell : UITableViewCell

+(id)cellForTableViewWithIdentifer:(UITableView*)tableView withCellStyle:(UITableViewCellStyle)style;
+(NSString*)identifier;

- (id)initWithIdentifier:(NSString*)cellID withCellStyle:(UITableViewCellStyle)style;
@end
