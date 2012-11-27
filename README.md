JCKeyboardNotificationManager
=============================

A class that helps manage resizing views when the keybaord appears and when it dissapears

```
@property (nonatomic, retain) KeyboardNotificationManager *kbmgr;
```

```
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

