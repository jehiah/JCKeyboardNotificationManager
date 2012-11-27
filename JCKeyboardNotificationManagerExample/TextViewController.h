//
//  TextViewController.h
//  JCKeyboardNotificationManagerExample
//
//  Created by Jehiah Czebotar on 11/26/12.
//  Copyright (c) 2012 Jehiah Czebotar. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JCKeyboardNotificationManager;

@interface TextViewController : UIViewController
@property (nonatomic, retain) JCKeyboardNotificationManager *kbmgr;
@property (retain, nonatomic) IBOutlet UITextView *textView;
- (IBAction)doneEdit:(id)sender;

@end
