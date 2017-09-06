//
//  ViewController.m
//  APPtest
//
//  Created by yaoyao on 2017/8/16.
//  Copyright © 2017年 sina_iOS_Macbook_YY. All rights reserved.
//

#import "ViewController.h"
#import "TXQcloudFrSDK.h"
#import "Auth.h"
#import "TencentYoutuYun/Conf.h"
#import "QBImagePickerController.h"
@interface ViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,QBImagePickerControllerDelegate> {
    dispatch_queue_t queue;
}
@property (nonatomic, strong) NSMutableArray * array;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic, strong) TXQcloudFrSDK * frSDK;
@property (nonatomic, strong) NSOperationQueue * queue;

@property (nonatomic, strong) NSMutableArray *uploadImageArray;
@property (nonatomic, strong) NSMutableArray *codeArray;
@property (nonatomic, assign) NSInteger totalUploadCount;
@end

@implementation ViewController

- (TXQcloudFrSDK *)frSDK {
    if (_frSDK == nil) {
        //    优图开放平台初始化
        NSString *auth = [Auth appSign:1000000 userId:nil];
        _frSDK = [[TXQcloudFrSDK alloc] initWithName:[Conf instance].appId authorization:auth endPoint:[Conf instance].API_END_POINT];
    }
    return _frSDK;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.array = [NSMutableArray new];
    for (int i = 0; i< 9; i++) {
        [self.array addObject:[UIImage imageNamed:@"1.jpg"]];
    }
    
    [self.activity stopAnimating];
    self.queue = [[NSOperationQueue alloc] init];
    self.queue.maxConcurrentOperationCount = 3;
    
    _uploadImageArray = [NSMutableArray new];
    _codeArray = [NSMutableArray new];
}

- (UIImage *)getImage {
    if (self.array.count > 0) {
        id objc = [self.array lastObject];
        [self.array removeLastObject];
        
        if ([objc isKindOfClass:[UIImage class]]) {
            return objc;
        }
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self start];
//    [self start2];
}
- (void)start2 {
    //将正则表达式作为字符串赋值给变量regex
    NSString *regex2 = @"^\\d{6}$";
    
    //根据正则表达式将NSPredicate的格式设置好
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    
    for (int i = 0 ; i < self.array.count; i++) {
        
        UIImage * image = self.array[i];
//        if (image == nil) {
//            return;
//        }
        NSLog(@"%@",@"开始分析");
        NSBlockOperation * blockop = [NSBlockOperation blockOperationWithBlock:^{
            [self.frSDK namecardOcr:image sessionId:nil successBlock:^(id responseObject) {
                NSArray * array = responseObject[@"items"];
                for (NSDictionary * dict in array) {
                    
                    NSString * text = [self filterWithString:dict[@"itemstring"]] ;
                    BOOL isMatch2 = [pred2 evaluateWithObject:text];
                    isMatch2 ? NSLog(@"%@",text) : 0;
                    NSLog(@"%@",@"分析成功");
                    
                }
            } failureBlock:^(NSError *error) {
                NSLog(@"%@",error);
                NSLog(@"%@",@"分析失败");
            }];
            NSLog(@"我在分析");
        }];
        
        NSBlockOperation * lastop = self.queue.operations.lastObject;
        if (lastop != nil) {
            [blockop addDependency:lastop];
        }
        
        [self.queue addOperation:blockop];
    }
}

- (NSOperation *)getOperation {
    UIImage * image = [self getImage];
    if (image == nil) {
        return nil;
    }
    
    //将正则表达式作为字符串赋值给变量regex
    NSString *regex2 = @"^\\d{6}$";
    
    //根据正则表达式将NSPredicate的格式设置好
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    
    
    NSBlockOperation * blockop = [NSBlockOperation blockOperationWithBlock:^{
        [self.frSDK namecardOcr:image sessionId:nil successBlock:^(id responseObject) {
            NSArray * array = responseObject[@"items"];
            for (NSDictionary * dict in array) {
                
                NSString * text = [self filterWithString:dict[@"itemstring"]] ;
                BOOL isMatch2 = [pred2 evaluateWithObject:text];
                isMatch2 ? NSLog(@"%@",text) : 0;
                NSLog(@"%@",@"分析成功");
                
            }
        } failureBlock:^(NSError *error) {
            NSLog(@"%@",error);
            NSLog(@"%@",@"分析失败");
        }];
    }];
    
    return blockop;
}

- (void)start {
    
    //将正则表达式作为字符串赋值给变量regex
    NSString *regex2 = @"^\\d{6}$";
    
    //根据正则表达式将NSPredicate的格式设置好
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    
    UIImage * image = [self getImage];
    NSLog(@"开始分析图片");
    [self.frSDK namecardOcr:image sessionId:nil successBlock:^(id responseObject) {
        NSArray * array = responseObject[@"items"];
        for (NSDictionary * dict in array) {
            
            NSString * text = [self filterWithString:dict[@"itemstring"]] ;
            BOOL isMatch2 = [pred2 evaluateWithObject:text];
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"%@",error);
    }];

}
- (NSString *)filterWithString:(NSString *)str
{
    NSString *regex = @"[^0-9]";
    return   [str stringByReplacingOccurrencesOfString:regex withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, str.length)];
    
}

