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

import flash.geom.Rectangle;
import flash.events.EventDispatcher;

/**
 * Defines constraints for a layout.  The LayoutConstraint
 * class serves as both a base class for layout instances as
 * well as the class used by the children property of those
 * instances.  When you make use of the children property of
 * your Layout instances, you would generally define it as a
 * LayoutConstraint instance.
 *
 * @author Trevor McCauley, www.senocular.com
 * @date August 22, 2008
 * @version 1.0.1
 */class LayoutConstraint extends EventDispatcher {
    public var horizontalCenter(getHorizontalCenter, setHorizontalCenter) : Float;
    public var percentHorizontalCenter(getPercentHorizontalCenter, setPercentHorizontalCenter) : Float;
    public var minHorizontalCenter(getMinHorizontalCenter, setMinHorizontalCenter) : Float;
    public var maxHorizontalCenter(getMaxHorizontalCenter, setMaxHorizontalCenter) : Float;
    public var verticalCenter(getVerticalCenter, setVerticalCenter) : Float;
    public var percentVerticalCenter(getPercentVerticalCenter, setPercentVerticalCenter) : Float;
    public var minVerticalCenter(getMinVerticalCenter, setMinVerticalCenter) : Float;
    public var maxVerticalCenter(getMaxVerticalCenter, setMaxVerticalCenter) : Float;
    public var top(getTop, setTop) : Float;
    public var percentTop(getPercentTop, setPercentTop) : Float;
    public var offsetTop(getOffsetTop, setOffsetTop) : Float;
    public var minTop(getMinTop, setMinTop) : Float;
    public var maxTop(getMaxTop, setMaxTop) : Float;
    public var right(getRight, setRight) : Float;
    public var percentRight(getPercentRight, setPercentRight) : Float;
    public var offsetRight(getOffsetRight, setOffsetRight) : Float;
    public var minRight(getMinRight, setMinRight) : Float;
    public var maxRight(getMaxRight, setMaxRight) : Float;
    public var bottom(getBottom, setBottom) : Float;
    public var percentBottom(getPercentBottom, setPercentBottom) : Float;
    public var offsetBottom(getOffsetBottom, setOffsetBottom) : Float;
    public var minBottom(getMinBottom, setMinBottom) : Float;
    public var maxBottom(getMaxBottom, setMaxBottom) : Float;
    public var left(getLeft, setLeft) : Float;
    public var percentLeft(getPercentLeft, setPercentLeft) : Float;
    public var offsetLeft(getOffsetLeft, setOffsetLeft) : Float;
    public var minLeft(getMinLeft, setMinLeft) : Float;
    public var maxLeft(getMaxLeft, setMaxLeft) : Float;
    public var x(getX, setX) : Float;
    public var percentX(getPercentX, setPercentX) : Float;
    public var minX(getMinX, setMinX) : Float;
    public var maxX(getMaxX, setMaxX) : Float;
    public var y(getY, setY) : Float;
    public var percentY(getPercentY, setPercentY) : Float;
    public var minY(getMinY, setMinY) : Float;
    public var maxY(getMaxY, setMaxY) : Float;
    public var width(getWidth, setWidth) : Float;
    public var percentWidth(getPercentWidth, setPercentWidth) : Float;
    public var minWidth(getMinWidth, setMinWidth) : Float;
    public var maxWidth(getMaxWidth, setMaxWidth) : Float;
    public var height(getHeight, setHeight) : Float;
    public var percentHeight(getPercentHeight, setPercentHeight) : Float;
    public var minHeight(getMinHeight, setMinHeight) : Float;
    public var maxHeight(getMaxHeight, setMaxHeight) : Float;
    public var maintainAspectRatio(getMaintainAspectRatio, setMaintainAspectRatio) : Bool;
    public var maintainAspectRatioPolicy(getMaintainAspectRatioPolicy, setMaintainAspectRatioPolicy) : String;
    public var rect(getRect, never) : Rectangle;

    static public inline var FAVOR_WIDTH : String = "favorWidth";
    static public inline var FAVOR_HEIGHT : String = "favorHeight";
    static public inline var FAVOR_LARGEST : String = "favorLargest";
    static public inline var FAVOR_SMALLEST : String = "favorSmallest";
    var _horizontalCenter : Float;
    /**
     * When set, if left or right is not set, the layout
     * will be centered horizontally offset by the numeric
     * value of this property.
     */    public function getHorizontalCenter() : Float {
        return _horizontalCenter;
    }

    public function setHorizontalCenter(value : Float) : Float {
        _horizontalCenter = value;
        _percentHorizontalCenter = Math.NaN;
        if(!invalid) 
            invalidate();
        return value;
    }

    var _percentHorizontalCenter : Float;
    /**
     * When set, if left or right is not set, the layout
     * will be centered horizontally offset by the value
     * of this property multiplied by the containing width.
     * A value of 0 represents 0% and 1 represents 100%.
     */    public function getPercentHorizontalCenter() : Float {
        return _percentHorizontalCenter;
    }

    public function setPercentHorizontalCenter(value : Float) : Float {
        _percentHorizontalCenter = value;
        if(!invalid) 
            invalidate();
        return value;
    }

    var _minHorizontalCenter : Float;
    /**
     * The minimum horizontal center location that can be applied
     * through percentHorizontalCenter.
     */    public function getMinHorizontalCenter() : Float {
        return _minHorizontalCenter;
    }

    public function setMinHorizontalCenter(value : Float) : Float {
        _minHorizontalCenter = value;
        if(!invalid) 
            invalidate();
        return value;
    }

    var _maxHorizontalCenter : Float;
    /**
     * The maximum horizontal center location that can be applied
     * through percentHorizontalCenter.
     */    public function getMaxHorizontalCenter() : Float {
        return _maxHorizontalCenter;
    }

    public function setMaxHorizontalCenter(value : Float) : Float {
        _maxHorizontalCenter = value;
        if(!invalid) 
            invalidate();
        return value;
    }

    var _verticalCenter : Float;
    /**
     * When set, if top or bottom is not set, the layout
     * will be centered vertically offset by the numeric
     * value of this property.
     */    public function getVerticalCenter() : Float {
        return _verticalCenter;
    }

    public function setVerticalCenter(value : Float) : Float {
        _verticalCenter = value;
        _percentVerticalCenter = Math.NaN;
        if(!invalid) 
            invalidate();
        return value;
    }

    var _percentVerticalCenter : Float;
    /**
     * When set, if top or bottom is not set, the layout
     * will be centered vertically offset by the value
     * of this multiplied by to the containing height.
     * A value of 0 represents 0% and 1 represents 100%.
     */    public function getPercentVerticalCenter() : Float {
        return _percentVerticalCenter;
    }

    public function setPercentVerticalCenter(value : Float) : Float {
        _percentVerticalCenter = value;
        if(!invalid) 
            invalidate();
        return value;
    }

    var _minVerticalCenter : Float;
    /**
     * The minimum vertical center location that can be applied
     * through percentVerticalCenter.
     */    public function getMinVerticalCenter() : Float {
        return _minVerticalCenter;
    }

    public function setMinVerticalCenter(value : Float) : Float {
        _minVerticalCenter = value;
        if(!invalid) 
            invalidate();
        return value;
    }

    var _maxVerticalCenter : Float;
    /**
     * The maximum vertical center location that can be applied
     * through percentVerticalCenter.
     */    public function getMaxVerticalCenter() : Float {
        return _maxVerticalCenter;
    }

    public function setMaxVerticalCenter(value : Float) : Float {
        _maxVerticalCenter = value;
        if(!invalid) 
            invalidate();
        return value;
    }

    var _top : Float;
    /**
     * When set, the top of the layout will be located
     * offset from the top of it's container by the
     * value of this property.
     */    public function getTop() : Float {
        return _top;
    }

    public function setTop(value : Float) : Float {
        _top = value;
        _percentTop = Math.NaN;
        if(!invalid) 
            invalidate();
        return value;
    }

    var _percentTop : Float;
    /**
     * When set, the top of the layout will be located
     * offset by the value of this property multiplied
     * by the containing height.
     * A value of 0 represents 0% and 1 represents 100%.
     */    public function getPercentTop() : Float {
        return _percentTop;
    }

    public function setPercentTop(value : Float) : Float {
        _percentTop = value;
        if(!invalid) 
            invalidate();
        return value;
    }

    var _offsetTop : Float;
    /**
     * Add additional offset to be added to the top
     * value after it has been set.
     */    public function getOffsetTop() : Float {
        return _offsetTop;
    }

    public function setOffsetTop(value : Float) : Float {
        _offsetTop = value;
        if(!invalid) 
            invalidate();
        return value;
    }

    var _minTop : Float;
    /**
     * The minimum top location that can be applied
     * to the layout boundaries.
     */    public function getMinTop() : Float {
        return _minTop;
    }

    public function setMinTop(value : Float) : Float {
        _minTop = value;
        if(!invalid) 
            invalidate();
        return value;
    }

    var _maxTop : Float;
    /**
     * The maximum top location that can be applied
     * to the layout boundaries.
     */    public function getMaxTop() : Float {
        return _maxTop;
    }

    public function setMaxTop(value : Float) : Float {
        _maxTop = value;
        if(!invalid) 
            invalidate();
        return value;
    }

    var _right : Float;
    /**
     * When set, the right of the layout will be located
     * offset by the value of this property multiplied
     * by the containing width.
     */    public function getRight() : Float {
        return _right;
    }

    public function setRight(value : Float) : Float {
        _right = value;
        _percentRight = Math.NaN;
        if(!invalid) 
            invalidate();
        return value;
    }

    var _percentRight : Float;
    /**
     * When set, the right of the layout will be located
     * offset by the value of this property multiplied
     * by the containing width.
     * A value of 0 represents 0% and 1 represents 100%.
     */    public function getPercentRight() : Float {
        return _percentRight;
    }

    public function setPercentRight(value : Float) : Float {
        _percentRight = value;
        if(!invalid) 
            invalidate();
        return value;
    }

    var _offsetRight : Float;
    /**
     * Add additional offset to be added to the right
     * value after it has been set.
     */    public function getOffsetRight() : Float {
        return _offsetRight;
    }

    public function setOffsetRight(value : Float) : Float {
        _offsetRight = value;
        if(!invalid) 
            invalidate();
        return value;
    }

    var _minRight : Float;
    /**
     * The minimum right location that can be applied
     * to the layout boundaries.
     */    public function getMinRight() : Float {
        return _minRight;
    }

    public function setMinRight(value : Float) : Float {
        _minRight = value;
        if(!invalid) 
            invalidate();
        return value;
    }

    var _maxRight : Float;
    /**
     * The maximum right location that can be applied
     * to the layout boundaries.
     */    public function getMaxRight() : Float {
        return _maxRight;
    }

    public function setMaxRight(value : Float) : Float {
        _maxRight = value;
        if(!invalid) 
            invalidate();
        return value;
    }

    var _bottom : Float;
    /**
     * When set, the bottom of the layout will be located
     * offset from the bottom of it's container by the
     * value of this property.
     */    public function getBottom() : Float {
        return _bottom;
    }

    public function setBottom(value : Float) : Float {
        _bottom = value;
        _percentBottom = Math.NaN;
        if(!invalid) 
            invalidate();
        return value;
    }

    var _percentBottom : Float;
    /**
     * When set, the bottom of the layout will be located
     * offset by the value of this property multiplied
     * by the containing height.
     * A value of 0 represents 0% and 1 represents 100%.
     */    public function getPercentBottom() : Float {
        return _percentBottom;
    }

    public function setPercentBottom(value : Float) : Float {
        _percentBottom = value;
        if(!invalid) 
            invalidate();
        return value;
    }

    var _offsetBottom : Float;
    /**
     * Add additional offset to be added to the bottom
     * value after it has been set.
     */    public function getOffsetBottom() : Float {
        return _offsetBottom;
    }

    public function setOffsetBottom(value : Float) : Float {
        _offsetBottom = value;
        if(!invalid) 
            invalidate();
        return value;
    }

    var _minBottom : Float;
    /**
     * The minimum bottom location that can be applied
     * to the layout boundaries.
     */    public function getMinBottom() : Float {
        return _minBottom;
    }

    public function setMinBottom(value : Float) : Float {
        _minBottom = value;
        if(!invalid) 
            invalidate();
        return value;
    }

    var _maxBottom : Float;
    /**
     * The maximum bottom location that can be applied
     * to the layout boundaries.
     */    public function getMaxBottom() : Float {
        return _maxBottom;
    }

    public function setMaxBottom(value : Float) : Float {
        _maxBottom = value;
        if(!invalid) 
            invalidate();
        return value;
    }

    var _left : Float;
    /**
     * When set, the left of the layout will be located
     * offset by the value of this property multiplied
     * by the containing width.
     */    public function getLeft() : Float {
        return _left;
    }

    public function setLeft(value : Float) : Float {
        _left = value;
        _percentLeft = Math.NaN;
        if(!invalid) 
            invalidate();
        return value;
    }

    var _percentLeft : Float;
    /**
     * When set, the left of the layout will be located
     * offset by the value of this property multiplied
     * by the containing width.
     * A value of 0 represents 0% and 1 represents 100%.
     */    public function getPercentLeft() : Float {
        return _percentLeft;
    }

    public function setPercentLeft(value : Float) : Float {
        _percentLeft = value;
        if(!invalid) 
            invalidate();
        return value;
    }

    var _offsetLeft : Float;
    /**
     * Add additional offset to be added to the left
     * value after it has been set.
     */    public function getOffsetLeft() : Float {
        return _offsetLeft;
    }

    public function setOffsetLeft(value : Float) : Float {
        _offsetLeft = value;
        if(!invalid) 
            invalidate();
        return value;
    }

    var _minLeft : Float;
    /**
     * The minimum left location that can be applied
     * to the layout boundaries.
     */    public function getMinLeft() : Float {
        return _minLeft;
    }

    public function setMinLeft(value : Float) : Float {
        _minLeft = value;
        if(!invalid) 
            invalidate();
        return value;
    }

    var _maxLeft : Float;
    /**
     * The maximum left location that can be applied
     * to the layout boundaries.
     */    public function getMaxLeft() : Float {
        return _maxLeft;
    }

    public function setMaxLeft(value : Float) : Float {
        _maxLeft = value;
        if(!invalid) 
            invalidate();
        return value;
    }

    var _x : Float;
    /**
     * Defines the x location (top left) of the layout boundary.
     * Unlike left, x does not affect a layout's width.  Once
     * left (or percentLeft) is set, the x value no longer applies.
     * If percentX exists when x is set, percentX will be
     * overridden and be given a value of NaN.
     * When a Layout is created for a display object, this is
     * defined as the x location of that display object.
     * The value of x itself cannot be NaN.
     */    public function getX() : Float {
        return _x;
    }

    public function setX(value : Float) : Float {
        if(Math.isNaN(value)) 
            return _x;
        _x = value;
        _percentX = Math.NaN;
        _rect.x = _x;
        if(!invalid) 
            invalidate();
        return value;
    }

    var _percentX : Float;
    /**
     * When set, the x location of the layout will be
     * located at the value of this property multiplied
     * by the containing width.
     * A value of 0 represents 0% and 1 represents 100%.
     */    public function getPercentX() : Float {
        return _percentX;
    }

    public function setPercentX(value : Float) : Float {
        _percentX = value;
        if(!invalid) 
            invalidate();
        return value;
    }

    var _minX : Float;
    /**
     * The minimum x location that can be applied
     * to the layout boundaries.
     */    public function getMinX() : Float {
        return _minX;
    }

    public function setMinX(value : Float) : Float {
        _minX = value;
        if(!invalid) 
            invalidate();
        return value;
    }

    var _maxX : Float;
    /**
     * The maximum x location that can be applied
     * to the layout boundaries.
     */    public function getMaxX() : Float {
        return _maxX;
    }

    public function setMaxX(value : Float) : Float {
        _maxX = value;
        if(!invalid) 
            invalidate();
        return value;
    }

    var _y : Float;
    /**
     * Defines the y location (top left) of the layout boundary.
     * Unlike top, y does not affect a layout's height.  Once
     * top (or percentTop) is set, the y value no longer applies.
     * If percentY exists when y is set, percentY will be
     * overridden and be given a value of NaN.
     * When a Layout is created for a display object, this is
     * defined as the y location of that display object.
     * The value of y itself cannot be NaN.
     */    public function getY() : Float {
        return _y;
    }

    public function setY(value : Float) : Float {
        if(Math.isNaN(value)) 
            return _y;
        _y = value;
        _percentY = Math.NaN;
        _rect.y = _y;
        if(!invalid) 
            invalidate();
        return value;
    }

    var _percentY : Float;
    /**
     * When set, the y location of the layout will be
     * located at the value of this property multiplied
     * by the containing height.
     * A value of 0 represents 0% and 1 represents 100%.
     */    public function getPercentY() : Float {
        return _percentY;
    }

    public function setPercentY(value : Float) : Float {
        _percentY = value;
        if(!invalid) 
            invalidate();
        return value;
    }

    var _minY : Float;
    /**
     * The minimum y location that can be applied
     * to the layout boundaries.
     */    public function getMinY() : Float {
        return _minY;
    }

    public function setMinY(value : Float) : Float {
        _minY = value;
        if(!invalid) 
            invalidate();
        return value;
    }

    var _maxY : Float;
    /**
     * The maximum y location that can be applied
     * to the layout boundaries.
     */    public function getMaxY() : Float {
        return _maxY;
    }

    public function setMaxY(value : Float) : Float {
        _maxY = value;
        if(!invalid) 
            invalidate();
        return value;
    }

    var _width : Float;
    /**
     * Defines the width of the layout boundary.
     * Once left (or percentLeft) or right (or percentRight)
     * is set, the width value no longer applies. If
     * percentWidth exists when width is set, percentWidth
     * will be overridden and be given a value of NaN.
     * When a Layout is created for a display object, this is
     * defined as the width of that display object.
     * The value of width itself cannot be NaN.
     */    public function getWidth() : Float {
        return _width;
    }

    public function setWidth(value : Float) : Float {
        if(Math.isNaN(value)) 
            return _width;
        _width = value;
        _rect.width = _width;
        _percentWidth = Math.NaN;
        if(!invalid) 
            invalidate();
        return value;
    }

    var _percentWidth : Float;
    /**
     * When set, the width of the layout will be
     * set as the value of this property multiplied
     * by the containing width.
     * A value of 0 represents 0% and 1 represents 100%.
     */    public function getPercentWidth() : Float {
        return _percentWidth;
    }

    public function setPercentWidth(value : Float) : Float {
        _percentWidth = value;
        if(!invalid) 
            invalidate();
        return value;
    }

    var _minWidth : Float;
    /**
     * The minimum width that can be applied
     * to the layout boundaries.
     */    public function getMinWidth() : Float {
        return _minWidth;
    }

    public function setMinWidth(value : Float) : Float {
        _minWidth = value;
        if(!invalid) 
            invalidate();
        return value;
    }

    var _maxWidth : Float;
    /**
     * The maximum width that can be applied
     * to the layout boundaries.
     */    public function getMaxWidth() : Float {
        return _maxWidth;
    }

    public function setMaxWidth(value : Float) : Float {
        _maxWidth = value;
        if(!invalid) 
            invalidate();
        return value;
    }

    var _height : Float;
    /**
     * Defines the height of the layout boundary.
     * Once top (or percentTop) or bottom (or percentBottom)
     * is set, the width value no longer applies. If
     * percentWidth exists when width is set, percentWidth
     * will be overridden and be given a value of NaN.
     * When a Layout is created for a display object, this is
     * defined as the height of that display object.
     * The value of height itself cannot be NaN.
     */    public function getHeight() : Float {
        return _height;
    }

    public function setHeight(value : Float) : Float {
        if(Math.isNaN(value)) 
            return _height;
        _height = value;
        _rect.height = _height;
        _percentHeight = Math.NaN;
        if(!invalid) 
            invalidate();
        return value;
    }

    var _percentHeight : Float;
    /**
     * When set, the height of the layout will be
     * set as the value of this property multiplied
     * by the containing height.
     * A value of 0 represents 0% and 1 represents 100%.
     */    public function getPercentHeight() : Float {
        return _percentHeight;
    }

    public function setPercentHeight(value : Float) : Float {
        _percentHeight = value;
        if(!invalid) 
            invalidate();
        return value;
    }

    var _minHeight : Float;
    /**
     * The minimum height that can be applied
     * to the layout boundaries.
     */    public function getMinHeight() : Float {
        return _minHeight;
    }

    public function setMinHeight(value : Float) : Float {
        _minHeight = value;
        if(!invalid) 
            invalidate();
        return value;
    }

    var _maxHeight : Float;
    /**
     * The maximum height that can be applied
     * to the layout boundaries.
     */    public function getMaxHeight() : Float {
        return _maxHeight;
    }

    public function setMaxHeight(value : Float) : Float {
        _maxHeight = value;
        if(!invalid) 
            invalidate();
        return value;
    }

    var _maintainAspectRatio : Bool;
    /**
     * When true, the size of the layout will always
     * maintain an aspect ratio relative to the ratio
     * of the current width and height properties, even
     * if those properties are not in control of the
     * height and width of the layout.
     */    public function getMaintainAspectRatio() : Bool {
        return _maintainAspectRatio;
    }

    public function setMaintainAspectRatio(value : Bool) : Bool {
        _maintainAspectRatio = value;
        if(!invalid) 
            invalidate();
        return value;
    }

    var _maintainAspectRatioPolicy : String;
    /**
     * Determines how aspect ratio is maintained when
     * maintainAspectRatio is true.
     */    public function getMaintainAspectRatioPolicy() : String {
        return _maintainAspectRatioPolicy;
    }

    public function setMaintainAspectRatioPolicy(value : String) : String {
        _maintainAspectRatioPolicy = value;
        if(!invalid) 
            invalidate();
        return value;
    }

    /**
     * @private
     */    var _rect : Rectangle;
    /** 
     * The rectangle that defines the boundaries of the
     * layout instance.  This rectangle should be used
     * to assertain the layout's position and size over
     * using the x, y, height, and width properties as
     * it accounts for min/max settings and other limits.
     * This rectangle may not be up to date if referenced
     * prior to the layout being properly updated with draw().
     */    public function getRect() : Rectangle {
        return _rect.clone();
    }

    /**
     * @private
     */    var owner : Layout;
    /**
     * @private
     */    var invalid : Bool;
    /**
     * Creates a new LayoutConstraint instance. LayoutConstraint
     * instances are used by layouts and layout children to define
     * how a target or other layouts are constrained within a
     * containing layout.
     * @param initRect An initializing rectangle to define the 
     *         position and size (rect) of the new constraint.
     */    
    public function new(initRect : Rectangle = null) {
        _offsetTop = 0;
        _offsetRight = 0;
        _offsetBottom = 0;
        _offsetLeft = 0;
        _x = 0;
        _y = 0;
        _width = 100;
        _height = 100;
        _maintainAspectRatioPolicy = "favorSmallest";
        _rect = new Rectangle();
        invalid = false;
        // define rect if provided
        if(initRect != null)  {
            _rect = initRect.clone();
            _x = _rect.x;
            _y = _rect.y;
            _width = _rect.width;
            _height = _rect.height;
        }
        super();
    }

    /**
     * Creates a new copy of the current LayoutConstraint instance.
     */    public function clone() : LayoutConstraint {
        var constraint : LayoutConstraint = new LayoutConstraint();
        constraint.match(this);
        constraint._rect = _rect.clone();
        return constraint;
    }

    /**
     * Utility function for initializing constraint properties from
     * a generic object instance.
     * @param    initObject An object Object with key-value combinations
     * that relate to the constraint values to be copied into this 
     * LayoutConstraint instance.
     */    
    public function init(initObject : Dynamic) : Void {
        // TODO
        /*for(p in initObject) {
            try {
                this[p] = Reflect.field(initObject, p);
            }
            catch(error : Dynamic) {
            }

        }*/

    }

    /**
     * Sets all the constraint properties of the current constraint
     * to match the properties of the constraint passed.
     * @param constraint The LayoutConstraint instance to have
     *         the current instance match.
     */    public function match(constraint : LayoutConstraint) : Void {
        if(constraint == null) 
            return;
        _x = constraint._x;
        _percentX = constraint._percentX;
        _minX = constraint._minX;
        _maxX = constraint._maxX;
        _y = constraint._y;
        _percentY = constraint._percentY;
        _minY = constraint._minY;
        _maxY = constraint._maxY;
        _width = constraint._width;
        _percentWidth = constraint._percentWidth;
        _minWidth = constraint._minWidth;
        _maxWidth = constraint._maxWidth;
        _height = constraint._height;
        _percentHeight = constraint._percentHeight;
        _minHeight = constraint._minHeight;
        _maxHeight = constraint._maxHeight;
        _top = constraint._top;
        _percentTop = constraint._percentTop;
        _minTop = constraint._minTop;
        _maxTop = constraint._maxTop;
        _offsetTop = constraint._offsetTop;
        _right = constraint._right;
        _percentRight = constraint._percentRight;
        _minRight = constraint._minRight;
        _maxRight = constraint._maxRight;
        _offsetRight = constraint._offsetRight;
        _bottom = constraint._bottom;
        _percentBottom = constraint._percentBottom;
        _minBottom = constraint._minBottom;
        _maxBottom = constraint._maxBottom;
        _offsetBottom = constraint._offsetBottom;
        _left = constraint._left;
        _percentLeft = constraint._percentLeft;
        _minLeft = constraint._minLeft;
        _maxLeft = constraint._maxLeft;
        _offsetLeft = constraint._offsetLeft;
        _horizontalCenter = constraint._horizontalCenter;
        _percentHorizontalCenter = constraint._percentHorizontalCenter;
        _minHorizontalCenter = constraint._minHorizontalCenter;
        _maxHorizontalCenter = constraint._maxHorizontalCenter;
        _verticalCenter = constraint._verticalCenter;
        _percentVerticalCenter = constraint._percentVerticalCenter;
        _minVerticalCenter = constraint._minVerticalCenter;
        _maxVerticalCenter = constraint._maxVerticalCenter;
        _maintainAspectRatio = constraint._maintainAspectRatio;
        _maintainAspectRatioPolicy = constraint._maintainAspectRatioPolicy;
        invalidate();
    }

    /**
     * Applies the constraints to the given rectangle updating
     * the rect property of this instance. This used when drawn
     * to update a layout within the bounds of its parent layout.
     * @param container The containing rectangle in which
     *         to fit the constraint.
     */    public function setIn(container : Rectangle) : Void {
        // reusable value
        var currValue : Float;
        // horizontal
        // place
        var noLeft : Bool = Math.isNaN(_left);
        var noPercentLeft : Bool = Math.isNaN(_percentLeft);
        var noRight : Bool = Math.isNaN(_right);
        var noPercentRight : Bool = Math.isNaN(_percentRight);
        var noHorizontalCenter : Bool = Math.isNaN(_horizontalCenter);
        var noPercentHorizontalCenter : Bool = Math.isNaN(_percentHorizontalCenter);
        var alignedLeft : Bool = !cast(noLeft && noPercentLeft, Bool);
        var alignedRight : Bool = !cast(noRight && noPercentRight, Bool);
        if(container != null)  {
            if(!alignedLeft && !alignedRight)  {
                if(noHorizontalCenter && noPercentHorizontalCenter)  {
                    // normal
                    _rect.width = (Math.isNaN(_percentWidth)) ? _width : _percentWidth * container.width;
                    _rect.x = (Math.isNaN(_percentX)) ? _x + container.left : _percentX * container.width;
                }

                else  {
                    // centered
                    _rect.width = (Math.isNaN(_percentWidth)) ? _width : _percentWidth * container.width;
                    if(noPercentHorizontalCenter)  {
                        _rect.x = _horizontalCenter - _rect.width / 2 + container.left + container.width / 2;
                    }

                    else  {
                        // center with limits
                        currValue = _percentHorizontalCenter * container.width;
                        if(!Math.isNaN(_minHorizontalCenter) && _minHorizontalCenter > currValue)  {
                            currValue = _minHorizontalCenter;
                        }

                        else if(!Math.isNaN(_maxHorizontalCenter) && _maxHorizontalCenter < currValue)  {
                            currValue = _maxHorizontalCenter;
                        }
                        _rect.x = currValue - _rect.width / 2 + container.left;
                    }

                }

            }

            else if(!alignedRight)  {
                // left
                _rect.width = (Math.isNaN(_percentWidth)) ? _width : _percentWidth * container.width;
                _rect.x = (noPercentLeft) ? container.left + _left : container.left + _percentLeft * container.width;
            }

            else if(!alignedLeft)  {
                // right
                _rect.width = (Math.isNaN(_percentWidth)) ? _width : _percentWidth * container.width;
                _rect.x = (noPercentRight) ? container.right - _right - _rect.width : container.right - _percentRight * container.width - _rect.width;
            }

            else  {
                // right and left (boxed)
                _rect.right = (noPercentRight) ? container.right - _right : container.right - _percentRight * container.width;
                _rect.left = (noPercentLeft) ? container.left + _left : container.left + _percentLeft * container.width;
            }

        }
        // apply offsets
        if(_offsetLeft != 0) 
            _rect.left += _offsetLeft;
        if(_offsetRight != 0) 
            _rect.right -= _offsetRight;
        // apply limits
        if(!Math.isNaN(_minX))  {
            currValue = container.x + _minX;
            if(currValue > _rect.x) 
                _rect.x = currValue;
        }
;
        if(!Math.isNaN(_maxX))  {
            currValue = container.x + _maxX;
            if(currValue < _rect.x) 
                _rect.x = currValue;
        }
        if(!Math.isNaN(_minLeft))  {
            currValue = container.left + _minLeft;
            if(currValue > _rect.left) 
                _rect.left = currValue;
        }
        if(!Math.isNaN(_maxLeft))  {
            currValue = container.left + _maxLeft;
            if(currValue < _rect.left) 
                _rect.left = currValue;
        }
        if(!Math.isNaN(_minRight))  {
            currValue = container.right - _minRight;
            if(currValue < _rect.right) 
                _rect.right = currValue;
        }
        if(!Math.isNaN(_maxRight))  {
            currValue = container.right - _maxRight;
            if(currValue > _rect.right) 
                _rect.right = currValue;
        }
        currValue = 0;
        if(!Math.isNaN(_minWidth) && _minWidth > _rect.width)  {
            currValue = _rect.width - _minWidth;
        }

        else if(!Math.isNaN(_maxWidth) && _maxWidth < _rect.width)  {
            currValue = _rect.width - _maxWidth;
        }
        if(currValue != 0)  {
            // if change in width, adjust position
            if(!alignedLeft)  {
                if(alignedRight)  {
                    // right
                    _rect.x += currValue;
                }

                else if(!(noHorizontalCenter && noPercentHorizontalCenter))  {
                    // centered
                    _rect.x += currValue / 2;
                }
            }

            else if(alignedLeft && alignedRight)  {
                // boxed
                _rect.x += currValue / 2;
            }
;
            // fit width
            _rect.width -= currValue;
        }
        // vertical
        // place
        var noTop : Bool = Math.isNaN(_top);
        var noPercentTop : Bool = Math.isNaN(_percentTop);
        var noBottom : Bool = Math.isNaN(_bottom);
        var noPercentBottom : Bool = Math.isNaN(_percentBottom);
        var noVerticalCenter : Bool = Math.isNaN(_verticalCenter);
        var noPercentVerticalCenter : Bool = Math.isNaN(_percentVerticalCenter);
        var alignedTop : Bool = !cast(noTop && noPercentTop, Bool);
        var alignedBottom : Bool = !cast(noBottom && noPercentBottom, Bool);
        if(container != null)  {
            if(!alignedTop && !alignedBottom)  {
                if(noVerticalCenter && noPercentVerticalCenter)  {
                    // normal
                    _rect.height = (Math.isNaN(_percentHeight)) ? _height : _percentHeight * container.height;
                    _rect.y = (Math.isNaN(_percentY)) ? _y + container.top : _percentY * container.height;
                }

                else  {
                    // centered
                    _rect.height = (Math.isNaN(_percentHeight)) ? _height : _percentHeight * container.height;
                    if(noPercentVerticalCenter)  {
                        _rect.y = _verticalCenter - _rect.height / 2 + container.top + container.height / 2;
                    }

                    else  {
                        // center with limits
                        currValue = _percentVerticalCenter * container.height;
                        if(!Math.isNaN(_minVerticalCenter) && _minVerticalCenter > currValue)  {
                            currValue = _minVerticalCenter;
                        }

                        else if(!Math.isNaN(_maxVerticalCenter) && _maxVerticalCenter < currValue)  {
                            currValue = _maxVerticalCenter;
                        }
                        _rect.y = currValue - _rect.height / 2 + container.top;
                    }

                }

            }

            else if(!alignedBottom)  {
                // top
                _rect.height = (Math.isNaN(_percentHeight)) ? _height : _percentHeight * container.height;
                _rect.y = (noPercentTop) ? container.top + _top : container.top + _percentTop * container.height;
            }

            else if(!alignedTop)  {
                // bottom
                _rect.height = (Math.isNaN(_percentHeight)) ? _height : _percentHeight * container.height;
                _rect.y = (noPercentBottom) ? container.bottom - _bottom - _rect.height : container.bottom - _percentBottom * container.height - _rect.height;
            }

            else  {
                // top and bottom (boxed)
                _rect.bottom = (noPercentBottom) ? container.bottom - _bottom : container.bottom - _percentBottom * container.height;
                _rect.top = (noPercentTop) ? container.top + _top : container.top + _percentTop * container.height;
            }

        }
        // apply offsets
        if(_offsetTop != 0) 
            _rect.top += _offsetTop;
        if(_offsetBottom != 0) 
            _rect.bottom -= _offsetBottom;
        // apply limits
        if(!Math.isNaN(_minY))  {
            currValue = container.y + _minY;
            if(currValue > _rect.y) 
                _rect.y = currValue;
        }
;
        if(!Math.isNaN(_maxY))  {
            currValue = container.y + _maxY;
            if(currValue < _rect.y) 
                _rect.y = currValue;
        }
        if(!Math.isNaN(_minTop))  {
            currValue = container.top + _minTop;
            if(currValue > _rect.top) 
                _rect.top = currValue;
        }
        if(!Math.isNaN(_maxTop))  {
            currValue = container.top + _maxTop;
            if(currValue < _rect.top) 
                _rect.top = currValue;
        }
        if(!Math.isNaN(_minBottom))  {
            currValue = container.bottom - _minBottom;
            if(currValue < _rect.bottom) 
                _rect.bottom = currValue;
        }
        if(!Math.isNaN(_maxBottom))  {
            currValue = container.bottom - _maxBottom;
            if(currValue > _rect.bottom) 
                _rect.bottom = currValue;
        }
        currValue = 0;
        if(!Math.isNaN(_minHeight) && _minHeight > _rect.height)  {
            currValue = _rect.height - _minHeight;
        }

        else if(!Math.isNaN(_maxHeight) && _maxHeight < _rect.height)  {
            currValue = _rect.height - _maxHeight;
        }
        if(currValue != 0)  {
            // if change in height, adjust position
            if(!alignedTop)  {
                if(alignedBottom)  {
                    // bottom
                    _rect.y += currValue;
                }

                else if(!(noVerticalCenter && noPercentVerticalCenter))  {
                    // centered
                    _rect.y += currValue / 2;
                }
            }

            else if(alignedTop && alignedBottom)  {
                // boxed
                _rect.y += currValue / 2;
            }
;
            // fit height
            _rect.height -= currValue;
        }
        // maintaining aspect if applicable; use width and height for aspect
        // only apply if one dimension is static and the other dynamic
        // matintainAspectRatioPolicy determines which dimension is
        // used as the base of the ratio
        // maintaining aspect has highest priority so it is evaluated last
        if(_maintainAspectRatio && _height != 0 && _width != 0)  {
            var sizeRatio : Float = _height / _width;
            var rectRatio : Float = _rect.height / _rect.width;
            var favorWidth : Bool=false;
            var favorHeight : Bool=false;
            switch(_maintainAspectRatioPolicy) {
            case FAVOR_WIDTH:
                favorWidth = true;
            case FAVOR_HEIGHT:
                favorHeight = true;
            case FAVOR_LARGEST:
                favorWidth = cast(sizeRatio > rectRatio, Bool);
                favorHeight = cast(sizeRatio < rectRatio, Bool);
            case FAVOR_SMALLEST:
                favorWidth = cast(sizeRatio < rectRatio, Bool);
                favorHeight = cast(sizeRatio > rectRatio, Bool);
            default:
                favorWidth = cast(sizeRatio < rectRatio, Bool);
                favorHeight = cast(sizeRatio > rectRatio, Bool);
            }
            if(favorHeight)  {
                // change width
                currValue = _rect.height / sizeRatio;
                if(!alignedLeft)  {
                    if(alignedRight)  {
                        // right
                        _rect.x += _rect.width - currValue;
                    }

                    else if(!(noHorizontalCenter && noPercentHorizontalCenter))  {
                        // centered
                        _rect.x += (_rect.width - currValue) / 2;
                    }
                }

                else if(alignedLeft && alignedRight)  {
                    // boxed
                    _rect.x += (_rect.width - currValue) / 2;
                }
                _rect.width = currValue;
            }

            else if(favorWidth)  {
                // change height
                currValue = _rect.width * sizeRatio;
                if(!alignedTop)  {
                    if(alignedBottom)  {
                        // bottom
                        _rect.y += _rect.height - currValue;
                    }

                    else if(!(noVerticalCenter && noPercentVerticalCenter))  {
                        // centered
                        _rect.y += (_rect.height - currValue) / 2;
                    }
                }

                else if(alignedTop && alignedBottom)  {
                    // boxed
                    _rect.y += (_rect.height - currValue) / 2;
                }
                _rect.height = currValue;
            }
        }
;
    }

    /**
     * Invalidates this instance and its owner
     * @private
     */    
    public function invalidate() : Void {
        if(owner != null && this != owner) 
            owner.invalidate();
        invalid = true;
    }

}

