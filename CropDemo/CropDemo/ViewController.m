//
//  ViewController.m
//  CropDemo
//
//  Created by HaoCold on 2022/2/14.
//

#import "ViewController.h"
#import "CropCtrl.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 120, 62);
    button.backgroundColor = [UIColor lightGrayColor];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitle:@"PECropView" forState:0];
    [button setTitleColor:[UIColor blackColor] forState:0];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:1<<6];
    [self.view addSubview:button];
    button.center = self.view.center;
}

- (void)buttonAction
{
    [self.navigationController pushViewController:[[CropCtrl alloc] init] animated:YES];
}

@end
