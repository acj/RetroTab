//
//  FormattedTextViewController.swift
//  RetroTab
//
//  Created by Adam Jensen on 8/23/16.

import Cocoa

class FormattedTextViewController: NSViewController {
    @IBOutlet var textView: NSTextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let image = NSImage(named: "sample1")
        OpenCVBridge.identifyStructuredTextInImage(image) { textRows in
            let formattedText = CSVTextFormatter.formatText(textRows)
            self.textView.string = formattedText
        }
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

