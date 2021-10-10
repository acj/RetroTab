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
            NSPasteboard.PasteboardType.fileURL,
            NSPasteboard.PasteboardType.URL,
            NSPasteboard.PasteboardType.tiff,
            NSPasteboard.PasteboardType.tiff,
            NSPasteboard.PasteboardType.png,
        ]
        registerForDraggedTypes(supportedDraggedTypes)
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        // TODO: Add handling for "raw" images that are not file paths
        if checkExtension(drag: sender) {
            fileTypeIsAcceptable = true
            return .copy
        } else {
            fileTypeIsAcceptable = false
            return []
        }
    }
    
    override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
        if fileTypeIsAcceptable {
            return .copy
        } else {
            return []
        }
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        if let board = sender.draggingPasteboard.propertyList(forType: NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")) as? NSArray,
           let imagePath = board[0] as? String {
            delegate?.dragReceiverViewDidReceiveDragPath(view: self, dragPath: imagePath)
            return true
        }
        return false
    }
    
    func checkExtension(drag: NSDraggingInfo) -> Bool {
        let type = NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")
        if let board = drag.draggingPasteboard.propertyList(forType: type) as? NSArray, let path = board[0] as? String {
             let url = NSURL(fileURLWithPath: path)
             if let fileExtension = url.pathExtension?.lowercased() {
                 return fileTypes.contains(fileExtension)
             }
        }
        
        return false
    }
    
}

protocol DragReceiverViewDelegate: AnyObject {
    func dragReceiverViewDidReceiveDragPath(view: DragReceiverView, dragPath: String)
}
