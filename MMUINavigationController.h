@interface MMUINavigationController : UINavigationController
{
    UIViewController *_popingViewController;
}

- (void)layoutViewsForTaskBar;
- (void)viewWillLayoutSubviews;
- (void)viewDidLoad;
- (void)viewWillAppear:(BOOL)arg1;
- (id)popViewControllerAnimated:(BOOL)arg1;
- (id)DispatchPopViewControllerAnimated:(BOOL)arg1;

@end