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

import flash.display.InteractiveObject;
import flash.display.MovieClip;
import flash.geom.Matrix;
import flash.geom.Point;

class TransformToolControl extends MovieClip {
    public var transformTool(getTransformTool, setTransformTool) : TransformTool;
    public var relatedObject(getRelatedObject, setRelatedObject) : InteractiveObject;
    public var referencePoint(getReferencePoint, setReferencePoint) : Point;

    // Variables
        var _transformTool : TransformTool;
    var _referencePoint : Point;
    var _relatedObject : InteractiveObject;
    // Properties
        /**

     * Reference to TransformTool instance using the control

     * This property is defined after using TransformTool.addControl

     * prior to being added to the TransformTool display list

     * (it can be accessed after the TransformTool.CONTROL_INIT event)

     */    public function getTransformTool() : TransformTool {
        return _transformTool;
    }

    public function setTransformTool(t : TransformTool) : TransformTool {
        _transformTool = t;
        return t;
    }

    /**

     * The object "related" to this control and can be referenced

     * if the control needs association with another object.  This is

     * used with the default move control to relate itself with the

     * tool target (cursors also check for this)

     */    public function getRelatedObject() : InteractiveObject {
        return _relatedObject;
    }

    public function setRelatedObject(i : InteractiveObject) : InteractiveObject {
        _relatedObject = (i!=null) ? i : this;
        return i;
    }

    /**

     * A point of reference that can be used to handle transformations

     * A TransformTool instance will use this property for offsetting the

     * location of the mouse to match the desired start location of the transform

     */    public function getReferencePoint() : Point {
        return _referencePoint;
    }

    public function setReferencePoint(p : Point) : Point {
        _referencePoint = p;
        return p;
    }

    /**

     * Constructor

     */    public function new() {
        _relatedObject = this;
        super();
    }

    /**

     * Optionally used with transformTool.maintainHandleForm to 

     * counter transformations applied to a control by its parents

     */    public function counterTransform() : Void {
        transform.matrix = new Matrix();
        var concatMatrix : Matrix = transform.concatenatedMatrix;
        concatMatrix.invert();
        transform.matrix = concatMatrix;
    }

}