#pragma mark -
- (IBAction)click {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"" message:@"提示" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *Action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *Action2 = [UIAlertAction actionWithTitle:@"从相册里选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsMultipleSelection = YES;
            imagePickerController.showsNumberOfSelectedAssets = YES;
            imagePickerController.maximumNumberOfSelection = 9;
            
            [self presentViewController:imagePickerController animated:YES completion:NULL];
    }
        
    }];
    UIAlertAction *Action3 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = NO;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
        }

    }];
    [alertController addAction:Action1];
    [alertController addAction:Action2];
    [alertController addAction:Action3];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark - QBImagePickerControllerDelegate
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
{
    [_uploadImageArray removeAllObjects];
//    _isCancelUpload = NO;
    for (ALAsset *asset in assets) {
        //        UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage
                                             scale:asset.defaultRepresentation.scale * 0.5
                                       orientation:(UIImageOrientation)asset.defaultRepresentation.orientation];
        //        self.uploadImage = image;
        [_uploadImageArray addObject:image];
    }
    [imagePickerController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    [imagePickerController dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)uploadaa {
    
    //将正则表达式作为字符串赋值给变量regex
    NSString *regex2 = @"^\\d{6}$";
    
    //根据正则表达式将NSPredicate的格式设置好
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    
    __weak typeof(self) weakself = self;
    
    
    __block NSInteger count = 0;
    
    if (_uploadImageArray.count > 0 ) {
        [self.activity startAnimating];
        
        for (UIImage * image in self.uploadImageArray) {
            NSBlockOperation * oper = [NSBlockOperation blockOperationWithBlock:^{
                
                NSLog(@"%@",@"开始分析");
                NSLog(@"%@",[NSThread currentThread]);
                [weakself.frSDK namecardOcr:image sessionId:nil successBlock:^(id responseObject) {
                    NSArray * array = responseObject[@"items"];
                    NSLog(@"%@",@"分析成功");
                    for (NSDictionary * dict in array) {
                        NSString * text = [self filterWithString:dict[@"itemstring"]] ;
                        BOOL isMatch2 = [pred2 evaluateWithObject:text];
                        if (isMatch2) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [weakself.codeArray addObject:text];
                            });
                        }
                    }
                    
                    count ++;
                    if (count == self.uploadImageArray.count) {
                        NSLog(@"%@",@"Done");
                        NSLog(@"%@",weakself.codeArray);
                        NSLog(@"%@",[NSThread currentThread]);
                        [weakself.uploadImageArray removeAllObjects];
                    }
                    
                } failureBlock:^(NSError *error) {
                    NSLog(@"%@",error);
                    NSLog(@"%@",@"分析失败");
                    
                    count ++;
                    if (count == self.uploadImageArray.count) {
                        NSLog(@"%@",@"Done");
                        NSLog(@"%@",weakself.codeArray);
                        NSLog(@"%@",[NSThread currentThread]);
                        [weakself.uploadImageArray removeAllObjects];
                    }
                }];
            }];
            
            [self.queue addOperation:oper];
        }
    }
}

- (IBAction)upload {
    
    //将正则表达式作为字符串赋值给变量regex
    NSString *regex2 = @"^\\d{6}$";
    
    //根据正则表达式将NSPredicate的格式设置好
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    
        __block NSInteger count = 0;
    
    if (_uploadImageArray.count > 0 ) {
        
        [self.activity startAnimating];
        
        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        __block typeof(self) weakself = self;
        
        dispatch_async(queue, ^{
            
            dispatch_semaphore_t sema = dispatch_semaphore_create(4);
            [self.uploadImageArray enumerateObjectsUsingBlock:^(UIImage * image, NSUInteger idx, BOOL * _Nonnull stop) {
                
                dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
                NSLog(@"%@",@"开始分析");
                [weakself.frSDK namecardOcr:image sessionId:nil successBlock:^(id responseObject) {
                    NSArray * array = responseObject[@"items"];
                    
                    NSLog(@"%@",@"分析成功");
                    for (NSDictionary * dict in array) {
                        NSString * text = [self filterWithString:dict[@"itemstring"]] ;
                        BOOL isMatch2 = [pred2 evaluateWithObject:text];
                        if (isMatch2) {
                                [weakself.codeArray addObject:text];
                        }
                    }
                    dispatch_semaphore_signal(sema);
                    
                    count ++;
                    if (count == self.uploadImageArray.count) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"%@",@"Done");
                            NSLog(@"%@",weakself.codeArray);
                            NSLog(@"%@",[NSThread currentThread]);
                            [weakself.uploadImageArray removeAllObjects];
                        });
                    }
                    
                } failureBlock:^(NSError *error) {
                    NSLog(@"%@",error);
                    NSLog(@"%@",@"分析失败");
                    dispatch_semaphore_signal(sema);
                    count ++;
                    if (count == self.uploadImageArray.count) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"%@",@"Done");
                            NSLog(@"%@",weakself.codeArray);
                            NSLog(@"%@",[NSThread currentThread]);
                            [weakself.uploadImageArray removeAllObjects];
                        });
                    }
                }];
            }];
        });
    }
}

@end
