//
//  ViewController.m
//  NSInvocation
//
//  Created by 常布雨 on 16/07/14.
//  Copyright © 2016年 CBY. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "Person.h"

@interface ViewController ()
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self sayhi];
}

#pragma mark - 动态方法解析
//+ (BOOL)resolveInstanceMethod:(SEL)sel{
//    NSString *selStr = NSStringFromSelector(sel);
//    if ([selStr isEqualToString:@"sayhi"]) {
//        class_addMethod(self, sel, (IMP)autoSayhi, "v@:");
//        return YES;
//    }
//    return [super resolveInstanceMethod:sel];
//}

//void autoSayhi(id self, SEL _cmd){
//    NSLog(@"吃饭了吗?");
//}

#pragma mark - 后备接受者(可以使私有方法)
//- (id)forwardingTargetForSelector:(SEL)aSelector{
//    NSString *selStr = NSStringFromSelector(aSelector);
//    if ([selStr isEqualToString:@"sayhi"]) {
//        return [[Person alloc] init];
//    }
//    return [super forwardingTargetForSelector:aSelector];
//}

#pragma mark - 完整的消息转发(改变调用目标,效果同后备接受者)
//- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
//    NSMethodSignature *signature = [Person instanceMethodSignatureForSelector:@selector(sayhi)];
//    return signature;
//}
//
//- (void)forwardInvocation:(NSInvocation *)invocation{
//     // 更换调用目标后,要更改invocation的target(即方法拥有者的实例)
//    [invocation invokeWithTarget:[[Person alloc] init]];
//}

#pragma mark - 完整的消息转发(更换参数/更换SEL)
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    //生成方法签名
    NSMethodSignature *signature = [ViewController instanceMethodSignatureForSelector:@selector(sayno:)];
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)invocation{
    NSLog(@"%@---%@", invocation.target, NSStringFromSelector(invocation.selector));
    //更换SEL后要更改invocaiton的selector
    invocation.selector = @selector(sayno:);
    NSString *name = @"张三";
    [invocation setArgument:&name atIndex:2];
    [invocation invoke];
}


- (void)sayno:(NSString *)name{
    NSLog(@"%@:还没吃呢!", name);
}


@end
