JCKeyboardNotificationManager
=============================

A class that helps manage resizing views when the keybaord appears and dissapears. 

Most code examples only handle UIKeyboardWillShowNotification and UIKeyboardWillHideNotification, this 
also handles UIKeyboardWillChangeFrameNotification which covers when users change keyboard 
languages (some keyboards, like emoji, are different heights).

In your .h:

```objectivec
@property (nonatomic, retain) KeyboardNotificationManager *kbmgr;
```

In your .m:

```objectivec
@synthesize kbmgr;

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
```

