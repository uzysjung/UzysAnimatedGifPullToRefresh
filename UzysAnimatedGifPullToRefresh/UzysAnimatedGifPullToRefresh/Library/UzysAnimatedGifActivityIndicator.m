//
//  UzysAnimatedGifActivityIndicator.m
//  UzysAnimatedGifPullToRefresh
//
//  Created by Uzysjung on 2014. 4. 9..
//  Copyright (c) 2014년 Uzys. All rights reserved.
//

#import "UzysAnimatedGifActivityIndicator.h"
#import "UIScrollView+UzysAnimatedGifPullToRefresh.h"
#import "UzysAnimatedGifPullToRefreshConfiguration.h"
#define DEGREES_TO_RADIANS(x) (x)/180.0*M_PI
#define RADIANS_TO_DEGREES(x) (x)/M_PI*180.0


@interface UzysAnimatedGifActivityIndicator()
@property (nonatomic,strong) UIImageView *imageViewProgress;
@property (nonatomic,strong) UIImageView *imageViewLoading;

@property (nonatomic,strong) NSArray *pImgArrProgress;
@property (nonatomic,strong) NSArray *pImgArrLoading;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;  //Loading Indicator
@property (nonatomic, assign) double progress;
@property (nonatomic, assign) NSInteger progressThreshold;
@property (nonatomic, assign) NSInteger LoadingFrameRate;

@end
@implementation UzysAnimatedGifActivityIndicator

- (id)initWithProgressImages:(NSArray *)progressImg LoadingImages:(NSArray *)loadingImages ProgressScrollThreshold:(NSInteger)threshold LoadingImagesFrameRate:(NSInteger)lFrameRate
{
    if(threshold <=0)
    {
        threshold = initialPulltoRefreshThreshold;
    }
    UIImage *image1 = progressImg.firstObject;
    self = [super initWithFrame:CGRectMake(0, -image1.size.height, image1.size.width, image1.size.height)];
    if(self) {
        self.pImgArrProgress = progressImg;
        self.pImgArrLoading = loadingImages;
        self.progressThreshold = threshold;
        self.LoadingFrameRate = lFrameRate;
        [self _commonInit];
    }
    return self;
}

- (void)_commonInit
{
    self.activityIndicatorStyle = UIActivityIndicatorViewStyleGray;
    self.contentMode = UIViewContentModeRedraw;
    self.state = UZYSGIFPullToRefreshStateNone;
    self.backgroundColor = [UIColor clearColor];
    
    NSAssert([self.pImgArrProgress.lastObject isKindOfClass:[UIImage class]], @"pImgArrProgress Array has object that is not image");
    self.imageViewProgress = [[UIImageView alloc] initWithImage:[self.pImgArrProgress lastObject]];
    self.imageViewProgress.contentMode = UIViewContentModeScaleAspectFit;
    self.imageViewProgress.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ;
    self.imageViewProgress.frame = self.bounds;
    self.imageViewProgress.backgroundColor = [UIColor clearColor];
    [self addSubview:self.imageViewProgress];
    
    if(self.pImgArrLoading==nil)
    {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.activityIndicatorStyle];
        _activityIndicatorView.hidesWhenStopped = YES;
        _activityIndicatorView.frame = self.bounds;
        [self addSubview:_activityIndicatorView];        
    }
    else
    {
        NSAssert([self.pImgArrLoading.lastObject isKindOfClass:[UIImage class]], @"pImgArrLoading Array has object that is not image");
        self.imageViewLoading = [[UIImageView alloc] initWithImage:[self.pImgArrLoading firstObject]];
        self.imageViewLoading.contentMode = UIViewContentModeScaleAspectFit;
        self.imageViewLoading.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ;
        self.imageViewLoading.frame = self.bounds;
        self.imageViewLoading.animationImages = self.pImgArrLoading;
        self.imageViewLoading.animationDuration = (CGFloat)ceilf((1.0/(CGFloat)self.LoadingFrameRate) * (CGFloat)self.imageViewLoading.animationImages.count);
        self.imageViewLoading.alpha = 0;
        self.imageViewLoading.backgroundColor = [UIColor clearColor];
        [self addSubview:self.imageViewLoading];
    }
    self.alpha = 0;
}

