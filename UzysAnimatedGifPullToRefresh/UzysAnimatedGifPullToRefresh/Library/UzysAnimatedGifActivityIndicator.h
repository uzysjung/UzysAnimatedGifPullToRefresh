//
//  UzysAnimatedGifActivityIndicator.h
//  UzysAnimatedGifPullToRefresh
//
//  Created by Uzysjung on 2014. 4. 9..
//  Copyright (c) 2014년 Uzys. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^actionHandler)(void);
typedef NS_ENUM(NSUInteger, UZYSPullToRefreshState) {
    UZYSGIFPullToRefreshStateNone =0,
    UZYSGIFPullToRefreshStateStopped,
    UZYSGIFPullToRefreshStateTriggering,
    UZYSGIFPullToRefreshStateTriggered,
    UZYSGIFPullToRefreshStateLoading,
    UZYSGIFPullToRefreshStateCanFinish
};

@interface UzysAnimatedGifActivityIndicator : UIView
@property (nonatomic,assign) BOOL isObserving;
@property (nonatomic,assign) CGFloat originalTopInset;
@property (nonatomic,assign) CGFloat landscapeTopInset;
@property (nonatomic,assign) CGFloat portraitTopInset;

@property (nonatomic,assign) UZYSPullToRefreshState state;
@property (nonatomic,weak) UIScrollView *scrollView;
@property (nonatomic,copy) actionHandler pullToRefreshHandler;
@property (nonatomic,assign) BOOL showAlphaTransition;
@property (nonatomic,assign) BOOL isVariableSize;
@property (nonatomic,assign) UIActivityIndicatorViewStyle activityIndicatorStyle;

- (id)initWithProgressImages:(NSArray *)progressImg LoadingImages:(NSArray *)loadingImages ProgressScrollThreshold:(NSInteger)threshold LoadingImagesFrameRate:(NSInteger)lFrameRate;
- (void)stopIndicatorAnimation;
- (void)manuallyTriggered;
- (void)setSize:(CGSize) size;
- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle) style;

- (void)setFrameSizeByProgressImage;
- (void)setFrameSizeByLoadingImage;
- (void)orientationChange:(UIDeviceOrientation)orientation;
@end
