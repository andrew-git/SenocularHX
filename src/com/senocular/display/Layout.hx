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
import flash.display.DisplayObjectContainer;
import flash.display.Stage;
import flash.events.Event;
import flash.geom.Rectangle;
import nme.ObjectHash;

/*
 * Dispatched when the layout is updated and its contents
 * (the target display object) should be redrawn to fit in
 * the layout's new rect.
 */@:meta(Event(name="change"))
// [Event(name="change", type="flash.events.Event")]
// vers 1.0.1:
// useDefaultChangeHandler now defaults to true
// prevented defaultChangeHandler from erroring with Stage target
// corrected ambiguous error for CS4 compiler
// added maintainAspectRatioPolicy + related constants
// added @private tags to internal data members to keep
//        them out of documentation
// added LayoutConstraint.init()
/**
 * The Layout class is used to create dynamically sized and positioned
 * layouts that adjust content to fit within a containing boundary. Layout
 * instances are (usually) associated with single target DisplayObject
 * instances and dispatch a CHANGE event when it's layout has changed
 * allowing that target to fit itself to the layout's rectangle boundary
 * (rect).
 * <br/><br/>
 * Using the optional LayoutManager class, Layout instances can be automatically
 * updated when they are modified and propagate their changes to child
 * display objects or layouts that are also using the same LayoutManager
 * when contained within the same display hierarchy. Without the using
 * LayoutManager, updates can be forced using the draw() method. Updates to
 * children will automatically be propagated.
 * <br/><br/>
 * If LayoutManager is not being used, you would need to update your layout
 * using the draw() method (this may sometimes still needed when the 
 * LayoutManager class is being used). This method dispatches the CHANGE
 * event for the layout and all of its children also affected by
 * the change in the layout if there was a change. It is generally the
 * responsibility of the target instance to physically position and size 
 * itself to a layout's rect during the CHANGE event in an event handler,
 * though the Layout class does provide an automatic handler that will fit
 * a target to the layout's rect by setting x, y, width and height directly.
 * When the stage is used as a target for a layout, that layout will
 * automatically update during the stage's RESIZE event and fit itself
 * to match the size of the stage.
 * <br/><br/>
 * Each layout instance is also an instance of a LayoutConstraint.  The
 * LayoutConstraint class defines the constraints specific to each layout
 * that affect the direct contents of the target display object associated
 * with that layout. Normally you would not create instances of 
 * LayoutConstraint.  For laying out your objects you would use a Layout
 * instance.  The exception is for Layout children.  Each layout will 
 * arrange child layouts within its rect area.  An optional children
 * property can be set (to either a Layout or a LayoutConstraint) to fit
 * all children within a specific layout of the target layout.  Basically
 * it serves as an intermediary child layout to contain all other child
 * layouts.
 *
 * @author Trevor McCauley, www.senocular.com
 * @date August 22, 2008
 * @version 1.0.1
 */class Layout extends LayoutConstraint {
    public var useDefaultChangeHandler(getUseDefaultChangeHandler, setUseDefaultChangeHandler) : Bool;
    public var parent(getParent, never) : Layout;
    public var children(getChildren, setChildren) : LayoutConstraint;
    public var manager(getManager, setManager) : LayoutManager;
    public var target(getTarget, setTarget) : DisplayObject;

    /**
     * A predefined change handler for generic objects
     * being fit within a contraint's bounds. This
     * handler maps the display objects x, y, width and
     * height properties directly to the respective properties
     * within the layout rect.
     * @param event The CHANGE event object dispatched to this
     *         handler when a layout has changed.
     */    static public function defaultChangeHandler(event : Event) : Void {
        var layout : Layout = cast((event.target), Layout);
        var layoutTarget : DisplayObject = layout.target;
        if(layoutTarget == null || Std.is(layoutTarget, Stage)) 
            return;
        var layoutRect : Rectangle = layout.rect;
        layoutTarget.x = layoutRect.x;
        layoutTarget.y = layoutRect.y;
        layoutTarget.width = layoutRect.width;
        layoutTarget.height = layoutRect.height;
    }

    /**
     * Dispatches the CHANGE event for each layout with changes
     * @private
     */    
    public static function updateChanged(changedList : ObjectHash<Layout, Bool>) : Void {
        var layout : Layout;
        for(element in changedList.keys()) {
            layout = element;
            if(layout.lastRect.x != layout._rect.x || layout.lastRect.y != layout._rect.y || layout.lastRect.width != layout._rect.width || layout.lastRect.height != layout._rect.height)  {
                // dispatch the change event so
                // instances will know their bounding
                // boxes (layout.rect) have changed
                layout.dispatchEvent(new Event(Event.CHANGE));
                // update last rect values
                layout.lastRect = layout._rect.clone();
            }
        }

    }

    /**
     * The change handler for updating a display object
     * when its layout has changed. This relates to the
     * changeHandler passed into the Layout constructor
     * and is optional to using addEventListener with 
     * the layout's Event.CHANGE event yourself.
     */    public function getUseDefaultChangeHandler() : Bool {
        return _useDefaultChangeHandler;
    }

    public function setUseDefaultChangeHandler(value : Bool) : Bool {
        if(value == _useDefaultChangeHandler) 
            return _useDefaultChangeHandler;
        // remove the current change handler if exists
        if(_useDefaultChangeHandler)  {
            removeEventListener(Event.CHANGE, defaultChangeHandler, false);
        }

        _useDefaultChangeHandler = value;
        // add the new change handler if not null
        if(_useDefaultChangeHandler)  {
            addEventListener(Event.CHANGE, defaultChangeHandler, false, 0, true);
        }

        return value;
    }

    var _useDefaultChangeHandler : Bool;
    /**
     * The parent layout in which the current layout is
     * contained. This property will return the parent layout
     * if that parent had this layout added to it using addChild(),
     * otherwise  if the layout within the parent of the layout's
     * target display object has been registered to the same
     * LayoutManager instance, it will return that layout.  If
     * neither are the case, null is returned [read-only].
     */    public function getParent() : Layout {
        // return explicit parent if set
        if(_parent!=null) 
            return _parent;
        // if _parent not defined, look in
        // the target's parent for a registered
        // layout which targets this instance
        // as a child layout
        if(_manager != null && _target != null && _manager.registeredList.exists(_target.parent))  {
            return _manager.registeredList.get(_target.parent);
        }
        // no parent found, return null
        return null;
    }

    var _parent : Layout;
    /**
     * An optional constraint used for layouts contained
     * within the current layout.  By default, layouts within
     * other layouts fit to the extends of the containing layout.
     * By defining a children layout constraint layouts that
     * are children of the current layout can be contained to
     * a separate set of boundaries.  The children property is
     * null by default.  To use the children layout, you must
     * first assign it to a Layout or LayoutConstraint instance.
     */    public function getChildren() : LayoutConstraint {
        return _children;
    }

    public function setChildren(value : LayoutConstraint) : LayoutConstraint {
        if(_children!=null)  {
            // remove any owner reference in the
            // current _children object
            _children.owner = null;
        }
        // assign children constraint; it cannot be 'this'
        _children = value != (this) ? value : null;
        if(_children!=null)  {
            // set up owner Layout instance. This will
            // be the Layout instance if this constraint
            // is for Layout.children, otherwise as a
            // Layout constraint, it will reference itself
            _children.owner = this;
            // child rectangles (for children constraints)
            // do not inherit positioning and are based on
            // the coordinate space (starting at 0,0)
            // of the current layout rectangle
            _children.setIn(new Rectangle(0, 0, _rect.width, _rect.height));
        }
        return value;
    }

    var _children : LayoutConstraint;
    /**
     * The LayoutManager instance managing this layout [read-only].
     */    public function getManager() : LayoutManager {
        return _manager;
    }
    
    public function setManager(value:LayoutManager) : LayoutManager {
        _manager = value;
        return _manager;
    }

    /**
     * @private
     */    var _manager : LayoutManager;
    /**
     * The target display object this layout affects.
     */    public function getTarget() : DisplayObject {
        return _target;
    }

    public function setTarget(value : DisplayObject) : DisplayObject {
        if(value == _target) 
            return _target;
        // remove resize listener if current target is stage
        if(Std.is(_target, Stage))  {
            _target.removeEventListener(Event.RESIZE, stageResized, false);
        }

        _target = value;
        // add resize listener if new target is stage
        if(Std.is(_target, Stage))  {
            _target.addEventListener(Event.RESIZE, stageResized, false, 0, true);
        }

        return value;
    }

    /**
     * @private
     */    
    var _target : DisplayObject;
    /**
     * Used in determining whether or not the layout
     * has changed since it was last updated
     * @private
     */    
    var lastRect : Rectangle;
    /**
     * A list for child references when any layout
     * defines this layout as its parent
     * @private
     */    
    public var childList : ObjectHash<Layout, Bool>;
    /**
     * Constructor for creating new Layout instances.  If you want
     * your instances to automatically update, you would generally
     * favor LayoutManager.registerNewLayout() in favor of creating
     * layout instances with the Layout constructor.
     * @param target The target display object this layout instance
     *         will be associated. Of the target is stage, an automatic
     *         listner for the RESIZE event will be added to update the
     *         layout's size to match the stage's [optional].
     * @param changeHandler A change handler function that will
     *         automatically be set to listen to the CHANGE event for
     *        the new layout instance [optional].
     */    
    public function new(target : DisplayObject = null, useDefaultChangeHandler : Bool = true) {
        lastRect = new Rectangle();
        childList = new ObjectHash<Layout,Bool>();
        // default target rectangle
        var targetRect : Rectangle = new Rectangle(0, 0, 100, 100);
        if(target != null)  {
            // assign the target (display object)
            // using this layout
            this.target = target;
            // set up the constraint for the target using
            // this Layout instance. A special case is made
            // if target is the stage instance where the
            // initial rect is based on the stage size.
            // Otherwise its based on the target location and size.
            if(Std.is(_target, Stage))  {
                targetRect = new Rectangle(0, 0, cast((_target), Stage).stageWidth, cast((_target), Stage).stageHeight);
            }

            else if(_target.width>0 && _target.height>0)  {
                targetRect = new Rectangle(_target.x, _target.y, _target.width, _target.height);
            }

        }
        // call constraint super
        super(targetRect);
        // assign the owner of the constraint
        // to be this layout instance
        owner = this;
        // assign changeHandler listener
        this.useDefaultChangeHandler = useDefaultChangeHandler;
    }

    /**
     * Creates a new copy of the current Layout instance.
     * Cloned layouts do do not retain an association with any
     * LayoutManager used with the original.
     */    override public function clone() : LayoutConstraint {
        var layout : Layout = new Layout(_target, _useDefaultChangeHandler);
        layout.match(this);
        if(_children != null)  {
            layout.children = _children.clone();
        }
        if(_parent != null)  {
            _parent.addChild(layout);
        }
        return layout;
    }

    /**
     * Adds a layout to be the child of the current layout.
     * As a child, changes from this layout will be propagated
     * to that layout to assure that it is properly
     * constrained within this layout's boundaries.
     * @param childLayout The layout to be made a
     *         child of the current layout.
     */    public function addChild(childLayout : Layout) : Layout {
        if(childLayout._parent!=null)  {
            childLayout._parent.removeChild(childLayout);
        }
        childList.set(childLayout,true);
        childLayout._parent = this;
        return childLayout;
    }

    /**
     * Removes a layout as a child of this layout.
     * @param childLayout The layout to be removed as a
     *         child of the current layout.
     */    public function removeChild(childLayout : Layout) : Layout {
        if(childList.exists(childLayout))  {
            childList.remove(childLayout);
            childLayout._parent = null;
        }
        return childLayout;
    }

    /**
     * Updates the layout (current and children) dimensions
     * dispatching the Layout.CHANGE event for this layout or
     * any child layouts affected.
     */    public function draw() : Void {
        var changedList : ObjectHash<Layout,Bool> = new ObjectHash();
        _draw(changedList);
        updateChanged(changedList);
    }

    /**
     * Invalidates the instance so that it
     * will be validated during the next update
     * @private
     */    
    override function invalidate() : Void {
        // make sure instance is invalid
        // using inherited invalidate
        super.invalidate();
        if(_manager != null)  {
            _manager.invalidate(this);
        }
    }

    /**
     * Internal version of draw which does the actual drawing
     * @private
     */    
    public function _draw(changedList : ObjectHash<Layout, Bool>) : Void {
        // mark layout as changed
        // only layouts in changed list will
        // dispatch the CHANGE event and
        // only if their rect has changed
        changedList.set(this,true);
        // if there is a specified parent, use it
        // to fit this layout to fit within
        // the parent children contraint
        if(_parent != null)  {
            if(_parent._children != null)  {
                setIn(_parent._children._rect);
            }

            else  {
                setIn(new Rectangle(0, 0, _parent._rect.width, _parent._rect.height));
            }

        }

        else if(_manager != null && _target != null && _manager.registeredList.exists(_target.parent))  {
            var parentLayout : Layout = _manager.registeredList.get(_target.parent);
            if(parentLayout._children!=null)  {
                setIn(parentLayout._children._rect);
            }

            else  {
                setIn(new Rectangle(0, 0, parentLayout._rect.width, parentLayout._rect.height));
            }

        }

        else  {
            setIn(null);
        }

        if(_children != null)  {
            // update the children constraint
            // to fit within the current layout
            // child rectangles (for children constraints)
            // do not inherit positioning and are based on
            // the coordinate space (starting at 0,0)
            // of the current layout rectangle
            _children.setIn(new Rectangle(0, 0, _rect.width, _rect.height));
            // children no longer invalid
            _children.invalid = false;
        }
        // loop through all the children of the
        // parent layout and draw all the
        // children which are registered
        // first check any children within the childList
        for(element in childList.keys()) {
            element._draw(changedList);
        }
        // second check registered layouts in the target container
        if(_manager != null && Std.is(_target, DisplayObjectContainer))  {
            var targetContainer : DisplayObjectContainer = cast((_target), DisplayObjectContainer);
            var i : Int = targetContainer.numChildren;
            var child : DisplayObject;            
            while (i > 0) {
                i--;
                child = targetContainer.getChildAt(i);
                // draw the child if it is registered
                // under the same manager as this instance
                if(_manager.registeredList.exists(child))  {
                    _manager.registeredList.get(child)._draw(changedList);
                }                    
            }
    

        }
        // clear layout invalid flags
        invalid = false;
        if(_manager != null)  {
            _manager.invalidList.remove(this);
        }
    }

    /*
     * Event handler for stage resizing if target is the stage
     */    function stageResized(event : Event) : Void {
        // remove resize listener if target
        // finds itself not being the stage
        if(!(Std.is(_target, Stage)))  {
            removeEventListener(Event.RESIZE, stageResized);
            return;
        }
        // set the width and height to be
        // the width and height of the stage
        width = cast((_target), Stage).stageWidth;
        height = cast((_target), Stage).stageHeight;
        // update
        draw();
    }

}

