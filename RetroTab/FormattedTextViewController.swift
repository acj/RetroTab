//
//  FormattedTextViewController.swift
//  RetroTab
//
//  Created by Adam Jensen on 8/23/16.

import Cocoa

class FormattedTextViewController: NSViewController {
    
    @IBOutlet var textView: NSTextView!
    var formattedText: String?

    override func viewWillAppear() {
        super.viewWillAppear()
        
        if let formattedText = formattedText {
            textView.string = formattedText
        }
    }
    
}

