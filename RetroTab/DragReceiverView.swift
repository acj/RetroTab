//
//  DragReceiverView.swift
//  RetroTab
//
//  Created by Adam Jensen on 8/29/16.

import Cocoa

class DragReceiverView: NSView {

    weak var delegate: DragReceiverViewDelegate?
    let fileTypes = ["jpg", "jpeg", "bmp", "png", "gif"]
    var fileTypeIsAcceptable = false
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        let supportedDraggedTypes = [
            NSFilenamesPboardType,
            NSURLPboardType,
            NSPasteboardTypeTIFF,
            NSPasteboardTypePNG,
            NSTIFFPboardType
        ]
        registerForDraggedTypes(supportedDraggedTypes)
    }
    
    override func draggingEntered(sender: NSDraggingInfo) -> NSDragOperation {
        // TODO: Add handling for "raw" images that are not file paths
        if checkExtension(sender) {
            fileTypeIsAcceptable = true
            return .Copy
        } else {
            fileTypeIsAcceptable = false
            return .None
        }
    }
    
    override func draggingUpdated(sender: NSDraggingInfo) -> NSDragOperation {
        if fileTypeIsAcceptable {
            return .Copy
        } else {
            return .None
        }
    }
    
    override func performDragOperation(sender: NSDraggingInfo) -> Bool {
        if let board = sender.draggingPasteboard().propertyListForType("NSFilenamesPboardType") as? NSArray,
            imagePath = board[0] as? String {
            delegate?.dragReceiverViewDidReceiveDragPath(self, dragPath: imagePath)
            return true
        }
        return false
    }
    
    func checkExtension(drag: NSDraggingInfo) -> Bool {
        if let board = drag.draggingPasteboard().propertyListForType("NSFilenamesPboardType") as? NSArray,
            path = board[0] as? String {
            let url = NSURL(fileURLWithPath: path)
            if let fileExtension = url.pathExtension?.lowercaseString {
                return fileTypes.contains(fileExtension)
            }
        }
        return false
    }
    
}

protocol DragReceiverViewDelegate: class {
    func dragReceiverViewDidReceiveDragPath(view: DragReceiverView, dragPath: String)
}