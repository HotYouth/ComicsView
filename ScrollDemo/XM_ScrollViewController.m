//
//  XM_ScrollViewController.m
//  ScrollDemo
//
//  Created by 王忠诚 on 2018/1/9.
//  Copyright © 2018年 王忠诚. All rights reserved.
//

#import "XM_ScrollViewController.h"
#import "UIImage+ImageEffects.h"

@interface XM_ScrollViewController ()<UIScrollViewDelegate>

/** tableView */
@property(nonatomic, strong) UITableView *tableView;
/** headerHeight */
@property(nonatomic, assign) CGFloat headerHeight;
/** subHeaderHeight */
@property(nonatomic, assign) CGFloat subHeaderHeight;
/** barIsCollapsed */
@property(nonatomic, assign) BOOL barIsCollapsed;
/** barAnimationComplete */
@property(nonatomic, assign) BOOL barAnimationComplete;
/** blurAmount */
@property(nonatomic, assign) CGFloat blurAmount;
/** processingScroll */
@property(nonatomic, assign) BOOL processingScroll;
/** headerSwitchOffset */
@property(nonatomic, assign) CGFloat headerSwitchOffset;
/** originalBackgroundImage */
@property(nonatomic, strong) UIImage *originalBackgroundImage;
/** imageHeaderView */
@property(nonatomic, strong) UIImageView *imageHeaderView;
/** blurredBackgroundImage */
@property(nonatomic, strong) UIImage *blurredBackgroundImage;
/** customTitleView */
@property(nonatomic, strong) UIView *customTitleView;

@end

@implementation XM_ScrollViewController

//- (UITableView *)customTableView {
//    if (!_customTableView) {
//        _customTableView = [[UITableView alloc] initWithFrame:self.view.frame];
//        _customTableView.delegate = self;
//        _customTableView.dataSource = self;
//        _customTableView.contentInset = UIEdgeInsetsMake(0, 0, 55, 0);
//    }
//    return _customTableView;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupTableViewController];
}

- (void)dealloc {
    self.originalBackgroundImage = nil;
    self.blurredBackgroundImage = nil;
}

- (void)setupTableViewController {
    [self configureNavBar];
    self.automaticallyAdjustsScrollViewInsets = YES;
    if (!(self.headerHeight > 0)) {
        CGFloat screenPixelWidth = [[UIScreen mainScreen] bounds].size.width * 0.75;
        CGFloat screenPixelHeight = [[UIScreen mainScreen] bounds].size.height * 0.6;
        self.headerHeight = MIN(screenPixelWidth, screenPixelHeight);
    }
    self.subHeaderHeight = 0.0;
    self.barIsCollapsed = NO;
    self.barAnimationComplete = NO;
    self.blurAmount = 20.0;
    self.processingScroll = NO;
    
    UIApplication *sharedApplication = [UIApplication sharedApplication];
    CGFloat kStatusBarHeight = sharedApplication.statusBarFrame.size.height;
    CGFloat mNavBarHeight = self.navigationController.navigationBar.frame.size.height;
    self.headerSwitchOffset = self.headerHeight - (kStatusBarHeight + mNavBarHeight) - kStatusBarHeight - mNavBarHeight;
    self.tableView = self.customTableView;
    [self.view addSubview:self.customTableView];
    
    if (self.originalBackgroundImage == nil) {
        self.originalBackgroundImage = [UIImage imageNamed:@"timg.jpeg"];
    }
    
    UIImageView *headerImageView = [[UIImageView alloc] initWithImage:self.originalBackgroundImage];
    headerImageView.translatesAutoresizingMaskIntoConstraints = NO;
    headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    headerImageView.clipsToBounds = YES;
    
    self.imageHeaderView = headerImageView;
    
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.headerHeight - (kStatusBarHeight + mNavBarHeight) + self.subHeaderHeight)];
    [tableHeaderView addSubview:headerImageView];
    
    UIView *subHeaderPart = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.subHeaderHeight)];
    subHeaderPart.backgroundColor = [UIColor greenColor];
    [tableHeaderView insertSubview:subHeaderPart belowSubview:headerImageView];
    
    self.customTableView.tableHeaderView = tableHeaderView;
    
    NSArray* constraints;
    NSString* format;
    NSDictionary *views = @{@"headerImageView" : headerImageView};
    NSDictionary* metrics = @{
                              @"minHeaderHeight" : [NSNumber numberWithFloat:(kStatusBarHeight + mNavBarHeight)],
                              @"subHeaderHeight" :[NSNumber numberWithFloat:_subHeaderHeight],
                              };
    format = @"V:[headerImageView(>=minHeaderHeight)]-(subHeaderHeight@750)-|";
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:metrics views:views];
    [self.view addConstraints:constraints];
    
    
    NSLayoutConstraint *magicConstraint = [NSLayoutConstraint constraintWithItem:headerImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0];
    [self.view addConstraint: magicConstraint];
    
    self.blurredBackgroundImage = [self.originalBackgroundImage applyBlurWithRadius:self.blurAmount tintColor:[UIColor colorWithWhite:1 alpha:0.2] saturationDeltaFactor:1.5 maskImage:nil];
    [self changeHeaderBasedOnCustomTableScrolling];
}

- (void)setUpWithTableView:(UITableView *)tableView {
    self.customTableView = tableView;
    [self setupTableViewController];
}


#pragma mark - NavBar configuration

- (void)configureNavBar {
    [self switchToExpandedHeader];
}

