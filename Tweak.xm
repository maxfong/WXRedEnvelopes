#import "WCPayC2CMessageNodeView.h"         //红包View里的Cell
#import "NewMainFrameViewController.h"      //聊天列表
#import "BaseMsgContentViewController.h"    //聊天窗口
#import "MMUINavigationController.h"        //导航栏
#import "WCRedEnvelopesReceiveHomeView.h"   //基于window的红包窗口
#import "WCRedEnvelopesRedEnvelopesDetailViewController.h"  //领取金额页，打开即可关闭

%hook NewMainFrameViewController

- (void)viewDidLoad {
    %orig;
    //开启
    [[NSUserDefaults standardUserDefaults] setValue:@(1) forKey:@"MAXDebugWX"];

    //开关设置有点问题
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect rect = [[UIScreen mainScreen] bounds];
    [button setFrame:CGRectMake(rect.size.width - 50, 100, 30, 30)];
    [button setBackgroundColor:[UIColor redColor]];
    [button setTitle:@"关" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickRedSwitch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)clickRedSwitch:(UIButton *)sender {
    UIButton *button = (UIButton *)sender;
    if (button) {
        button.tag = !button.tag;
        [[NSUserDefaults standardUserDefaults] setValue:@(button.tag) forKey:@"MAXDebugWX"];
        [button setTitle:(button.tag ? @"开" : @"关") forState:UIControlStateNormal];
    }
}

%end

%hook BaseMsgContentViewController

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = %orig;
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"MAXDebugWX"] boolValue]) {
        UIView *view = ((UIView *)cell.subviews[0]).subviews[0];
        if ([view isKindOfClass:NSClassFromString(@"WCPayC2CMessageNodeView")]) {
            WCPayC2CMessageNodeView *hv = (WCPayC2CMessageNodeView *)view;
            [hv onClick];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication].keyWindow.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
                 {
                     if ([obj isKindOfClass:NSClassFromString(@"WCRedEnvelopesReceiveHomeView")]) {
                         WCRedEnvelopesReceiveHomeView *hv = (WCRedEnvelopesReceiveHomeView *)obj;
                         [hv OnOpenRedEnvelopes];
                         [hv OnCancelButtonDone];
                     }
                 }];
            });
        }
    }
    
    return cell;
}

%end

%hook WCRedEnvelopesRedEnvelopesDetailViewController

- (void)viewDidAppear:(BOOL)animated {
    %orig;
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"MAXDebugWX"] boolValue]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

%end

