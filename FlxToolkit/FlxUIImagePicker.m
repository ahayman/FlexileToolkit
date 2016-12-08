//
//  FlxUIImagePicker.m
//  Flexile
//
//  Created by Aaron Hayman on 12/12/13.
//
//

#import "FlxUIImagePicker.h"
#import "FlxToolkitDefines.h"
#import "FlxToolkitFunctions.h"
#import "FlxAlert.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface FlxUIImagePicker () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong) id lock;
@end
@implementation FlxUIImagePicker{
    UIPopoverController *_upc;
    UIImagePickerController *_iPicker;
    UIView *_presentingView;
    IDBlock _onSelection;
    UIViewController *_rootController;
}
#pragma mark - Init Methods
+ (void) pickfromCameraFromView:(UIView *)presentingView onSelection:(void (^)(UIImage *))selectionBlock{
    if (!selectionBlock) return;
    FlxUIImagePicker *picker = [[FlxUIImagePicker alloc] initWithPresentingView:presentingView onSelection:selectionBlock];
    picker.lock = picker;
    [picker presentCamera];
}
+ (void) pickfromImageLibraryFromView:(UIView *)presentingView onSelection:(void (^)(UIImage *))selectionBlock{
    if (!presentingView || !selectionBlock) return;
    FlxUIImagePicker *picker = [[FlxUIImagePicker alloc] initWithPresentingView:presentingView onSelection:selectionBlock];
    picker.lock = picker;
    [picker presentImagePicker];
}
- (id) init{
    return nil;
}
- (id) initWithPresentingView:(UIView *)presentingView onSelection:(IDBlock)onSelection{
    if (!presentingView) return nil;
    if (self = [super init]){
        _presentingView = presentingView;
        _rootController = [[[UIApplication sharedApplication] delegate] window].rootViewController;
        if (onSelection){
            _onSelection = [onSelection copy];
        }
    }
    return self;
}
#pragma mark - Private Methods
- (void) grabImagePermissionsOnCompletion:(VoidBlock)block{
    // Make sure we have permission, otherwise request it first
    ALAssetsLibrary* assetsLibrary = [[ALAssetsLibrary alloc] init];
    ALAuthorizationStatus authStatus;
    if (DeviceSystemMajorVersion() >= 6){
        authStatus = [ALAssetsLibrary authorizationStatus];
    } else {
        authStatus = ALAuthorizationStatusAuthorized;
    }
    
    if (authStatus == ALAuthorizationStatusAuthorized) {
        if (block) block();
    } else if (authStatus == ALAuthorizationStatusDenied || authStatus == ALAuthorizationStatusRestricted) {
        [FlxAlert displayAlertWithTitle:@"Permission Denied" message:@"Flexile cannot access photos or the camera. To grant permission to your photos, go to Settings App > Privacy > Photos."];
    } else if (authStatus == ALAuthorizationStatusNotDetermined) {
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            // Catch the final iteration, ignore the rest
            if (group == nil)
                if (block){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        block();
                    });
                }
            *stop = YES;
        } failureBlock:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [FlxAlert displayAlertWithTitle:@"Permission Denied" message:@"Flexile cannot access photos or the camera. To grant permission to your photos, go to Settings App > Privacy > Photos."];
            });
        }];
    }
}
- (void) presentImagePicker{
    [self grabImagePermissionsOnCompletion:^{
        _iPicker = [[UIImagePickerController alloc] init];
        _iPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _iPicker.delegate = self;
      
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            if (_upc.contentViewController == _iPicker) [_upc dismissPopoverAnimated:NO];
            else {
                if (!_upc) _upc = [[UIPopoverController alloc] initWithContentViewController:_iPicker];
                else [_upc setContentViewController:_iPicker animated:NO];
                [_upc presentPopoverFromRect:_presentingView.bounds inView:_presentingView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
        } else {
            [_rootController presentViewController:_iPicker animated:YES completion:nil];
        }
    }];
}
- (void) presentCamera{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) return;
    [self grabImagePermissionsOnCompletion:^{
        _iPicker = [[UIImagePickerController alloc] init];
        _iPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        _iPicker.showsCameraControls = YES;
        _iPicker.delegate = self;
        [_rootController presentViewController:_iPicker animated:YES completion:nil];
    }];
}
#pragma mark - Properties
#pragma mark - Standard Methods
#pragma mark - Protocol Method
#pragma mark UIImagePickerDelegate
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    if (_upc){
        [_upc dismissPopoverAnimated:YES];
    } else {
        [_rootController dismissViewControllerAnimated:YES completion:nil];
    }
    if (_onSelection){
        _onSelection(image);
    }
    
    self.lock = nil;
}
- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    if (_upc){
        [_upc dismissPopoverAnimated:YES];
    } else {
        [_rootController dismissViewControllerAnimated:YES completion:nil];
    }
    
    self.lock = nil;
}
#pragma mark - Overridden Methods
@end
