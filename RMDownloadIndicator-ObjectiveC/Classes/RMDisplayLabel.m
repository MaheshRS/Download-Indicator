//
//  RMDisplayLabel.m
//  BezierLoaders
//
//  Created by Mahesh on 1/30/14.
//  Copyright (c) 2014 Mahesh. All rights reserved.
//

#import "RMDisplayLabel.h"

@interface RMDisplayLabel()

@property(nonatomic, assign)CGFloat toValue;
@property(nonatomic, assign)CGFloat fromValue;
@property(nonatomic, strong)NSTimer *countTimer;

@end

@implementation RMDisplayLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)updateValue:(CGFloat)value
{
    self.toValue = floor((value * 100));
    self.fromValue = [self.text floatValue];
    
    self.countTimer = [NSTimer scheduledTimerWithTimeInterval:0.04 target:self selector:@selector(addUpTimer) userInfo:nil repeats:YES];
    
    // Change the text
    self.text = [NSString stringWithFormat:@"%i",(int)(value * 100)];
}

-(void)addUpTimer {
    
    self.fromValue++;
    
    if((int)self.fromValue > (int)self.toValue)
    {
        [self.countTimer invalidate];
        self.countTimer = nil;
    }
        
    self.text = [NSString stringWithFormat:@"%d", (int)self.fromValue];
    
}

@end
