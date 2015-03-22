UzysAnimatedGifPullToRefresh
============================
[![License MIT](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://raw.githubusercontent.com/uzysjung/UzysAnimatedGifPullToRefresh/master/LICENSE)
[![CocoaPods](https://img.shields.io/cocoapods/v/UzysAnimatedGifPullToRefresh.svg?style=flat)](https://github.com/uzysjung/UzysAnimatedGifPullToRefresh)
[![License MIT](https://img.shields.io/badge/contact-@Uzysjung-blue.svg?style=flat)](http://uzys.net)

Add PullToRefresh using animated GIF to any scrollView with just simple code

![Screenshot](https://raw.githubusercontent.com/uzysjung/UzysAnimatedGifPullToRefresh/master/UzysAnimatedGifPullToRefresh.gif)

**UzysAnimatedGifPullToRefresh features:**

* simple to use.
* Support CocoaPods.
* ARC Only (if your project doesn't use ARC , Project -> Build Phases Tab -> Compile Sources Section -> Double Click on the file name Then add -fno-objc-arc to the popup window.)

## Information
 - Please Visit [UzysAnimatedGifLoadMore](https://github.com/uzysjung/UzysAnimatedGifLoadMore)  

## Installation
1. UzysAnimatedGifPullToRefresh in your app is via CocoaPods.
2. Copy over the files libary folder to your project folder

## Usage
###Import header.

``` objective-c
#import "UIScrollView+UzysAnimatedGifPullToRefresh.h"
```

### Initialize
adding PullToRefreshActionHandler

``` objective-c
- (void)viewDidLoad
{
    __weak typeof(self) weakSelf =self;
    [self.tableView addPullToRefreshActionHandler:^{
        [weakSelf insertRowAtTop];
    }
    ProgressImagesGifName:@"spinner_dropbox@2x.gif" 
    LoadingImagesGifName:@"run@2x.gif" 
    ProgressScrollThreshold:60 
    LoadingImageFrameRate:30];
}
```
### programmatically trigger PullToRefresh
``` objective-c
[_tableView triggerPullToRefresh];
```

### stop PullToRefresh Activity Animation
``` objective-c
[_tableView stopRefreshAnimation];
```


### option
#### Progress : Animated GIF , Loading : Animated GIF
``` objective-c
- (void)addPullToRefreshActionHandler:(actionHandler)handler
                ProgressImagesGifName:(NSString *)progressGifName
                 LoadingImagesGifName:(NSString *)loadingGifName
              ProgressScrollThreshold:(NSInteger)threshold;
```
#### Progress : Animated GIF , Loading : UIActivitiyIndicator
``` objective-c
- (void)addPullToRefreshActionHandler:(actionHandler)handler
                ProgressImagesGifName:(NSString *)progressGifName
              ProgressScrollThreshold:(NSInteger)threshold;
```

#### Progress : Array images , Loading : UIActivitiyIndicator
``` objective-c
- (void)addPullToRefreshActionHandler:(actionHandler)handler
                       ProgressImages:(NSArray *)progressImages
              ProgressScrollThreshold:(NSInteger)threshold;
```

#### Progress : Array images , Loading : Array images
``` objective-c
- (void)addPullToRefreshActionHandler:(actionHandler)handler
                       ProgressImages:(NSArray *)progressImages
                        LoadingImages:(NSArray *)loadingImages
                    ProgressScrollThreshold:(NSInteger)threshold
               LoadingImagesFrameRate:(NSInteger)lframe;
```
#### Setup TopInsets for both landscape and portrait.
``` objective-c
[self.tableView addTopInsetInPortrait:64 TopInsetInLandscape:52];
// iOS 7 LandScape Navigationbar size 52 , Portrait Navigationbar size 64  

```
#### Non Translucent Navigation Controller.
``` objective-c
self.navigationController.navigationBar.translucent= NO; 
[self.tableView addTopInsetInPortrait:0 TopInsetInLandscape:0];

```

## Contact
 - [Uzys.net](http://uzys.net)

## License
 - See [LICENSE](https://github.com/uzysjung/UzysAnimatedGifPullToRefresh/blob/master/LICENSE).

## Acknowledgements
This application makes use of the following third party libraries:

### AnimatedGIFImageSerialization
Copyright (c) 2014 Mattt Thompson (http://mattt.me/)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

## Example Project Resources From
* https://dribbble.com/shots/647290-Hold-on-a-sec-animated-Dropbox-logo
* https://dribbble.com/shots/1421536-Cupido
* http://www.justicedavidgutierrez.com/Treats
* http://pixelbuddha.net/freebie/flat-preloaders
