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
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Matrix;
import flash.geom.Point;
//import flash.utils.Dictionary;    
import nme.ObjectHash;

class TransformToolCursor extends TransformToolControl {
    public var mouseOffset(getMouseOffset, setMouseOffset) : Point;

    var _mouseOffset : Point;
    var contact : Bool;
    var active : Bool;
    var references : ObjectHash<Dynamic,Dynamic>;
    public function getMouseOffset() : Point {
        return _mouseOffset.clone();
    }

    public function setMouseOffset(p : Point) : Point {
        _mouseOffset = p;
        return p;
    }

    public function new() {
        _mouseOffset = new Point(20, 20);
        contact = false;
        active = false;
        references = new ObjectHash();
        addEventListener(TransformTool.CONTROL_INIT, init);
        super();
    }

    /**

     * Adds a reference to the list of references that the cursor

     * uses to determine when to be displayed.  Typically this would

     * be a TransformToolControl instance used in the transform tool

     * @see removeReference

     */    public function addReference(reference : DisplayObject) : Void {
        if(reference != null && !Reflect.field(references, Std.string(reference)))  {
            Reflect.setField(references, Std.string(reference), true);
            addReferenceListeners(reference);
        }
    }

    /**

     * Removes a reference to the list of references that the cursor

     * uses to determine when to be displayed.

     * @see addReference

     */    public function removeReference(reference : DisplayObject) : DisplayObject {
        if(reference != null && Reflect.field(references, Std.string(reference)))  {
            removeReferenceListeners(reference);
            references.remove(reference);
            return reference;
        }
        return null;
    }

    /**

     * Called when the cursor should determine 

     * whether it should be visible or not

     */    public function updateVisible(event : Event = null) : Void {
        if(active)  {
            if(!visible)  {
                visible = true;
            }
        }

        else if(visible != contact)  {
            visible = contact;
        }
        position(event);
    }

    /**

     * Called when the cursor should position itself

     */    public function position(event : Event = null) : Void {
        if(parent!=null)  {
            x = parent.mouseX + mouseOffset.x;
            y = parent.mouseY + mouseOffset.y;
        }
    }

    function init(event : Event) : Void {
        _transformTool.addEventListener(TransformTool.TRANSFORM_TOOL, position, false, 0, true);
        _transformTool.addEventListener(TransformTool.NEW_TARGET, referenceUnset, false, 0, true);
        _transformTool.addEventListener(TransformTool.CONTROL_TRANSFORM_TOOL, position, false, 0, true);
        _transformTool.addEventListener(TransformTool.CONTROL_DOWN, controlMouseDown, false, 0, true);
        _transformTool.addEventListener(TransformTool.CONTROL_MOVE, controlMove, false, 0, true);
        _transformTool.addEventListener(TransformTool.CONTROL_UP, controlMouseUp, false, 0, true);
        updateVisible(event);
        position(event);
    }

    function addReferenceListeners(reference : DisplayObject) : Void {
        reference.addEventListener(MouseEvent.MOUSE_MOVE, referenceMove, false, 0, true);
        reference.addEventListener(MouseEvent.MOUSE_DOWN, referenceSet, false, 0, true);
        reference.addEventListener(MouseEvent.ROLL_OVER, referenceSet, false, 0, true);
        reference.addEventListener(MouseEvent.ROLL_OUT, referenceUnset, false, 0, true);
    }

    function removeReferenceListeners(reference : DisplayObject) : Void {
        reference.removeEventListener(MouseEvent.MOUSE_MOVE, referenceMove, false);
        reference.removeEventListener(MouseEvent.MOUSE_DOWN, referenceSet, false);
        reference.removeEventListener(MouseEvent.ROLL_OVER, referenceSet, false);
        reference.removeEventListener(MouseEvent.ROLL_OUT, referenceUnset, false);
    }

    function referenceMove(event : MouseEvent) : Void {
        position(event);
        event.updateAfterEvent();
    }

    function referenceSet(event : Event) : Void {
        contact = true;
        if(_transformTool.currentControl==null)  {
            updateVisible(event);
        }
    }

    function referenceUnset(event : Event) : Void {
        contact = false;
        if(_transformTool.currentControl==null)  {
            updateVisible(event);
        }
    }

    // the following control methods rely on TransformToolControl.relatedObject
        // to tell if a reference is being interacted with and therefore active
        function controlMouseDown(event : Event) : Void {
        if(references[_transformTool.currentControl.relatedObject])  {
            active = true;
        }
        updateVisible(event);
    }

    function controlMove(event : Event) : Void {
        if(references[_transformTool.currentControl.relatedObject])  {
            position(event);
        }
    }

    function controlMouseUp(event : Event) : Void {
        if(references[_transformTool.currentControl.relatedObject])  {
            active = false;
        }
        updateVisible(event);
    }

}

