//
//  JCKeyboardNotificationManager.h
//
//  Created by Jehiah Czebotar on 11/3/12.
//

#import <Foundation/Foundation.h>

typedef void (^JCKBCallback)(void);

@interface JCKeyboardNotificationManager : NSObject
@property (nonatomic, retain) UIView *watchedView;
@property (nonatomic, assign) BOOL keyboard_needs_adjustment_status;
@property (nonatomic, copy) JCKBCallback block;
@property (nonatomic, assign) CGFloat lastKeyboardHeight;
+ (JCKeyboardNotificationManager *) JCKeyboardNotificationManagerForView:(id)object;
- (void) startWatching;
- (void) stopWatching;
@end
