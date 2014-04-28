// AnimatedGIFImageSerialization.m
//
// Copyright (c) 2014 Mattt Thompson (http://mattt.me/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AnimatedGIFImageSerialization.h"

#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

NSString * const AnimatedGIFImageErrorDomain = @"com.compuserve.gif.image.error";

__attribute__((overloadable)) UIImage * UIImageWithAnimatedGIFData(NSData *data) {
    return UIImageWithAnimatedGIFData(data, [[UIScreen mainScreen] scale], 0.0f, nil);
}

__attribute__((overloadable)) UIImage * UIImageWithAnimatedGIFData(NSData *data, CGFloat scale, NSTimeInterval duration, NSError * __autoreleasing *error) {
    NSDictionary *userInfo = nil;
    {
        if (!data) {
            return nil;
        }

        NSMutableDictionary *mutableOptions = [NSMutableDictionary dictionary];
        [mutableOptions setObject:@(YES) forKey:(NSString *)kCGImageSourceShouldCache];
        [mutableOptions setObject:(NSString *)kUTTypeGIF forKey:(NSString *)kCGImageSourceTypeIdentifierHint];

        CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)data, (__bridge CFDictionaryRef)mutableOptions);

        size_t numberOfFrames = CGImageSourceGetCount(imageSource);
        NSMutableArray *mutableImages = [NSMutableArray arrayWithCapacity:numberOfFrames];

        NSTimeInterval calculatedDuration = 0.0f;
        for (size_t idx = 0; idx < numberOfFrames; idx++) {
            CGImageRef imageRef = CGImageSourceCreateImageAtIndex(imageSource, idx, (__bridge CFDictionaryRef)mutableOptions);

            NSDictionary *properties = (__bridge_transfer NSDictionary *)CGImageSourceCopyPropertiesAtIndex(imageSource, idx, NULL);
            calculatedDuration += [[[properties objectForKey:(NSString *)kCGImagePropertyGIFDictionary] objectForKey:(NSString *)kCGImagePropertyGIFDelayTime] doubleValue];

            [mutableImages addObject:[UIImage imageWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp]];

            CGImageRelease(imageRef);
        }

        CFRelease(imageSource);

        return [UIImage animatedImageWithImages:mutableImages duration:(duration <= 0.0f ? calculatedDuration : duration)];
    }
    _error: {
        if (error) {
            *error = [[NSError alloc] initWithDomain:AnimatedGIFImageErrorDomain code:-1 userInfo:userInfo];
        }

        return nil;
    }
}

static BOOL AnimatedGifDataIsValid(NSData *data) {
    if (data.length > 4) {
        const unsigned char * bytes = [data bytes];

        return bytes[0] == 0x47 && bytes[1] == 0x49 && bytes[2] == 0x46;
    }

    return NO;
}

//__attribute__((overloadable)) NSData * UIImageAnimatedGifRepresentation(UIImage *image) {
//    return UIImageAnimatedGifRepresentation(image, 0.0f, nil);
//}

//__attribute__((overloadable)) NSData * UIImageAnimatedGifRepresentation(UIImage *image, NSTimeInterval duration, NSError * __autoreleasing *error) {
//
//}

@implementation AnimatedGIFImageSerialization

+ (UIImage *)imageWithData:(NSData *)data
                     error:(NSError * __autoreleasing *)error
{
    return [self imageWithData:data scale:1.0f duration:0.0f error:error];
}

+ (UIImage *)imageWithData:(NSData *)data
                     scale:(CGFloat)scale
                  duration:(NSTimeInterval)duration
                     error:(NSError * __autoreleasing *)error
{
    return UIImageWithAnimatedGIFData(data, scale, duration, error);
}

#pragma mark -

//+ (NSData *)dataWithImage:(UIImage *)image
//                    error:(NSError * __autoreleasing *)error
//{
//    return [self dataWithImage:image duration:0.0f error:error];
//}

//+ (NSData *)dataWithImage:(UIImage *)image
//                 duration:(NSTimeInterval)duration
//                    error:(NSError * __autoreleasing *)error
//{
//    return UIImageAnimatedGifRepresentation(image, duration, error);
//}

@end

#pragma mark -

#ifndef ANIMATED_GIF_NO_UIIMAGE_INITIALIZER_SWIZZLING
#import <objc/runtime.h>

static inline void animated_gif_swizzleSelector(Class class, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    if (class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@interface UIImage (_AnimatedGIFImageSerialization)
@end

@implementation UIImage (_AnimatedGIFImageSerialization)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            animated_gif_swizzleSelector(self, @selector(initWithData:scale:), @selector(animated_gif_initWithData:scale:));
            animated_gif_swizzleSelector(self, @selector(initWithData:), @selector(animated_gif_initWithData:));
            animated_gif_swizzleSelector(self, @selector(initWithContentsOfFile:), @selector(animated_gif_initWithContentsOfFile:));
            animated_gif_swizzleSelector(object_getClass((id)self), @selector(imageNamed:), @selector(animated_gif_imageNamed:));
        }
    });
}

+ (UIImage *)animated_gif_imageNamed:(NSString *)name __attribute__((objc_method_family(new))){
    NSString *path = [[NSBundle mainBundle] pathForResource:[name stringByDeletingPathExtension] ofType:[name pathExtension]];
    if (path) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        if (AnimatedGifDataIsValid(data)) {
            if ([[name stringByDeletingPathExtension] hasSuffix:@"@2x"]) {
                return [AnimatedGIFImageSerialization imageWithData:data scale:2.0f duration:0.0f error:nil];
            } else {
                return [AnimatedGIFImageSerialization imageWithData:data error:nil];
            }
        }
    }

    return [self animated_gif_imageNamed:name];
}

- (id)animated_gif_initWithData:(NSData *)data  __attribute__((objc_method_family(init))) {
    if (AnimatedGifDataIsValid(data)) {
        return UIImageWithAnimatedGIFData(data);
    }

    return [self animated_gif_initWithData:data];
}

- (id)animated_gif_initWithData:(NSData *)data
                  scale:(CGFloat)scale __attribute__((objc_method_family(init)))
{
    if (AnimatedGifDataIsValid(data)) {
        return UIImageWithAnimatedGIFData(data, scale, 0.0f, nil);
    }

    return [self animated_gif_initWithData:data scale:scale];
}

- (id)animated_gif_initWithContentsOfFile:(NSString *)path __attribute__((objc_method_family(init))) {
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (AnimatedGifDataIsValid(data)) {
        return UIImageWithAnimatedGIFData(data, 1.0, 0.0f, nil);
    }

    return [self animated_gif_initWithContentsOfFile:path];
}

@end
#endif
