//
//  DropImageViewController.swift
//  RetroTab
//
//  Created by Adam Jensen on 8/29/16.
//  Copyright © 2016 Adam Jensen. All rights reserved.
//

import Cocoa

class DropImageViewController: NSViewController {
    @IBOutlet weak var dragReceiverView: DragReceiverView!
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
    func processImage(path: String) {
        if let image = NSImage(contentsOfFile: path) {
            OpenCVBridge.identifyStructuredTextInImage(image) { textRows in
                self.formattedText = CSVTextFormatter.formatText(textRows)
                self.performSegueWithIdentifier("showFormattedTextSegue", sender: self)
            }
        } else {
            // TODO: error
            NSLog("Error opening file")
        }
    }
}

extension DropImageViewController: DragReceiverViewDelegate {
    func dragReceiverViewDidReceiveDragPath(view: DragReceiverView, dragPath: String) {
        processImage(dragPath)
    }
}