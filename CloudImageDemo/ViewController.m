//
//  ViewController.m
//  CloudImageDemo
//
//  Created by Jay Versluis on 16/12/2013.
//  Copyright (c) 2013 Pinkstone Pictures LLC. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)uploadImage:(id)sender;
- (IBAction)showImage:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


#pragma mark - Image Picker

- (IBAction)uploadImage:(id)sender {
    
    // let's grab a picture from the media library
    UIImagePickerController *myPicker = [[UIImagePickerController alloc]init];
    myPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    myPicker.allowsEditing = NO;
    myPicker.delegate = self;
    
    // now we present the picker
    [self presentViewController:myPicker animated:YES completion:nil];
}


// an image is selected
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *chosenImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    // self.imageView.image = chosenImage;
    
    // instead of displaying the image, let's save it to our Documents directory
    [self saveImageToDocuments:chosenImage];
}

// user hits cancel
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showImage:(id)sender {
    
    // load image from documents and display it
    self.imageView.image = [self loadFromDocuments];
}


#pragma mark - File Save methods

- (void)saveImageToDocuments:(UIImage *)image {
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    NSString *filePath = [self grabFilePath:@"testPicture"];
    [imageData writeToFile:filePath atomically:YES];
}

- (UIImage *)loadFromDocuments {
    
    NSString *filePath = [self grabFilePath:@"testPicture"];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    UIImage *image = [[UIImage alloc]init];
    
    if (!fileExists) {
        NSLog(@"File does not exist.");
    } else {
        // load image from Documents directory
        NSData *imageData = [NSData dataWithContentsOfFile:filePath];
        image = [UIImage imageWithData:imageData];
    }
    return image;
}


- (NSString *)grabFilePath:(NSString *)fileName {
    
    NSString *filePath = [[NSString alloc]initWithFormat:@"Documents/%@", fileName];
    NSString *documentsFilePath = [NSHomeDirectory()stringByAppendingPathComponent:filePath];
    
    return documentsFilePath;
}

@end
