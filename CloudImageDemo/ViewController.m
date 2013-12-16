//
//  ViewController.m
//  CloudImageDemo
//
//  Created by Jay Versluis on 16/12/2013.
//  Copyright (c) 2013 Pinkstone Pictures LLC. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIBarButtonItem *leftBarButton;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIPopoverController *popovercontroller;

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
    if (UIUserInterfaceIdiomPad) {
        // present this as a Popover
        self.popovercontroller = [[UIPopoverController alloc]initWithContentViewController:myPicker];
        [self.popovercontroller presentPopoverFromBarButtonItem:self.leftBarButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    } else {
        [self presentViewController:myPicker animated:YES completion:nil];
    }
}


// an image is selected
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (UIUserInterfaceIdiomPad) {
        [self.popovercontroller dismissPopoverAnimated:YES];
    
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    UIImage *chosenImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    // self.imageView.image = chosenImage;
    
    // instead of displaying the image, let's save it to our Documents directory
    [self saveImageToCloudDocuments:chosenImage];
}

// user hits cancel
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if (UIUserInterfaceIdiomPad) {
        [self.popovercontroller dismissPopoverAnimated:YES];
    
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (IBAction)showImage:(id)sender {
    
    // load image from documents and display it
    self.imageView.image = [self loadFromCloudDocuments];
}


#pragma mark - Local File methods
// same as below, referencing the local Documents directory

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


#pragma mark - Cloud File methods
// these methods are identical to the ones above, but reference the Ubiquity Containter instead

- (void)saveImageToCloudDocuments:(UIImage *)image {
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    NSString *filePath = [self grabCloudPath:@"testPicture"];
    [imageData writeToFile:filePath atomically:YES];
}

- (UIImage *)loadFromCloudDocuments {
    
    NSString *filePath = [self grabCloudPath:@"testPicture"];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    UIImage *image = [[UIImage alloc]init];
    
    if (!fileExists) {
        NSLog(@"File does not exist.");
    } else {
        // load image from Ubiquity Documents directory
        NSData *imageData = [NSData dataWithContentsOfFile:filePath];
        image = [UIImage imageWithData:imageData];
    }
    return image;
}

- (NSString *)grabCloudPath:(NSString *)fileName {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *teamID = @"F34HMY85N9";
    NSString *bundleID = [[NSBundle mainBundle]bundleIdentifier];
    NSString *cloudRoot = [NSString stringWithFormat:@"%@.%@", teamID, bundleID];
    
    NSURL *cloudRootURL = [fileManager URLForUbiquityContainerIdentifier:cloudRoot];
    
    NSString *pathToCloudFile = [[cloudRootURL path]stringByAppendingPathComponent:@"Documents"];
    pathToCloudFile = [pathToCloudFile stringByAppendingPathComponent:fileName];
    
    return pathToCloudFile;
}


@end
