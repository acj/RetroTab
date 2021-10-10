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
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFormattedTextSegue",
            let windowController = segue.destinationController as? NSWindowController,
            let vc = windowController.contentViewController as? FormattedTextViewController {
                vc.formattedText = formattedText
        }
    }
}

private extension DropImageViewController {
    func processImage(image: NSImage) {
        progressIndicator.isHidden = false
        progressIndicator.startAnimation(nil)
        imageView.isHidden = true
        dropImageLabel.isHidden = true
        
        DispatchQueue.global(qos: DispatchQoS.default.qosClass).async {
            OpenCVBridge.identifyStructuredText(in: image) { textRows in
                DispatchQueue.main.async {
                    self.formattedText = CSVTextFormatter.formatText(textRows)
                    self.performSegue(withIdentifier: "showFormattedTextSegue", sender: self)
                    
                    self.progressIndicator.isHidden = true
                    self.progressIndicator.stopAnimation(nil)
                    self.imageView.isHidden = false
                    self.dropImageLabel.isHidden = false
                }
            }
        }
    }
}

extension DropImageViewController: DragReceiverViewDelegate {
    func dragReceiverViewDidReceiveDragPath(view: DragReceiverView, dragPath: String) {
        if let image = NSImage(contentsOfFile: dragPath) {
            processImage(image: image)
        } else {
            // TODO: error
            NSLog("Error opening file")
        }
    }
}
