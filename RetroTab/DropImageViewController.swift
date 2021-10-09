//
//  DropImageViewController.swift
//  RetroTab
//
//  Created by Adam Jensen on 8/29/16.
//  Copyright © 2016 Adam Jensen. All rights reserved.
//

import Cocoa

class DropImageViewController: NSViewController {
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var dropImageLabel: NSTextField!
    @IBOutlet weak var dragReceiverView: DragReceiverView!
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    private var formattedText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dragReceiverView.delegate = self
    }
    
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showFormattedTextSegue",
            let windowController = segue.destinationController as? NSWindowController,
            let vc = windowController.contentViewController as? FormattedTextViewController {
                vc.formattedText = formattedText
        }
    }
}

private extension DropImageViewController {
    func processImage(image: NSImage) {
        progressIndicator.hidden = false
        progressIndicator.startAnimation(nil)
        imageView.hidden = true
        dropImageLabel.hidden = true
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { 
            OpenCVBridge.identifyStructuredTextInImage(image) { textRows in
                dispatch_async(dispatch_get_main_queue()) {
                    self.formattedText = CSVTextFormatter.formatText(textRows)
                    self.performSegueWithIdentifier("showFormattedTextSegue", sender: self)
                    
                    self.progressIndicator.hidden = true
                    self.progressIndicator.stopAnimation(nil)
                    self.imageView.hidden = false
                    self.dropImageLabel.hidden = false
                }
            }
        }
    }
}

extension DropImageViewController: DragReceiverViewDelegate {
    func dragReceiverViewDidReceiveDragPath(view: DragReceiverView, dragPath: String) {
        if let image = NSImage(contentsOfFile: dragPath) {
            processImage(image)
        } else {
            // TODO: error
            NSLog("Error opening file")
        }
    }
}