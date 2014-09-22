//
//  RADPlantViewController.swift
//  Radicles
//
//  Created by William Tachau on 9/18/14.
//  Copyright (c) 2014 Radicles. All rights reserved.
//

import Foundation

let NUM_IMAGES:CGFloat = 2
let IMAGE_SIZE = UIScreen.mainScreen().bounds.size.width / NUM_IMAGES
let SCROLL_HEIGHT:CGFloat = 250
let NAME_OFFSET:CGFloat = 100
let CAMERA_SIZE:CGFloat = 50
let CAMERA_YOFFSET:CGFloat = 200
let CAMERA_CENTERED = (UIScreen.mainScreen().bounds.size.width - CAMERA_SIZE)/2

class RADPlantViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var plant:RADPlant
    var nameLabel = UILabel()
    var cameraButton = UIButton()
    var scrollView = UIScrollView()
    var imagePicker = UIImagePickerController()
    
    init(plant: RADPlant) {
        self.plant = plant
        super.init()
    }
    
    override func viewDidLoad() {
        self.setUpViews()
    }
    
    override func viewWillAppear(animated: Bool) {
        let containerHeight = (((CGFloat(self.plant.images.count) - 1) / NUM_IMAGES) + 1) * IMAGE_SIZE
        if (CGFloat(containerHeight) > SCROLL_HEIGHT) {
            self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: containerHeight);
        }
        
        for (var i = 0 ; i < self.plant.images.count; i++) {
            let image = self.plant.images.objectAtIndex(i) as UIImage
            let xOffset = CGFloat(i) % NUM_IMAGES * IMAGE_SIZE
            let yOffset = CGFloat(i) / NUM_IMAGES * IMAGE_SIZE
            let imageButton = UIButton(frame: CGRectMake(xOffset, yOffset, IMAGE_SIZE, IMAGE_SIZE))
            imageButton.setBackgroundImage(image, forState: UIControlState.Normal)
            self.scrollView.addSubview(imageButton)
        }
        
    }
    
    func setUpViews() {
        view.backgroundColor = darkGreen
        
        nameLabel.text = self.plant.name
        nameLabel.sizeToFit()
        nameLabel.textColor = UIColor.whiteColor()
        nameLabel.frame = CGRectMake(
            (self.view.frame.size.width - nameLabel.frame.size.width)/2,
            NAME_OFFSET,
            nameLabel.frame.size.width,
            nameLabel.frame.size.width)
        
        cameraButton.frame = CGRectMake(CAMERA_CENTERED, CAMERA_YOFFSET, CAMERA_SIZE, CAMERA_SIZE * 0.75)
        cameraButton.backgroundColor = UIColor.blueColor()
//        cameraButton.setImage(UIImage(named: "camera.png"), forState: UIControlState.Normal)
        cameraButton.addTarget(self, action:"openPhoto:", forControlEvents: UIControlEvents.TouchUpInside)
        
        scrollView.frame = CGRectMake(0, view.frame.size.height - SCROLL_HEIGHT, view.frame.size.width, SCROLL_HEIGHT);
        scrollView.contentSize = CGSizeMake(view.frame.size.width, SCROLL_HEIGHT)
    
        let scale:CGFloat = 1.33
        let imageHeight = self.view.frame.size.width * scale
        let transform = CGAffineTransformMakeTranslation(0, (self.view.frame.size.height - imageHeight)/2)
        
        view.addSubview(nameLabel)
        view.addSubview(cameraButton)
        //view.addSubview(scrollView)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        self.plant = RADPlant(name: "plant")
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    func openPhoto(sender:UIButton!) {
        if (!UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            // todo can't open image
        } else {
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.showsCameraControls = false
            
            // add overlay of previous image, if there
            if (plant.images.count > 0) {
                let overlayView = UIView(frame: view.frame)
                let overlayImage = UIImageView(image: (plant.images.lastObject as RADPlantImage).image)
                overlayImage.contentMode = UIViewContentMode.ScaleAspectFit
                var frame = overlayImage.frame
                frame.size.width = view.frame.size.width
                frame.size.height = view.frame.size.height
                overlayImage.frame = frame
                overlayImage.alpha = 0.7
                overlayView.addSubview(overlayImage)
                imagePicker.cameraOverlayView = overlayView
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
        let plantImage = RADPlantImage(image: chosenImage)
        let containerHeight = (((CGFloat(plant.images.count) - 1) / NUM_IMAGES) + 1) * IMAGE_SIZE
        let xOffset = (CGFloat(plant.images.count) - 1) % NUM_IMAGES * IMAGE_SIZE
        let yOffset = containerHeight - IMAGE_SIZE
        
        if (containerHeight > SCROLL_HEIGHT) {
            scrollView.contentSize = CGSizeMake(view.frame.size.width, containerHeight)
        }
        
        // TODO: change size of chosen image
        let imageButton = UIButton(frame: CGRectMake(xOffset, yOffset, IMAGE_SIZE, IMAGE_SIZE))
        imageButton.setBackgroundImage(chosenImage, forState: UIControlState.Normal)
        scrollView.addSubview(imageButton)
        
    }
}