- (void)layoutSubviews{
    [super layoutSubviews];
}


#pragma mark - ScrollViewInset
- (void)setupScrollViewContentInsetForLoadingIndicator:(actionHandler)handler
{
    CGFloat offset = MAX(self.scrollView.contentOffset.y * -1, 0);
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.top = MIN(offset, self.originalTopInset + self.bounds.size.height + 20.0);
    [self setScrollViewContentInset:currentInsets handler:handler];
}
- (void)resetScrollViewContentInset:(actionHandler)handler
{
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.top = self.originalTopInset;
    [self setScrollViewContentInset:currentInsets handler:handler];
}
- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset handler:(actionHandler)handler
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.scrollView.contentInset = contentInset;
                     }
                     completion:^(BOOL finished) {
                         if(handler)
                             handler();
                     }];
}
#pragma mark - property
- (void)setProgress:(double)progress
{
    static double prevProgress;
    if(progress > 1.0)
    {
        progress = 1.0;
    }
    if(self.showAlphaTransition)
    {
        self.alpha = 1.0 * progress;
    }
    else
    {
        CGFloat alphaValue = 1.0 * progress *5;
        if(alphaValue > 1.0)
            alphaValue = 1.0f;
        self.alpha = alphaValue;   
    }
    if (progress >= 0 && progress <=1.0) {
        //Animation
        NSInteger index = (NSInteger)roundf((self.pImgArrProgress.count ) * progress);
        if(index ==0)
        {
            self.imageViewProgress.image = nil;
        }
        else
        {
            self.imageViewProgress.image = [self.pImgArrProgress objectAtIndex:index-1];
        }
    }
    _progress = progress;
    prevProgress = progress;
}
- (void)dealloc
{
    self.imageViewLoading = nil;
    self.imageViewProgress = nil;
    self.pImgArrLoading = nil;
    self.imageViewProgress = nil;
    
}
#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"contentOffset"])
    {
        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    }
    else if([keyPath isEqualToString:@"contentSize"])
    {
        [self setNeedsLayout];
        [self setNeedsDisplay];
    }
    else if([keyPath isEqualToString:@"frame"])
    {
        [self setFrameSizeByProgressImage];

        [self setNeedsLayout];
        [self setNeedsDisplay];
    }
}
- (void)scrollViewDidScroll:(CGPoint)contentOffset
{
    static double prevProgress;
    CGFloat yOffset = contentOffset.y;
    self.progress = ((yOffset+ self.originalTopInset + StartPosition)/(-self.progressThreshold ));
    self.center = CGPointMake(self.center.x, (contentOffset.y+ self.originalTopInset)/2);
    switch (_state) {
        case UZYSGIFPullToRefreshStateStopped: //finish
            break;
        case UZYSGIFPullToRefreshStateNone: //detect action
        {
            if(self.scrollView.isDragging && yOffset <0 )
            {
                [self setFrameSizeByProgressImage];
                self.state = UZYSGIFPullToRefreshStateTriggering;
            }
        }
        case UZYSGIFPullToRefreshStateTriggering: //progress
        {
            if(self.progress >= 1.0)
                self.state = UZYSGIFPullToRefreshStateTriggered;
        }
            break;
        case UZYSGIFPullToRefreshStateTriggered: //fire actionhandler
            if(self.scrollView.tracking == NO && prevProgress > 0.98)
            {
                [self actionTriggeredState];
            }
            break;
        case UZYSGIFPullToRefreshStateLoading: //wait until stopIndicatorAnimation
            
            break;
        case UZYSGIFPullToRefreshStateCanFinish:
            if(self.progress < 0.01 + ((CGFloat)StartPosition/-self.progressThreshold) && self.progress > -0.01 +((CGFloat)StartPosition/-self.progressThreshold))
            {
                self.state = UZYSGIFPullToRefreshStateNone;
            }
            break;
        default:
            break;
    }
    //because of iOS6 KVO performance
    prevProgress = self.progress;
    
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (self.superview && newSuperview == nil) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        if (scrollView.showPullToRefresh) {
            if (self.isObserving) {
                [scrollView removeObserver:self forKeyPath:@"contentOffset"];
                [scrollView removeObserver:self forKeyPath:@"contentSize"];
                [scrollView removeObserver:self forKeyPath:@"frame"];
                self.isObserving = NO;
            }
        }
    }
}

