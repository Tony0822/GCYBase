//
//  BaseFileHelper.m
//  GCYBase
//
//  Created by gaochongyang on 2018/5/8.
//

#import "BaseFileHelper.h"

@implementation BaseFileHelper

+ (NSString *)getContentsRootPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return ([paths count] > 0 ?[paths objectAtIndex:0] : @"Not Found");
}

+ (NSString *)getContentsFilePath:(NSString *)relativepath {
    return [NSString stringWithFormat:@"%@/%@", [self getContentsRootPath], relativepath];
}

+ (NSURL *)getContentsFileURL:(NSString *)relativepath {
    return [NSURL fileURLWithPath:[self getContentsFilePath:relativepath]];
}

+ (UIImage *)getImageFromContentsPath:(NSString *)relativepath {
    return [UIImage imageWithContentsOfFile:[self getContentsFilePath:relativepath]];
}

+ (NSString *)getResourceFilePath:(NSString *)filename {
    return [[NSBundle mainBundle] pathForResource:filename ofType:nil];
}

+ (NSURL *)getResourceFileURL:(NSString *)filename {
    return [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:filename ofType:nil]];
}

+ (UIImage *)getImageFromResource:(NSString *)filename {
    return [UIImage imageNamed:filename];
}

+ (UIImage *)getImagePath:(NSString *)path withSize:(CGSize)size {
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

+ (UIImage *)getImagePath:(NSString *)path withScale:(CGFloat)scale {
    UIImage *image = [[UIImage alloc]initWithContentsOfFile:path];
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    CGSize size = CGSizeMake(image.size.width*scale, image.size.height*scale);
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

+ (BOOL)fileExist:(NSString *)filepath {
    return [[NSFileManager defaultManager] fileExistsAtPath:filepath];
}

+ (BOOL)dirExist:(NSString *)dirpath{
    BOOL isDir = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:dirpath isDirectory:&isDir];
    return isDir;
}

+ (BOOL)deleteFile:(NSString *)filepath {
    return [[NSFileManager defaultManager] removeItemAtPath:filepath error:nil];
}

+ (BOOL)createDirectoryAtPath:(id)dirPath {
    NSString *dir = [[BaseFileHelper getContentsRootPath]stringByAppendingPathComponent:dirPath];
    NSError *error;
    return [[NSFileManager defaultManager]createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:&error];
}

+ (BOOL)createFileWithPath:(NSString *)filePath {
    NSString *dir = [[BaseFileHelper getContentsRootPath]stringByAppendingPathComponent:filePath];
    return [[NSFileManager defaultManager]createFileAtPath:dir contents:nil attributes:nil];
}

+ (NSArray *)showAllFileInPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //在这里获取应用程序Documents文件夹里的文件及文件夹列表
    NSError *error = nil;
    NSArray *fileList = nil ;//[[NSArray alloc] init];
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    NSString *searchPath = [[BaseFileHelper getContentsRootPath]stringByAppendingPathComponent:path];
    fileList = [fileManager contentsOfDirectoryAtPath:searchPath error:&error];
    
    //    以下这段代码则可以列出给定一个文件夹里的所有子文件夹名
    
    NSMutableArray *fileArray = [[NSMutableArray alloc] init];
    BOOL isDir = NO;
    //    NSLog(@"%@  hasFilecount-->%i",path,[fileList count]);
    //在上面那段程序中获得的fileList中列出文件夹名
    for (NSString *file in fileList) {
        NSString *fileName = [searchPath stringByAppendingPathComponent:file];
        [fileManager fileExistsAtPath:fileName isDirectory:(&isDir)];
        if (isDir) {
            //            NSLog(@"dir-->%@",file);
        }else{
            [fileArray addObject:file];
            //            NSLog(@"file-->%@",file);
        }
        isDir = NO;
    }
    return fileArray;
}
@end