- (void)switchToExpandedHeader {
    if (!self.staticNavHeader) {
        self.navigationItem.titleView = nil;
    }
    self.barAnimationComplete = NO;
    self.imageHeaderView.image = self.originalBackgroundImage;
    [self.tableView.tableHeaderView exchangeSubviewAtIndex:1 withSubviewAtIndex:2];
}

- (void)switchToMinifiedHeader {
    self.barAnimationComplete = NO;
    if (!self.staticNavHeader) {
        self.navigationItem.titleView = self.customTitleView;
        self.navigationController.navigationBar.clipsToBounds = YES;
        
        [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:60 forBarMetrics:UIBarMetricsDefault];
    }
    [self.tableView.tableHeaderView exchangeSubviewAtIndex:1 withSubviewAtIndex:2];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [self tableView:tableView heightForHeaderInSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self tableView:tableView viewForHeaderInSection:section];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self changeHeaderBasedOnCustomTableScrolling];
}

- (void)changeHeaderBasedOnCustomTableScrolling {
    if (!_processingScroll) {
        _processingScroll = YES;
        
        CGFloat yPos = self.customTableView.contentOffset.y + 75;
        if (yPos > self.headerSwitchOffset && !self.barIsCollapsed) {
            [self switchToMinifiedHeader];
            self.barIsCollapsed = YES;
        }else if (yPos < self.headerSwitchOffset && self.barIsCollapsed) {
            [self switchToExpandedHeader];
            self.barIsCollapsed = NO;
        }
        if (yPos < 0) {
//            CGFloat newAlpha = (75 + yPos) / 75.0;
            [self removeAllSubviewsOfClass:[UIImageView class] fromView:self.imageHeaderView];
            
        }else {
            
        }
        if (yPos > self.headerSwitchOffset + 20 && yPos <= self.headerSwitchOffset + 20 + 40) {
            CGFloat delta = (40 + 20 - (yPos - self.headerSwitchOffset));
            if (!self.staticNavHeader) {
                [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:delta forBarMetrics:UIBarMetricsDefault];
            }
            float percent = (yPos - (self.headerSwitchOffset + 20)) / 40;
            
            UIImageView *blurred = [[UIImageView alloc] initWithFrame:self.imageHeaderView.bounds];
            blurred.image = self.blurredBackgroundImage;
            blurred.alpha = percent;
            blurred.contentMode = UIViewContentModeScaleAspectFill;
            blurred.clipsToBounds = YES;
            
            [self removeAllSubviewsOfClass:[UIImageView class] fromView:self.imageHeaderView];
            [self.imageHeaderView addSubview:blurred];
            
            self.barAnimationComplete = NO;
        }else if (yPos >= 0) {
            [self removeAllSubviewsOfClass:[UIImageView class] fromView:self.imageHeaderView];
        }
        if (yPos > self.headerSwitchOffset + 20 + 40) {
            if (!self.barAnimationComplete) {
                if (!self.staticNavHeader) {
                    [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:0 forBarMetrics:UIBarMetricsDefault];
                }
                self.barAnimationComplete = YES;
            }
            self.imageHeaderView.image = self.blurredBackgroundImage;
        }else {
            self.imageHeaderView.image = self.originalBackgroundImage;
        }
        if (yPos <= self.headerSwitchOffset + 20 && yPos >= 0) {
            self.barAnimationComplete = NO;
        }
        self.processingScroll = NO;
    }else {
        NSLog(@"仍在滑动");
    }
}

- (void)reloadImage:(UIImage *)image withMaxBrightness:(double)maxBrightness {
    self.blurredBackgroundImage = image;
    self.originalBackgroundImage = image;
    self.imageHeaderView.image = image;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *fixedRotation = [self fixrotation:image];
        CGFloat screenPixelWidth = [[UIScreen mainScreen] bounds].size.width * [UIScreen mainScreen].scale;
        CGFloat screenPixelHeight = [[UIScreen mainScreen] bounds].size.height * 0.75 * [UIScreen mainScreen].scale;
        CGFloat minDimension = MIN(screenPixelWidth, screenPixelHeight);
        UIImage *scaledImage = fixedRotation;
        CGFloat imagePixelWidth = fixedRotation.size.width * fixedRotation.scale;
        if (imagePixelWidth > minDimension) {
            float scale = minDimension / imagePixelWidth;
            scaledImage = [fixedRotation scaleImageWithScaleFactor:scale];
        }else {
            
        }
        UIImage *blurImage = [scaledImage applyBlurWithRadius:self.blurAmount tintColor:[UIColor colorWithWhite:0 alpha:0.2] saturationDeltaFactor:1.5 maskImage:nil];
        CGFloat width = [[UIScreen mainScreen] bounds].size.width * 0.75;
        CGFloat height = [[UIScreen mainScreen] bounds].size.height * 0.6;
        CGFloat newH = MIN(width, height);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.headerHeight = newH;
            self.blurredBackgroundImage = blurImage;
            self.originalBackgroundImage = scaledImage;
            self.imageHeaderView.image = scaledImage;
            [self setupTableViewController];
        });
    });
}

- (void)removeAllSubviewsOfClass:(Class)class fromView:(UIView *)view
{
    NSMutableArray *remove = [NSMutableArray new];
    NSMutableArray *subviews = [NSMutableArray arrayWithArray:self.imageHeaderView.subviews];
    for (UIView *subview in subviews) {
        if ([subview isKindOfClass:class]) {
            [remove addObject:subview];
        }
    }
    if (remove.count) {
        for (UIView *removeSubview in remove) {
            [removeSubview removeFromSuperview];
        }
    }
}

- (UIImage *)fixrotation:(UIImage *)image{
    if (image.imageOrientation == UIImageOrientationUp) return image;
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
