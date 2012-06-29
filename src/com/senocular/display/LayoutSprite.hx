////////////////////////////////////////////////////////////////////////////////
//=BEGIN LICENSE MIT
//
// Copyright (c) 2012, Original author & contributors
// Original author : Trevor McCauley, www.senocular.com
// Contributors: Andras Csizmadia <andras@vpmedia.eu> 
// 
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//  
//=END LICENSE MIT
////////////////////////////////////////////////////////////////////////////////
package com.senocular.display;
    
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;

/**
 * Base class for a Canvas using
 * a Layout. To fit to a layout, the bottom most
 * child display object is resized to match
 * the layout's size.
 */
class LayoutSprite extends Sprite {
    
    /**
     * Layout object assocaitated with this
     * instance [read-only].
     */
    public var layout:Layout;
    
    /**
     * Constructor.
     */
    public function new(){
        super();
        
        // register and create a layout for this
        // instance that is assocaitated with the 
        // LayoutManager class (singleton)
        layout = LayoutManager.RegisterNewLayout(this);
        layout.addEventListener(Event.CHANGE, updateLayoutHandler, false, 0, true);
    }
    
    /*
     * Layout CHANGE event handler. Resizes the background
     * (bottom-most) display object to fit the bounds
     * of the instance's layout 
     */
    function updateLayoutHandler(event:Event):Void {
        // get the rect from the Layout instance
        // that dispatched the CHANGE event (layout)
        var bounds:Rectangle = cast(event.target, Layout).rect;
        
        // position instance to location
        // specified in the layout rect
        x = bounds.x;
        y = bounds.y;
        
        // resize the bottom-most display object
        // (if there) to fit the size of the layout rect
        trace(event);
        if (numChildren > 0)
        {
            var bg:DisplayObject = getChildAt(0);
            bg.width = Math.max(0, bounds.width);
            bg.height = Math.max(0, bounds.height);
        }
    }
}