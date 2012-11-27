//
//  TextViewController.m
//  JCKeyboardNotificationManagerExample
//
//  Created by Jehiah Czebotar on 11/26/12.
//  Copyright (c) 2012 Jehiah Czebotar. All rights reserved.
//

#import "TextViewController.h"
#import "JCKeyboardNotificationManager.h"

@interface TextViewController ()

@end

@implementation TextViewController
@synthesize kbmgr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.textView.text = @"This is a UITextView that fills the parent view, and JCKeyboardNotificationManager is used to adjust the parent view size as the keyboard is dispalyed, changed and hidden. \n\n\nWhen editing, the view will resize, and the textView will fit the visible area. It will be possible to scroll to the bottom because the parent view is resized, and you can even rotate the device and the view size will match. Also, if the keyboard size is switched (try switching to a kanji or emoji keyboard) things will resize. \n\n\n\n\n\n\n\n\nIf you start editing text down here, a block will execute at keyboard appearance to scroll to this location if selected.";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.kbmgr = [JCKeyboardNotificationManager JCKeyboardNotificationManagerForView:self.view];
    [self.kbmgr startWatching];
    self.kbmgr.block = ^{
        if ([self.textView isFirstResponder]) {
            [self.textView scrollRangeToVisible:self.textView.selectedRange];
        }
    };
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.kbmgr stopWatching];
    self.kbmgr.block = nil;
    self.kbmgr = nil;
    [super viewDidDisappear:animated];
}

- (IBAction)doneEdit:(id)sender
{
    [self.textView resignFirstResponder];
}


@end
