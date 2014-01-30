//
//  RMDownloadIndicator.h
//  BezierLoaders
//
//  Created by Mahesh on 1/30/14.
//  Copyright (c) 2014 Mahesh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kRMClosedIndicator=0,
    kRMFilledIndicator,
    kRMMixedIndictor,
}RMIndicatorType;

@interface RMDownloadIndicator : UIView

// this value should be 0 to 0.5 (default: (kRMFilledIndicator = 0.5), (kRMMixedIndictor = 0.4))
@property(nonatomic, assign)CGFloat radiusPercent;

// used to fill the downloaded percent slice (default: (kRMFilledIndicator = white), (kRMMixedIndictor = white))
@property(nonatomic, strong)UIColor *fillColor;

// used to stroke the covering slice (default: (kRMClosedIndicator = white), (kRMMixedIndictor = white))
@property(nonatomic, strong)UIColor *strokeColor;

// used to stroke the background path the covering slice (default: (kRMClosedIndicator = gray))
@property(nonatomic, strong)UIColor *closedIndicatorBackgroundStrokeColor;

// init with frame and type
// if() - (id)initWithFrame:(CGRect)frame is used the default type = kRMFilledIndicator
- (id)initWithFrame:(CGRect)frame type:(RMIndicatorType)type;

// prepare the download indicator
- (void)loadIndicator;

// update the downloadIndicator
- (void)updateWithTotalBytes:(CGFloat)bytes downloadedBytes:(CGFloat)downloadedBytes;

@end
