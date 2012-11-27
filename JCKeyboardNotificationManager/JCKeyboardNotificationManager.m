//
//  JCKeyboardNotificationManager.m
//
//  Created by Jehiah Czebotar on 11/3/12.
//
//

#import "JCKeyboardNotificationManager.h"

@implementation JCKeyboardNotificationManager
@synthesize watchedView;
@synthesize lastKeyboardHeight;

+ (JCKeyboardNotificationManager *) JCKeyboardNotificationManagerForView:(UIView *)view {
    JCKeyboardNotificationManager *km = [[JCKeyboardNotificationManager alloc] init];
    km.watchedView = view;
    km.keyboard_needs_adjustment_status = false;
    km.lastKeyboardHeight = 0.0;
    return km;
}
- (void) startWatching {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillAppear:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillDisappear:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChange:)
                                                 name:UIKeyboardWillChangeFrameNotification object:nil];
}
- (void) stopWatching {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.lastKeyboardHeight != 0) {
        CGFloat change = [self getChangeInKeyboardSize:0];
        [self animateSizeChange:change duration:0 cb:FALSE];
        self.keyboard_needs_adjustment_status = NO;
    }
}

-(double) animationDuration:(NSDictionary *) userInfo {
    return [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
}

-(CGFloat) keyboardEndingFrameHeight:(NSDictionary *) userInfo {
    CGRect keyboardEndingUncorrectedFrame =   [[ userInfo objectForKey:UIKeyboardFrameEndUserInfoKey ]  CGRectValue];
    CGRect keyboardEndingFrame =  [self.watchedView convertRect:keyboardEndingUncorrectedFrame  fromView:nil];
    return keyboardEndingFrame.size.height;
}
-(CGFloat) getChangeInKeyboardSize:(CGFloat)newKeyboardSize {
    CGFloat diff = newKeyboardSize - self.lastKeyboardHeight;
    self.lastKeyboardHeight = newKeyboardSize;
    return diff;
}

-(CGRect) adjustFrameHeightBy:(CGFloat) change multipliedBy:(NSInteger) direction {
    CGRect frame = self.watchedView.frame;
    CGRect r = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height + change * direction);
//    NSLog(@"changing by %f from %f to %f", change, frame.size.height, r.size.height);
    return r;
}

-(void)animateSizeChange:(CGFloat)change duration:(double)duration cb:(BOOL)cb {
    CGRect newFrame = [self adjustFrameHeightBy:change multipliedBy:-1];
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.watchedView.frame =  newFrame;
                     }
                     completion:^(BOOL finished) {
                         self.watchedView.frame = newFrame;
                         if (self.block && cb) {
                             self.block();
                         }
                     }];
    
}


-(void)keyboardWillAppear:(NSNotification *)notification {
    if (self.keyboard_needs_adjustment_status) {
        return;
    }
    self.keyboard_needs_adjustment_status = YES;
    CGFloat newKeyboardSize = [self keyboardEndingFrameHeight: [notification userInfo]];
    CGFloat change = [self getChangeInKeyboardSize:newKeyboardSize];
    [self animateSizeChange:change duration:[self animationDuration:[notification userInfo]] cb:TRUE];
}
- (void)keyboardWillChange:(NSNotification *)notification
{
    if (self.keyboard_needs_adjustment_status) {
        CGFloat newKeyboardSize = [self keyboardEndingFrameHeight: [notification userInfo]];
        CGFloat change = [self getChangeInKeyboardSize:newKeyboardSize];
        [self animateSizeChange:change duration:[self animationDuration:[notification userInfo]] cb:TRUE];
    }
}

-(void)keyboardWillDisappear:(NSNotification *) notification {
    if (self.keyboard_needs_adjustment_status) {
        CGFloat change = [self getChangeInKeyboardSize:0];
        [self animateSizeChange:change duration:[self animationDuration:[notification userInfo]] cb:FALSE];
    }
    else{
        // if kb is undocked or split
    }
    self.keyboard_needs_adjustment_status = NO;
}
@end