-(void)actionStopState
{
    self.state = UZYSGIFPullToRefreshStateCanFinish;
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction animations:^{
        if(self.pImgArrLoading.count>0)
        {
            
        }
        else
        {
            self.activityIndicatorView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        }
    } completion:^(BOOL finished) {

        if(self.pImgArrLoading.count>0)
        {
            [self.imageViewLoading stopAnimating];
            self.imageViewLoading.alpha = 0.0;

        }
        else
        {
            self.activityIndicatorView.transform = CGAffineTransformIdentity;
            [self.activityIndicatorView stopAnimating];
            self.activityIndicatorView.alpha = 0.0;
        }

        [self resetScrollViewContentInset:^{
            self.imageViewProgress.alpha = 1.0;
            if(self.isVariableSize)
                [self setFrameSizeByProgressImage];
        }];
        
    }];
}
-(void)actionTriggeredState
{
    self.state = UZYSGIFPullToRefreshStateLoading;
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction animations:^{
        self.imageViewProgress.alpha = 0.0;
        if(self.isVariableSize)
        {
            [self setFrameSizeByLoadingImage];
        }
        if(self.pImgArrLoading.count>0)
        {
            self.imageViewLoading.alpha = 1.0;
        }
        else
        {
            self.activityIndicatorView.alpha = 1.0;
        }
    } completion:^(BOOL finished) {
    }];

    if(self.pImgArrLoading.count>0)
    {
        [self.imageViewLoading startAnimating];
    }
    else
    {
        [self.activityIndicatorView startAnimating];
    }
    [self setupScrollViewContentInsetForLoadingIndicator:nil];
    
    if(self.pullToRefreshHandler)
        self.pullToRefreshHandler();
    
}
- (void)setFrameSizeByProgressImage
{
    UIImage *image1 = self.pImgArrProgress.lastObject;
    if(image1)
        self.frame = CGRectMake((self.scrollView.bounds.size.width - image1.size.width)/2, -image1.size.height, image1.size.width, image1.size.height);
}
- (void)setFrameSizeByLoadingImage
{
    UIImage *image1 = self.pImgArrLoading.lastObject;
    if(image1)
    {
        self.frame = CGRectMake((self.scrollView.bounds.size.width - image1.size.width)/2, -image1.size.height, image1.size.width, image1.size.height);
    }
}

#pragma mark - public method
- (void)stopIndicatorAnimation
{
    [self actionStopState];
}
- (void)manuallyTriggered
{
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.top = self.originalTopInset + self.bounds.size.height + 20.0;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, -currentInsets.top);
    } completion:^(BOOL finished) {
        [self actionTriggeredState];
    }];
}
- (void)setSize:(CGSize) size
{
    CGRect rect = CGRectMake((self.scrollView.bounds.size.width - size.width)/2,
                             -size.height, size.width, size.height);
    self.frame=rect;
    self.activityIndicatorView.frame = self.bounds;
    self.imageViewProgress.frame = self.bounds;
    self.imageViewLoading.frame = self.bounds;
}
- (void)setIsVariableSize:(BOOL)isVariableSize
{
    _isVariableSize = isVariableSize;
    if(!_isVariableSize)
    {
        [self setFrameSizeByProgressImage];
    }
}
-(void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)style
{
    if(self.activityIndicatorView)
    {
        _activityIndicatorStyle = style;
        [self.activityIndicatorView removeFromSuperview];
        self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
        self.activityIndicatorView.hidesWhenStopped = YES;
        [self insertSubview:self.activityIndicatorView belowSubview:self.imageViewProgress];
        self.activityIndicatorView.frame = self.bounds;        
    }
}

@end
