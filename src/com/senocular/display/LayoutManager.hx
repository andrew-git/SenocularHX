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
import flash.events.EventDispatcher;
import flash.geom.Rectangle;
import nme.ObjectHash;

/*
 * Dispatched when any registered layout changes.
 */@:meta(Event(name="change"))
// [Event(name="change", type="flash.events.Event")]
/**
 * The LayoutManager class is used to help layout instances
 * keep up to date. By registering a diaplay object with a 
 * LayoutManager instance, a layout object is created and
 * associated with that display object.  This layout object can
 * then be recognized when a parent display object within the 
 * display list with a layout is updated and update
 * itself with that parent's changes.  Additionally, by using
 * LayoutManager.initializeAutoUpdate(), with a reference to stage
 * the RENDER event will be used to automatically update registered
 * layouts at the end of a frame when they've changed. When
 * registered layouts change, the LayoutManager will dispatch a
 * CHANGE event.
 * <br/><br/>
 * The LayoutManager works through instances as well as a singleton.
 * If you do not want to manage multiple instances of LayoutManager,
 * you can call LayoutManager methods directly from the LayoutManager
 * class (meaning the class has two sets of methods, one set for 
 * instances and one set static).
 * <br/><br/>
 * Use of the LayoutManager is optional for layouts.  If you do not
 * use the LayoutManager class, then you will need to make sure to
 * call draw() for all of your layouts to make sure they are
 * properly updated.
 *
 * @author Trevor McCauley, www.senocular.com
 * @date August 22, 2008
 * @version 1.0.1
 */class LayoutManager extends EventDispatcher {

    static var _instance : LayoutManager = new LayoutManager();
    
    static public function RegisterNewLayout(target : DisplayObject, useDefaultChangeHandler : Bool = true) : Layout {
        return _instance.registerNewLayout(target, useDefaultChangeHandler);
    }
    static public function GetLayout(target : DisplayObject) : Layout {
        return _instance.getLayout(target);
    }
    static public function UnregisterLayout(target : DisplayObject) : Layout {
        return _instance.unregisterLayout(target);
    }
    static public function IsRegisteredLayout(target : DisplayObject) : Bool {
        return _instance.isRegisteredLayout(target);
    }    
    static public function InitializeAutoUpdate(stage : Stage) : Void {
        _instance.initializeAutoUpdate(stage);
    }    
    static public function Draw() : Void {
        _instance.validate(null);
    }

    public var invalidList : ObjectHash<Layout, Bool>;
    public var registeredList : ObjectHash<DisplayObject,Layout>;
    var stage : Stage;
    var invalid : Bool;
    /**
     * Constructor. Creates a new LayoutManager instance from which
     * you can register layouts for diaply objects.  As an alternative
     * to making your own LayoutManager instances, you can also use
     * the static methods from the LayoutManager class to handle all
     * layouts.
     */    
    public function new() {
        invalidList = new ObjectHash();
        registeredList = new ObjectHash();
        super();
    }

    /**
     * Registers a display object with a layout. As a 
     * registered layout, it will be available for updates
     * if the Layout class is initialized with auto updates
     * and for propagation of changes from parent layouts. If the
     * target display object already has a registered layout
     * for this same LayoutManager, that layout is returned. If the
     * target is registered to another layout manager, it will 
     * continue to be registered to that layout manager with a 
     * separate layout instance.
     * @param target The display object to get a layout for.
     * @param changeHandler If a new Layout instance is created, this
     *         handler will be used to update the target during the CHANGE
     *         event [optional].
     */    public function registerNewLayout(target : DisplayObject, useDefaultChangeHandler : Bool = true) : Layout {
        // create new layout and associate with target
        // if doesn't already exist in registeredList
        if(!(registeredList.exists(target)))  {
            var layout : Layout = new Layout(target, useDefaultChangeHandler);
            layout.manager = this;
            registeredList.set(target,layout);
        }
        return registeredList.get(target);
    }

    /**
     * Returns the current layout object associated with 
     * the passed display object.  If no layout has been
     * registered for that object, null is returned.
     * @param target The display object to get a layout for.
     */    public function getLayout(target : DisplayObject) : Layout {
        if(registeredList.exists(target))  {
            return registeredList.get(target);
        }
        return null;
    }

    /**
     * Unregisters a display object's layout. As a 
     * registered layout, it will be available for updates
     * if the LayoutManager class is initialized with auto updates
     * and for propagation of changes from parent layouts. When
     * unregistered, updates will have to be made manually.
     * @param target The display object to unregister from the manager.
     */    public function unregisterLayout(target : DisplayObject) : Layout {
        if(registeredList.exists(target))  {
            var layout : Layout = registeredList.get(target);
            layout.manager = null;
            registeredList.remove(target);
            return layout;
        }
        return null;
    }

    /**
     * Determines if the display object has a registered layout.
     * @param target A display object to check if registered
     *         to this LayoutManager instance.
     */    public function isRegisteredLayout(target : DisplayObject) : Bool {
        return registeredList.exists(target);
    }

    /**
     * Initializes the Layout class to perform automatic updates
     * for all registered layouts.  Updates happen during the RENDER
     * event and only occur if there was a change in a layout. If
     * already initialized the Layout class for auto updates and
     * want to stop the auto updates, call initializeAutoUpdate
     * again but pass null instead of a reference to the stage.
     * @param stage A reference to the stage to be used to 
     *         allow for updates in the RENDER event.
     */    public function initializeAutoUpdate(stage : Stage) : Void {
        if(this.stage != null)  {
            this.stage.removeEventListener(Event.RENDER, validate, false);
        }
        this.stage = stage;
        if(this.stage != null)  {
            this.stage.addEventListener(Event.RENDER, validate, false, 1, true);
        }
    }

    /**
     * Draws and updates all layouts in the layout manager
     */    public function draw() : Void {
        validate(null);
    }

    /**
     * Adds the passed layout to the invalid list of the manager
     * and invalidates the stage (if available) to ensure that
     * validate will be called in the next RENDER event
     * @private
     */    
    public function invalidate(layout : Layout) : Void {
        invalidList.set(layout,true);
        if(stage != null)  {
            if(!invalid)  {
                stage.invalidate();
                invalid = true;
            }
            // WORKAROUND: needed to retain render listeners
            // in case another action uses
            // removeEventListener(Event.RENDER, ... )
            // which removes all RENDER listeners (bug)
            initializeAutoUpdate(stage);
        }
    }

    /*
     * Called in the RENDER event, updates all invalid
     * layouts in the manager
     */    
    function validate(event : Event) : Void {
        removeInvalidRedundancies();
        // draw each layout in invalid list
        var changedList : ObjectHash<Layout,Bool> = new ObjectHash();
        for(element in invalidList.keys()) {
            element._draw(changedList);
        }

        Layout.updateChanged(changedList);
        // dispatch manager CHANGE if
        // changedList has any layouts
        for(element in changedList) {
            dispatchEvent(new Event(Event.CHANGE));
            break;
        }

        invalid = false;
    }

    /*
     * Each invalid layout will also update it's children to fit
     * within its new contraints/bounds.  If these children are
     * also invalid, they can be removed from the invalid list since
     * they will automatically be drawn when their parent layout is
     */    function removeInvalidRedundancies() : Void {
        for(element in invalidList) {
            removeRedundantChildren(cast((element), Layout));
        }

    }

    function removeRedundantChildren(layout : Layout) : Void {
        // first check any children within the childList
        for(element in layout.childList.keys()) {
            if(invalidList.exists(element))  {
                invalidList.remove(element);
            }
        }
        // second check registered layouts in the target container
        if(Std.is(layout.target, DisplayObjectContainer))  {
            var targetContainer : DisplayObjectContainer = cast((layout.target), DisplayObjectContainer);
            var i : Int = targetContainer.numChildren;
            var child : DisplayObject;
            while(i>=0) {
                child = targetContainer.getChildAt(i);
                if(registeredList.exists(child))  {
                    if(invalidList.exists(registeredList.get(child)))  {
                        invalidList.remove(registeredList.get(child));
                    }
                }
                i--;
            }

        }

    }

}

