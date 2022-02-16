//
//  CropCtrl.m
//  CropDemo
//
//  Created by HaoCold on 2022/2/14.
//

#import "CropCtrl.h"
#import "PECropView.h"

@interface CropCtrl ()

/// 图片剪裁
@property (nonatomic,  strong) PECropView *cropView;
@property (nonatomic,  strong) UIImageView *imageView;

/// 底部
@property (nonatomic,  strong) UIView *bottomView;

@end

@implementation CropCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"剪裁";
    [self xjh_setupViews];
    
}

- (void)xjh_setupViews
{
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.cropView];
    [self.view addSubview:self.bottomView];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 0;
        button.frame = CGRectMake(0, 0, 90, 44);
        button.backgroundColor = [UIColor lightGrayColor];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button setTitle:@"切换图片" forState:0];
        [button setTitleColor:[UIColor blackColor] forState:0];
        [button addTarget:self action:@selector(change:) forControlEvents:1<<6];
        button;
    })];
    /*
     默认会以图片的尺寸，来做剪裁框
    
     等 cropView 的默认设置完成后，再设置我们想要的尺寸！
     */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setupImageCropRect];
    });
}

- (UIButton *)setupButton:(NSString *)title tag:(NSInteger)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = tag;
    button.frame = CGRectMake(0, 0, 74, 50);
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitle:title forState:0];
    [button setTitleColor:[UIColor whiteColor] forState:0];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:1<<6];
    return button;
}

#pragma mark -------------------------------------事件-------------------------------------------

- (void)setupImageCropRect
{
    // 剪裁区域比例固定，高宽比：高 / 宽 = 1.5
    
    // 把剪裁区域放在图片中间
    CGFloat w = 0, h = 0;
    CGSize size = _cropView.image.size;
    if (size.height / size.width >= 1.5) {
        w = size.width;
        h = w * 1.5;
        CGFloat y = (size.height - h) * 0.5;
        _cropView.imageCropRect = CGRectMake(0, y, w, h);
    }else{
        h = size.height;
        w = h / 1.5;
        CGFloat x = (size.width - w) * 0.5;
        _cropView.imageCropRect = CGRectMake(x, 0, w, h);
    }
}

- (void)buttonAction:(UIButton *)button
{
    if (button.tag == 100) {
        _cropView.hidden = NO;
    }else if (button.tag == 200) {
        _imageView.image = _cropView.croppedImage;
        _cropView.hidden = YES;
    }
}

- (void)change:(UIButton *)button
{
    if (button.tag == 0) {
        button.tag = 1;
        
        _cropView.image = [UIImage imageNamed:@"image"];
    }else{
        button.tag = 0;
        
        _cropView.image = [UIImage imageNamed:@"jpg"];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setupImageCropRect];
    });
}

#pragma mark -------------------------------------懒加载-----------------------------------------

- (PECropView *)cropView{
    if (!_cropView) {
        _cropView = [[PECropView alloc] initWithFrame:CGRectMake(0, 88, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-88-50-34)];
        _cropView.clipsToBounds = YES;
        _cropView.backgroundColor = [UIColor blackColor];
        
        _cropView.rotationGestureRecognizer.enabled = NO; // 禁止旋转图片
        _cropView.freezeSize = YES;  // 让剪裁框不可调整
        _cropView.showsGridMajor = NO; // 不显示网格
        _cropView.image = [UIImage imageNamed:@"jpg"];
        _cropView.scrollView.bouncesZoom = YES; // 缩放回弹
        _cropView.scrollView.bounces = YES; // 回弹效果
    }
    return _cropView;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = self.cropView.frame;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView = imageView;
    }
    return _imageView;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        CGFloat h = 50+34;
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds)-h, CGRectGetWidth(self.view.bounds), h);
        view.backgroundColor = [UIColor blackColor];
        _bottomView = view;
        
        // 左边 - 取消
        UIButton *cancelButton = [self setupButton:@"取消" tag:100];
        // 右边 - 上传
        UIButton *cropButton = [self setupButton:@"剪裁" tag:200];
        
        [view addSubview:cancelButton];
        [view addSubview:cropButton];
        
        
        cropButton.frame = CGRectMake(CGRectGetWidth(view.bounds)-CGRectGetWidth(cropButton.bounds), 0, CGRectGetWidth(cropButton.bounds), CGRectGetHeight(cropButton.bounds));
    }
    return _bottomView;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
