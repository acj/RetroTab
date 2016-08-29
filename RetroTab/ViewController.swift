//
//  ViewController.swift
//  RetroTab
//
//  Created by Adam Jensen on 8/23/16.

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let image = NSImage(named: "sample1")
        OpenCVBridge.identifyStructuredTextInImage(image) { textRows in
            // TODO
        }
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

