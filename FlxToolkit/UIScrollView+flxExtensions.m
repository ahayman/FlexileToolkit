//
//  UIScrollViewExtensions.m
//  iDB
//
//  Created by Aaron Hayman on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIScrollView+flxExtensions.h"
#define BounceVector 25
#define BounceTime .10

@implementation UIScrollView (flxExtensions)
- (void) bounceLeft{
    [UIView animateWithDuration:BounceTime delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.contentOffset = CGPointMake(self.contentOffset.x + BounceVector, self.contentOffset.y);
    }completion: ^(BOOL fin){
        [UIView animateWithDuration:BounceTime delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.contentOffset = CGPointMake(self.contentOffset.x - BounceVector, self.contentOffset.y);
        }completion:nil];
    }];
}
- (void) bounceRight{
    [UIView animateWithDuration:BounceTime delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.contentOffset = CGPointMake(self.contentOffset.x - BounceVector, self.contentOffset.y);
    }completion: ^(BOOL fin){
        [UIView animateWithDuration:BounceTime delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.contentOffset = CGPointMake(self.contentOffset.x + BounceVector, self.contentOffset.y);
        }completion:nil];
    }];
}
- (void) bounceUp{
    [UIView animateWithDuration:BounceTime delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.contentOffset = CGPointMake(self.contentOffset.x, self.contentOffset.y - BounceVector);
    }completion: ^(BOOL fin){
        [UIView animateWithDuration:BounceTime delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.contentOffset = CGPointMake(self.contentOffset.x, self.contentOffset.y + BounceVector);
        }completion:nil];
    }];
}
- (void) bounceDown{
    [UIView animateWithDuration:BounceTime delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.contentOffset = CGPointMake(self.contentOffset.x, self.contentOffset.y + BounceVector);
    }completion: ^(BOOL fin){
        [UIView animateWithDuration:BounceTime delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.contentOffset = CGPointMake(self.contentOffset.x, self.contentOffset.y - BounceVector);
        }completion:nil];
    }];
}
@end
