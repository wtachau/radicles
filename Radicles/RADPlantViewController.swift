//
//  RADPlantViewController.swift
//  Radicles
//
//  Created by William Tachau on 9/18/14.
//  Copyright (c) 2014 Radicles. All rights reserved.
//

import Foundation

let NUM_IMAGES:CGFloat = 3
let IMAGE_SIZE = UIScreen.mainScreen().bounds.size.width / NUM_IMAGES
let SCROLL_HEIGHT:CGFloat = 250
let NAME_OFFSET:CGFloat = 100
let CAMERA_SIZE:CGFloat = 50
let CAMERA_YOFFSET:CGFloat = 150
let CAMERA_CENTERED = (UIScreen.mainScreen().bounds.size.width - CAMERA_SIZE)/2

class RADPlantViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var plant : RADPlant?
    var nameLabel = UILabel()
    var cameraButton = UIButton()
    var scrollView = UIScrollView()
    var imagePicker = UIImagePickerController()
    var lastImage : UIImage?
    
    override func viewDidLoad() {
        self.setUpViews()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.updateImages()
    }
    
    func setPlant(plant: RADPlant) {
        self.plant = plant
        updateImages()
    }
    
    func setUpViews() {
        view.backgroundColor = darkGreen
        
        cameraButton.frame = CGRectMake(CAMERA_CENTERED, CAMERA_YOFFSET, CAMERA_SIZE, CAMERA_SIZE * 0.75)
        cameraButton.setImage(UIImage(named: "camera.png"), forState: UIControlState.Normal)
        cameraButton.addTarget(self, action:"openPhoto:", forControlEvents: UIControlEvents.TouchUpInside)
        
        scrollView.frame = CGRectMake(0, view.frame.size.height - SCROLL_HEIGHT, view.frame.size.width, SCROLL_HEIGHT);
        scrollView.contentSize = CGSizeMake(view.frame.size.width, SCROLL_HEIGHT)
        
        view.addSubview(nameLabel)
        view.addSubview(cameraButton)
        view.addSubview(scrollView)
    }
    
    func updateImages() {
        let imagesArray = [] as NSMutableArray
        
        let imagesQuery = PFQuery(className: "RADPlantImage")
        if let Plant = plant {
            imagesQuery.whereKey("plant", equalTo: Plant.PFObjectRef)
            imagesQuery.findObjectsInBackgroundWithBlock {
                (results: [AnyObject]!, error: NSError!) -> Void in
                if error == nil {
                    
                    let containerHeight = (((CGFloat(results.count) - 1) / NUM_IMAGES) + 1) * IMAGE_SIZE
                    if (CGFloat(containerHeight) > SCROLL_HEIGHT) {
                        self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: containerHeight);
                    }
                    
                    for (var i = 0; i < results.count; i++) {
                        let xOffset = CGFloat(i) % NUM_IMAGES * IMAGE_SIZE
                        let yOffset = CGFloat(i / Int(NUM_IMAGES)) * IMAGE_SIZE
                        let imageButton = UIButton(frame: CGRectMake(xOffset, yOffset, IMAGE_SIZE, IMAGE_SIZE))
                        
                        let image = results[i] as PFObject
                        image["image"].getDataInBackgroundWithBlock {
                            (data:NSData!, error:NSError!) -> Void in
                            UIGraphicsBeginImageContext(CGSizeMake(IMAGE_SIZE, IMAGE_SIZE))
                            let fullimage = UIImage(data: data!)
                            fullimage .drawInRect(CGRectMake(0, 0, IMAGE_SIZE, IMAGE_SIZE))
                            let smallimage = UIGraphicsGetImageFromCurrentImageContext()
                            UIGraphicsEndImageContext();
                            self.lastImage = fullimage
                            imageButton.setBackgroundImage(fullimage, forState: UIControlState.Normal)
                            self.scrollView.addSubview(imageButton)
                        }
                    }
                }
            }
        }
    }
    
    func openPhoto(sender:UIButton!) {
        if (!UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            // todo can't open image
        } else {
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.showsCameraControls = false
            
            let scale:CGFloat = 1.33
            let imageHeight = self.view.frame.size.width * scale
            let transform = CGAffineTransformMakeTranslation(0, (UIScreen.mainScreen().bounds.height - imageHeight)/2)
            NSLog("\(self.view.frame) and \(imageHeight)")
            imagePicker.cameraViewTransform = transform
            
            // add overlay of previous image, if there
            if let image = lastImage {
                let overlayView = UIView(frame: CGRectMake(0, 16, view.frame.size.width, view.frame.size.height))
                let overlayImage = UIImageView(image: image)
                overlayImage.contentMode = UIViewContentMode.ScaleAspectFit
                overlayImage.frame = overlayView.frame
                overlayImage.alpha = 0.7
                overlayView.addSubview(overlayImage)
                imagePicker.cameraOverlayView = overlayView
                
                NSLog("\(imagePicker.cameraOverlayView!.frame) and \(imagePicker.view.frame)")
                
            }
            
            let buttonWidth:CGFloat = 30
            let buttonYoffset:CGFloat = 20
            let buttonPadding:CGFloat = 50
            let captureButton = UIButton(frame: CGRectMake(
                                (view.frame.size.width - buttonPadding - buttonWidth)/2,
                                (view.frame.size.height - buttonWidth - buttonYoffset),
                                buttonWidth, buttonWidth))
            captureButton.backgroundColor = UIColor.greenColor()
            captureButton.addTarget(self, action: "takePhoto", forControlEvents: UIControlEvents.TouchUpInside)
            
            let cancelButton = UIButton(frame: CGRectMake(
                                (view.frame.size.width + buttonPadding)/2,
                                (view.frame.size.height - buttonWidth - buttonYoffset),
                                buttonWidth, buttonWidth));
            cancelButton.backgroundColor = UIColor.redColor()
            cancelButton.addTarget(self, action: "cancelPhoto", forControlEvents: UIControlEvents.TouchUpInside)
            imagePicker.cameraOverlayView?.addSubview(captureButton)
            imagePicker.cameraOverlayView!.addSubview(cancelButton)
            
            presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func takePhoto() {
        imagePicker.takePicture()
    }
    
    func cancelPhoto() {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        let chosenImage = info[UIImagePickerControllerOriginalImage] as UIImage
        if let Plant = plant {
            var plantImage = PFObject(className: "RADPlantImage")
            plantImage["user"] = PFUser.currentUser()
            plantImage["plant"] = Plant.PFObjectRef
            
            let imageData = UIImageJPEGRepresentation(chosenImage, CGFloat(0.05))
            let imageFile = PFFile(name: "plant", data: imageData)
            plantImage["image"] = imageFile
            plantImage.saveInBackgroundWithBlock {
                (bool: Bool!, error: NSError!) -> Void in
                self.updateImages()
            }
        }
    }
    
    
    override init() {
        super.init()
    }
    
    private override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}