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
import flash.display.Shape;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.EventPhase;
import flash.events.MouseEvent;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.geom.Transform;
//import flash.utils.Dictionary;
import nme.ObjectHash;
import flash.display.DisplayObject;
import flash.display.InteractiveObject;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Matrix;
import flash.geom.Point;

// TODO: Documentation
// TODO: Handle 0-size transformations
/**

 * Creates a transform tool that allows uaers to modify display objects on the screen

 * 

 * @usage

 * <pre>

 * var tool:TransformTool = new TransformTool();

 * addChild(tool);

 * tool.target = targetDisplayObject;

 * </pre>

 * 

 * @version 0.9.11

 * @author  Trevor McCauley

 * @author  http://www.senocular.com

 */class TransformTool extends Sprite {
    public var target(getTarget, setTarget) : DisplayObject;
    public var raiseNewTargets(getRaiseNewTargets, setRaiseNewTargets) : Bool;
    public var moveNewTargets(getMoveNewTargets, setMoveNewTargets) : Bool;
    public var livePreview(getLivePreview, setLivePreview) : Bool;
    public var controlSize(getControlSize, setControlSize) : Float;
    public var maintainControlForm(getMaintainControlForm, setMaintainControlForm) : Bool;
    public var moveUnderObjects(getMoveUnderObjects, setMoveUnderObjects) : Bool;
    public var toolMatrix(getToolMatrix, setToolMatrix) : Matrix;
    public var globalMatrix(getGlobalMatrix, setGlobalMatrix) : Matrix;
    public var registration(getRegistration, setRegistration) : Point;
    public var currentControl(getCurrentControl, never) : TransformToolControl;
    public var moveEnabled(getMoveEnabled, setMoveEnabled) : Bool;
    public var registrationEnabled(getRegistrationEnabled, setRegistrationEnabled) : Bool;
    public var rotationEnabled(getRotationEnabled, setRotationEnabled) : Bool;
    public var scaleEnabled(getScaleEnabled, setScaleEnabled) : Bool;
    public var skewEnabled(getSkewEnabled, setSkewEnabled) : Bool;
    public var outlineEnabled(getOutlineEnabled, setOutlineEnabled) : Bool;
    public var cursorsEnabled(getCursorsEnabled, setCursorsEnabled) : Bool;
    public var customControlsEnabled(getCustomControlsEnabled, setCustomControlsEnabled) : Bool;
    public var customCursorsEnabled(getCustomCursorsEnabled, setCustomCursorsEnabled) : Bool;
    public var rememberRegistration(getRememberRegistration, setRememberRegistration) : Bool;
    public var constrainScale(getConstrainScale, setConstrainScale) : Bool;
    public var constrainRotation(getConstrainRotation, setConstrainRotation) : Bool;
    public var constrainRotationAngle(getConstrainRotationAngle, setConstrainRotationAngle) : Float;
    public var maxScaleX(getMaxScaleX, setMaxScaleX) : Float;
    public var maxScaleY(getMaxScaleY, setMaxScaleY) : Float;
    public var boundsTopLeft(getBoundsTopLeft, never) : Point;
    public var boundsTop(getBoundsTop, never) : Point;
    public var boundsTopRight(getBoundsTopRight, never) : Point;
    public var boundsRight(getBoundsRight, never) : Point;
    public var boundsBottomRight(getBoundsBottomRight, never) : Point;
    public var boundsBottom(getBoundsBottom, never) : Point;
    public var boundsBottomLeft(getBoundsBottomLeft, never) : Point;
    public var boundsLeft(getBoundsLeft, never) : Point;
    public var boundsCenter(getBoundsCenter, never) : Point;
    public var mouse(getMouse, never) : Point;
    public var moveControl(getMoveControl, never) : TransformToolControl;
    public var registrationControl(getRegistrationControl, never) : TransformToolControl;
    public var outlineControl(getOutlineControl, never) : TransformToolControl;
    public var scaleTopLeftControl(getScaleTopLeftControl, never) : TransformToolControl;
    public var scaleTopControl(getScaleTopControl, never) : TransformToolControl;
    public var scaleTopRightControl(getScaleTopRightControl, never) : TransformToolControl;
    public var scaleRightControl(getScaleRightControl, never) : TransformToolControl;
    public var scaleBottomRightControl(getScaleBottomRightControl, never) : TransformToolControl;
    public var scaleBottomControl(getScaleBottomControl, never) : TransformToolControl;
    public var scaleBottomLeftControl(getScaleBottomLeftControl, never) : TransformToolControl;
    public var scaleLeftControl(getScaleLeftControl, never) : TransformToolControl;
    public var rotationTopLeftControl(getRotationTopLeftControl, never) : TransformToolControl;
    public var rotationTopRightControl(getRotationTopRightControl, never) : TransformToolControl;
    public var rotationBottomRightControl(getRotationBottomRightControl, never) : TransformToolControl;
    public var rotationBottomLeftControl(getRotationBottomLeftControl, never) : TransformToolControl;
    public var skewTopControl(getSkewTopControl, never) : TransformToolControl;
    public var skewRightControl(getSkewRightControl, never) : TransformToolControl;
    public var skewBottomControl(getSkewBottomControl, never) : TransformToolControl;
    public var skewLeftControl(getSkewLeftControl, never) : TransformToolControl;
    public var moveCursor(getMoveCursor, never) : TransformToolCursor;
    public var registrationCursor(getRegistrationCursor, never) : TransformToolCursor;
    public var rotationCursor(getRotationCursor, never) : TransformToolCursor;
    public var scaleCursor(getScaleCursor, never) : TransformToolCursor;
    public var skewCursor(getSkewCursor, never) : TransformToolCursor;

    // Variables
        var toolInvertedMatrix : Matrix;
    var innerRegistration : Point;
    var registrationLog : ObjectHash<Dynamic,Dynamic>;
    var targetBounds : Rectangle;
    var mouseLoc : Point;
    var mouseOffset : Point;
    var innerMouseLoc : Point;
    var interactionStart : Point;
    var innerInteractionStart : Point;
    var interactionStartAngle : Float;
    var interactionStartMatrix : Matrix;
    var toolSprites : Sprite;
    var lines : Sprite;
    var moveControls : Sprite;
    var registrationControls : Sprite;
    var rotateControls : Sprite;
    var scaleControls : Sprite;
    var skewControls : Sprite;
    var cursors : Sprite;
    var customControls : Sprite;
    var customCursors : Sprite;
    // With getter/setters
        var _target : DisplayObject;
    var _toolMatrix : Matrix;
    var _globalMatrix : Matrix;
    var _registration : Point;
    var _livePreview : Bool;
    var _raiseNewTargets : Bool;
    var _moveNewTargets : Bool;
    var _moveEnabled : Bool;
    var _registrationEnabled : Bool;
    var _rotationEnabled : Bool;
    var _scaleEnabled : Bool;
    var _skewEnabled : Bool;
    var _outlineEnabled : Bool;
    var _customControlsEnabled : Bool;
    var _customCursorsEnabled : Bool;
    var _cursorsEnabled : Bool;
    var _rememberRegistration : Bool;
    var _constrainScale : Bool;
    var _constrainRotationAngle : Float;
    // default at 45 degrees
        var _constrainRotation : Bool;
    var _moveUnderObjects : Bool;
    var _maintainControlForm : Bool;
    var _controlSize : Float;
    var _maxScaleX : Float;
    var _maxScaleY : Float;
    var _boundsTopLeft : Point;
    var _boundsTop : Point;
    var _boundsTopRight : Point;
    var _boundsRight : Point;
    var _boundsBottomRight : Point;
    var _boundsBottom : Point;
    var _boundsBottomLeft : Point;
    var _boundsLeft : Point;
    var _boundsCenter : Point;
    var _currentControl : TransformToolControl;
    var _moveControl : TransformToolControl;
    var _registrationControl : TransformToolControl;
    var _outlineControl : TransformToolControl;
    var _scaleTopLeftControl : TransformToolControl;
    var _scaleTopControl : TransformToolControl;
    var _scaleTopRightControl : TransformToolControl;
    var _scaleRightControl : TransformToolControl;
    var _scaleBottomRightControl : TransformToolControl;
    var _scaleBottomControl : TransformToolControl;
    var _scaleBottomLeftControl : TransformToolControl;
    var _scaleLeftControl : TransformToolControl;
    var _rotationTopLeftControl : TransformToolControl;
    var _rotationTopRightControl : TransformToolControl;
    var _rotationBottomRightControl : TransformToolControl;
    var _rotationBottomLeftControl : TransformToolControl;
    var _skewTopControl : TransformToolControl;
    var _skewRightControl : TransformToolControl;
    var _skewBottomControl : TransformToolControl;
    var _skewLeftControl : TransformToolControl;
    var _moveCursor : TransformToolCursor;
    var _registrationCursor : TransformToolCursor;
    var _rotationCursor : TransformToolCursor;
    var _scaleCursor : TransformToolCursor;
    var _skewCursor : TransformToolCursor;
    // Event constants
        static public inline var NEW_TARGET : String = "newTarget";
    static public inline var TRANSFORM_TARGET : String = "transformTarget";
    static public inline var TRANSFORM_TOOL : String = "transformTool";
    static public inline var CONTROL_INIT : String = "controlInit";
    static public inline var CONTROL_TRANSFORM_TOOL : String = "controlTransformTool";
    static public inline var CONTROL_DOWN : String = "controlDown";
    static public inline var CONTROL_MOVE : String = "controlMove";
    static public inline var CONTROL_UP : String = "controlUp";
    static public inline var CONTROL_PREFERENCE : String = "controlPreference";
    // Skin constants
        static public inline var REGISTRATION : String = "registration";
    static public inline var SCALE_TOP_LEFT : String = "scaleTopLeft";
    static public inline var SCALE_TOP : String = "scaleTop";
    static public inline var SCALE_TOP_RIGHT : String = "scaleTopRight";
    static public inline var SCALE_RIGHT : String = "scaleRight";
    static public inline var SCALE_BOTTOM_RIGHT : String = "scaleBottomRight";
    static public inline var SCALE_BOTTOM : String = "scaleBottom";
    static public inline var SCALE_BOTTOM_LEFT : String = "scaleBottomLeft";
    static public inline var SCALE_LEFT : String = "scaleLeft";
    static public inline var ROTATION_TOP_LEFT : String = "rotationTopLeft";
    static public inline var ROTATION_TOP_RIGHT : String = "rotationTopRight";
    static public inline var ROTATION_BOTTOM_RIGHT : String = "rotationBottomRight";
    static public inline var ROTATION_BOTTOM_LEFT : String = "rotationBottomLeft";
    static public inline var SKEW_TOP : String = "skewTop";
    static public inline var SKEW_RIGHT : String = "skewRight";
    static public inline var SKEW_BOTTOM : String = "skewBottom";
    static public inline var SKEW_LEFT : String = "skewLeft";
    static public inline var CURSOR_REGISTRATION : String = "cursorRegistration";
    static public inline var CURSOR_MOVE : String = "cursorMove";
    static public inline var CURSOR_SCALE : String = "cursorScale";
    static public inline var CURSOR_ROTATION : String = "cursorRotate";
    static public inline var CURSOR_SKEW : String = "cursorSkew";
    // Properties
        /**

     * The display object the transform tool affects

     */    public function getTarget() : DisplayObject {
        return _target;
    }

    public function setTarget(d : DisplayObject) : DisplayObject {
        // null target, set target as null
        if(d == null)  {
            if(_target != null)  {
                _target = null;
                updateControlsVisible();
                dispatchEvent(new Event(NEW_TARGET));
            }
            return null;
        }

        else  {
            // invalid target, do nothing
            if(d == _target || d == this || contains(d) || (Std.is(d, DisplayObjectContainer) && cast(d, DisplayObjectContainer).contains(this)))  {
                return null;
            }
            // valid target, set and update
            _target = d;
            updateMatrix();
            setNewRegistation();
            updateControlsVisible();
            // raise to top of display list if applies
            if(_raiseNewTargets)  {
                raiseTarget();
            }
;
        }
;
        // if not moving new targets, apply transforms
        if(!_moveNewTargets)  {
            apply();
        }
;
        // send event; updates control points
        dispatchEvent(new Event(NEW_TARGET));
        // initiate move interaction if applies after controls updated
        if(_moveNewTargets && _moveEnabled && _moveControl != null)  {
            _currentControl = _moveControl;
            _currentControl.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
        }
;
        return d;
    }

    /**

     * When true, new targets are placed at the top of their display list

     * @see target

     */    public function getRaiseNewTargets() : Bool {
        return _raiseNewTargets;
    }

    public function setRaiseNewTargets(b : Bool) : Bool {
        _raiseNewTargets = b;
        return b;
    }

    /**

     * When true, new targets are immediately given a move interaction and can be dragged

     * @see target

     * @see moveEnabled

     */    public function getMoveNewTargets() : Bool {
        return _moveNewTargets;
    }

    public function setMoveNewTargets(b : Bool) : Bool {
        _moveNewTargets = b;
        return b;
    }

    /**

     * When true, the target instance scales with the tool as it is transformed.

     * When false, transforms in the tool are only reflected when transforms are completed.

     */    public function getLivePreview() : Bool {
        return _livePreview;
    }

    public function setLivePreview(b : Bool) : Bool {
        _livePreview = b;
        return b;
    }

    /**

     * Controls the default Control sizes of controls used by the tool

     */    public function getControlSize() : Float {
        return _controlSize;
    }

    public function setControlSize(n : Float) : Float {
        if(_controlSize != n)  {
            _controlSize = n;
            dispatchEvent(new Event(CONTROL_PREFERENCE));
        }
        return n;
    }

    /**

     * When true, counters transformations applied to controls by their parent containers

     */    public function getMaintainControlForm() : Bool {
        return _maintainControlForm;
    }

    public function setMaintainControlForm(b : Bool) : Bool {
        if(_maintainControlForm != b)  {
            _maintainControlForm = b;
            dispatchEvent(new Event(CONTROL_PREFERENCE));
        }
        return b;
    }

    /**

     * When true (default), the transform tool uses an invisible control using the shape of the current

     * target to allow movement. This means any objects above the target but below the

     * tool cannot be clicked on since this hidden control will be clicked on first

     * (allowing you to move objects below others without selecting the objects on top).

     * When false, the target itself is used for movement and any objects above the target

     * become clickable preventing tool movement if the target itself is not clicked directly.

     */    public function getMoveUnderObjects() : Bool {
        return _moveUnderObjects;
    }

    public function setMoveUnderObjects(b : Bool) : Bool {
        if(_moveUnderObjects != b)  {
            _moveUnderObjects = b;
            dispatchEvent(new Event(CONTROL_PREFERENCE));
        }
        return b;
    }

    /**

     * The transform matrix of the tool

     * as it exists in its on coordinate space

     * @see globalMatrix

     */    public function getToolMatrix() : Matrix {
        return _toolMatrix.clone();
    }

    public function setToolMatrix(m : Matrix) : Matrix {
        updateMatrix(m, false);
        updateRegistration();
        dispatchEvent(new Event(TRANSFORM_TOOL));
        return m;
    }

    /**

     * The transform matrix of the tool

     * as it appears in global space

     * @see toolMatrix

     */    public function getGlobalMatrix() : Matrix {
        var _globalMatrix : Matrix = _toolMatrix.clone();
        _globalMatrix.concat(transform.concatenatedMatrix);
        return _globalMatrix;
    }

    public function setGlobalMatrix(m : Matrix) : Matrix {
        updateMatrix(m);
        updateRegistration();
        dispatchEvent(new Event(TRANSFORM_TOOL));
        return m;
    }

    /**

     * The location of the registration point in the tool. Note: registration

     * points are tool-specific.  If you change the registration point of a

     * target, the new registration will only be reflected in the tool used

     * to change that point.

     * @see registrationEnabled

     * @see rememberRegistration

     */    public function getRegistration() : Point {
        return _registration.clone();
    }

    public function setRegistration(p : Point) : Point {
        _registration = p.clone();
        innerRegistration = toolInvertedMatrix.transformPoint(_registration);
        if(_rememberRegistration)  {
            // log new registration point for the next
            // time this target is selected
            Reflect.setField(registrationLog, Std.string(_target), innerRegistration);
        }
        dispatchEvent(new Event(TRANSFORM_TOOL));
        return p;
    }

    /**

     * The current control being used in the tool if being manipulated.

     * This value is null if the user is not transforming the tool.

     */    public function getCurrentControl() : TransformToolControl {
        return _currentControl;
    }

    /**

     * Allows or disallows users to move the tool

     */    public function getMoveEnabled() : Bool {
        return _moveEnabled;
    }

    public function setMoveEnabled(b : Bool) : Bool {
        if(_moveEnabled != b)  {
            _moveEnabled = b;
            updateControlsEnabled();
        }
        return b;
    }

    /**

     * Allows or disallows users to see and move the registration point

     * @see registration

     * @see rememberRegistration

     */    public function getRegistrationEnabled() : Bool {
        return _registrationEnabled;
    }

    public function setRegistrationEnabled(b : Bool) : Bool {
        if(_registrationEnabled != b)  {
            _registrationEnabled = b;
            updateControlsEnabled();
        }
        return b;
    }

    /**

     * Allows or disallows users to see and adjust rotation controls

     */    public function getRotationEnabled() : Bool {
        return _rotationEnabled;
    }

    public function setRotationEnabled(b : Bool) : Bool {
        if(_rotationEnabled != b)  {
            _rotationEnabled = b;
            updateControlsEnabled();
        }
        return b;
    }

    /**

     * Allows or disallows users to see and adjust scale controls

     */    public function getScaleEnabled() : Bool {
        return _scaleEnabled;
    }

    public function setScaleEnabled(b : Bool) : Bool {
        if(_scaleEnabled != b)  {
            _scaleEnabled = b;
            updateControlsEnabled();
        }
        return b;
    }

    /**

     * Allows or disallows users to see and adjust skew controls

     */    public function getSkewEnabled() : Bool {
        return _skewEnabled;
    }

    public function setSkewEnabled(b : Bool) : Bool {
        if(_skewEnabled != b)  {
            _skewEnabled = b;
            updateControlsEnabled();
        }
        return b;
    }

    /**

     * Allows or disallows users to see tool boundry outlines

     */    public function getOutlineEnabled() : Bool {
        return _outlineEnabled;
    }

    public function setOutlineEnabled(b : Bool) : Bool {
        if(_outlineEnabled != b)  {
            _outlineEnabled = b;
            updateControlsEnabled();
        }
        return b;
    }

    /**

     * Allows or disallows users to see native cursors

     * @see addCursor

     * @see removeCursor

     * @see customCursorsEnabled

     */    public function getCursorsEnabled() : Bool {
        return _cursorsEnabled;
    }

    public function setCursorsEnabled(b : Bool) : Bool {
        if(_cursorsEnabled != b)  {
            _cursorsEnabled = b;
            updateControlsEnabled();
        }
        return b;
    }

    /**

     * Allows or disallows users to see and use custom controls

     * @see addControl

     * @see removeControl

     * @see customCursorsEnabled

     */    public function getCustomControlsEnabled() : Bool {
        return _customControlsEnabled;
    }

    public function setCustomControlsEnabled(b : Bool) : Bool {
        if(_customControlsEnabled != b)  {
            _customControlsEnabled = b;
            updateControlsEnabled();
            dispatchEvent(new Event(CONTROL_PREFERENCE));
        }
        return b;
    }

    /**

     * Allows or disallows users to see custom cursors

     * @see addCursor

     * @see removeCursor

     * @see cursorsEnabled

     * @see customControlsEnabled

     */    public function getCustomCursorsEnabled() : Bool {
        return _customCursorsEnabled;
    }

    public function setCustomCursorsEnabled(b : Bool) : Bool {
        if(_customCursorsEnabled != b)  {
            _customCursorsEnabled = b;
            updateControlsEnabled();
            dispatchEvent(new Event(CONTROL_PREFERENCE));
        }
        return b;
    }

    /**

     * Allows or disallows users to see custom cursors

     * @see registration

     */    public function getRememberRegistration() : Bool {
        return _rememberRegistration;
    }

    public function setRememberRegistration(b : Bool) : Bool {
        _rememberRegistration = b;
        if(!_rememberRegistration)  {
            registrationLog = new ObjectHash();
        }
        return b;
    }

    /**

     * Allows constraining of scale transformations that scale along both X and Y.

     * @see constrainRotation

     */    public function getConstrainScale() : Bool {
        return _constrainScale;
    }

    public function setConstrainScale(b : Bool) : Bool {
        if(_constrainScale != b)  {
            _constrainScale = b;
            dispatchEvent(new Event(CONTROL_PREFERENCE));
        }
        return b;
    }

    /**

     * Allows constraining of rotation transformations by an angle

     * @see constrainRotationAngle

     * @see constrainScale

     */    public function getConstrainRotation() : Bool {
        return _constrainRotation;
    }

    public function setConstrainRotation(b : Bool) : Bool {
        if(_constrainRotation != b)  {
            _constrainRotation = b;
            dispatchEvent(new Event(CONTROL_PREFERENCE));
        }
        return b;
    }

    /**

     * The angle at which rotation is constrainged when constrainRotation is true

     * @see constrainRotation

     */    public function getConstrainRotationAngle() : Float {
        return _constrainRotationAngle * 180 / Math.PI;
    }

    public function setConstrainRotationAngle(n : Float) : Float {
        var angleInRadians : Float = n * Math.PI / 180;
        if(_constrainRotationAngle != angleInRadians)  {
            _constrainRotationAngle = angleInRadians;
            dispatchEvent(new Event(CONTROL_PREFERENCE));
        }
        return n;
    }

    /**

     * The maximum scaleX allowed to be applied to a target

     */    public function getMaxScaleX() : Float {
        return _maxScaleX;
    }

    public function setMaxScaleX(n : Float) : Float {
        _maxScaleX = n;
        return n;
    }

    /**

     * The maximum scaleY allowed to be applied to a target

     */    public function getMaxScaleY() : Float {
        return _maxScaleY;
    }

    public function setMaxScaleY(n : Float) : Float {
        _maxScaleY = n;
        return n;
    }

    public function getBoundsTopLeft() : Point {
        return _boundsTopLeft.clone();
    }

    public function getBoundsTop() : Point {
        return _boundsTop.clone();
    }

    public function getBoundsTopRight() : Point {
        return _boundsTopRight.clone();
    }

    public function getBoundsRight() : Point {
        return _boundsRight.clone();
    }

    public function getBoundsBottomRight() : Point {
        return _boundsBottomRight.clone();
    }

    public function getBoundsBottom() : Point {
        return _boundsBottom.clone();
    }

    public function getBoundsBottomLeft() : Point {
        return _boundsBottomLeft.clone();
    }

    public function getBoundsLeft() : Point {
        return _boundsLeft.clone();
    }

    public function getBoundsCenter() : Point {
        return _boundsCenter.clone();
    }

    public function getMouse() : Point {
        return new Point(mouseX, mouseY);
    }

    public function getMoveControl() : TransformToolControl {
        return _moveControl;
    }

    public function getRegistrationControl() : TransformToolControl {
        return _registrationControl;
    }

    public function getOutlineControl() : TransformToolControl {
        return _outlineControl;
    }

    public function getScaleTopLeftControl() : TransformToolControl {
        return _scaleTopLeftControl;
    }

    public function getScaleTopControl() : TransformToolControl {
        return _scaleTopControl;
    }

    public function getScaleTopRightControl() : TransformToolControl {
        return _scaleTopRightControl;
    }

    public function getScaleRightControl() : TransformToolControl {
        return _scaleRightControl;
    }

    public function getScaleBottomRightControl() : TransformToolControl {
        return _scaleBottomRightControl;
    }

    public function getScaleBottomControl() : TransformToolControl {
        return _scaleBottomControl;
    }

    public function getScaleBottomLeftControl() : TransformToolControl {
        return _scaleBottomLeftControl;
    }

    public function getScaleLeftControl() : TransformToolControl {
        return _scaleLeftControl;
    }

    public function getRotationTopLeftControl() : TransformToolControl {
        return _rotationTopLeftControl;
    }

    public function getRotationTopRightControl() : TransformToolControl {
        return _rotationTopRightControl;
    }

    public function getRotationBottomRightControl() : TransformToolControl {
        return _rotationBottomRightControl;
    }

    public function getRotationBottomLeftControl() : TransformToolControl {
        return _rotationBottomLeftControl;
    }

    public function getSkewTopControl() : TransformToolControl {
        return _skewTopControl;
    }

    public function getSkewRightControl() : TransformToolControl {
        return _skewRightControl;
    }

    public function getSkewBottomControl() : TransformToolControl {
        return _skewBottomControl;
    }

    public function getSkewLeftControl() : TransformToolControl {
        return _skewLeftControl;
    }

    public function getMoveCursor() : TransformToolCursor {
        return _moveCursor;
    }

    public function getRegistrationCursor() : TransformToolCursor {
        return _registrationCursor;
    }

    public function getRotationCursor() : TransformToolCursor {
        return _rotationCursor;
    }

    public function getScaleCursor() : TransformToolCursor {
        return _scaleCursor;
    }

    public function getSkewCursor() : TransformToolCursor {
        return _skewCursor;
    }

    /**

     * TransformTool Constructor.

     * Creates new instances of the transform tool

     */    public function new() {
        toolInvertedMatrix = new Matrix();
        innerRegistration = new Point();
        registrationLog = new ObjectHash();
        targetBounds = new Rectangle();
        mouseLoc = new Point();
        mouseOffset = new Point();
        innerMouseLoc = new Point();
        interactionStart = new Point();
        innerInteractionStart = new Point();
        interactionStartAngle = 0;
        interactionStartMatrix = new Matrix();
        toolSprites = new Sprite();
        lines = new Sprite();
        moveControls = new Sprite();
        registrationControls = new Sprite();
        rotateControls = new Sprite();
        scaleControls = new Sprite();
        skewControls = new Sprite();
        cursors = new Sprite();
        customControls = new Sprite();
        customCursors = new Sprite();
        _toolMatrix = new Matrix();
        _globalMatrix = new Matrix();
        _registration = new Point();
        _livePreview = true;
        _raiseNewTargets = true;
        _moveNewTargets = false;
        _moveEnabled = true;
        _registrationEnabled = true;
        _rotationEnabled = true;
        _scaleEnabled = true;
        _skewEnabled = true;
        _outlineEnabled = true;
        _customControlsEnabled = true;
        _customCursorsEnabled = true;
        _cursorsEnabled = true;
        _rememberRegistration = true;
        _constrainScale = false;
        _constrainRotationAngle = Math.PI / 4;
        _constrainRotation = false;
        _moveUnderObjects = true;
        _maintainControlForm = true;
        _controlSize = 8;
        _maxScaleX = Math.POSITIVE_INFINITY;
        _maxScaleY = Math.POSITIVE_INFINITY;
        _boundsTopLeft = new Point();
        _boundsTop = new Point();
        _boundsTopRight = new Point();
        _boundsRight = new Point();
        _boundsBottomRight = new Point();
        _boundsBottom = new Point();
        _boundsBottomLeft = new Point();
        _boundsLeft = new Point();
        _boundsCenter = new Point();
        createControls();
        super();
    }

    /**

     * Provides a string representation of the transform instance

     */    override public function toString() : String {
        return "[Transform Tool: target=" + Std.string(_target) + "]";
    }

    // Setup
        function createControls() : Void {
        // defining controls
        _moveControl = new TransformToolMoveShape("move", moveInteraction);
        _registrationControl = new TransformToolRegistrationControl(REGISTRATION, registrationInteraction, "registration");
        _rotationTopLeftControl = new TransformToolRotateControl(ROTATION_TOP_LEFT, rotationInteraction, "boundsTopLeft");
        _rotationTopRightControl = new TransformToolRotateControl(ROTATION_TOP_RIGHT, rotationInteraction, "boundsTopRight");
        _rotationBottomRightControl = new TransformToolRotateControl(ROTATION_BOTTOM_RIGHT, rotationInteraction, "boundsBottomRight");
        _rotationBottomLeftControl = new TransformToolRotateControl(ROTATION_BOTTOM_LEFT, rotationInteraction, "boundsBottomLeft");
        _scaleTopLeftControl = new TransformToolScaleControl(SCALE_TOP_LEFT, scaleBothInteraction, "boundsTopLeft");
        _scaleTopControl = new TransformToolScaleControl(SCALE_TOP, scaleYInteraction, "boundsTop");
        _scaleTopRightControl = new TransformToolScaleControl(SCALE_TOP_RIGHT, scaleBothInteraction, "boundsTopRight");
        _scaleRightControl = new TransformToolScaleControl(SCALE_RIGHT, scaleXInteraction, "boundsRight");
        _scaleBottomRightControl = new TransformToolScaleControl(SCALE_BOTTOM_RIGHT, scaleBothInteraction, "boundsBottomRight");
        _scaleBottomControl = new TransformToolScaleControl(SCALE_BOTTOM, scaleYInteraction, "boundsBottom");
        _scaleBottomLeftControl = new TransformToolScaleControl(SCALE_BOTTOM_LEFT, scaleBothInteraction, "boundsBottomLeft");
        _scaleLeftControl = new TransformToolScaleControl(SCALE_LEFT, scaleXInteraction, "boundsLeft");
        _skewTopControl = new TransformToolSkewBar(SKEW_TOP, skewXInteraction, "boundsTopRight", "boundsTopLeft", "boundsTopRight");
        _skewRightControl = new TransformToolSkewBar(SKEW_RIGHT, skewYInteraction, "boundsBottomRight", "boundsTopRight", "boundsBottomRight");
        _skewBottomControl = new TransformToolSkewBar(SKEW_BOTTOM, skewXInteraction, "boundsBottomLeft", "boundsBottomRight", "boundsBottomLeft");
        _skewLeftControl = new TransformToolSkewBar(SKEW_LEFT, skewYInteraction, "boundsTopLeft", "boundsBottomLeft", "boundsTopLeft");
        // defining cursors
        _moveCursor = new TransformToolMoveCursor();
        _moveCursor.addReference(_moveControl);
        _registrationCursor = new TransformToolRegistrationCursor();
        _registrationCursor.addReference(_registrationControl);
        _rotationCursor = new TransformToolRotateCursor();
        _rotationCursor.addReference(_rotationTopLeftControl);
        _rotationCursor.addReference(_rotationTopRightControl);
        _rotationCursor.addReference(_rotationBottomRightControl);
        _rotationCursor.addReference(_rotationBottomLeftControl);
        _scaleCursor = new TransformToolScaleCursor();
        _scaleCursor.addReference(_scaleTopLeftControl);
        _scaleCursor.addReference(_scaleTopControl);
        _scaleCursor.addReference(_scaleTopRightControl);
        _scaleCursor.addReference(_scaleRightControl);
        _scaleCursor.addReference(_scaleBottomRightControl);
        _scaleCursor.addReference(_scaleBottomControl);
        _scaleCursor.addReference(_scaleBottomLeftControl);
        _scaleCursor.addReference(_scaleLeftControl);
        _skewCursor = new TransformToolSkewCursor();
        _skewCursor.addReference(_skewTopControl);
        _skewCursor.addReference(_skewRightControl);
        _skewCursor.addReference(_skewBottomControl);
        _skewCursor.addReference(_skewLeftControl);
        // adding controls
        addToolControl(moveControls, _moveControl);
        addToolControl(registrationControls, _registrationControl);
        addToolControl(rotateControls, _rotationTopLeftControl);
        addToolControl(rotateControls, _rotationTopRightControl);
        addToolControl(rotateControls, _rotationBottomRightControl);
        addToolControl(rotateControls, _rotationBottomLeftControl);
        addToolControl(scaleControls, _scaleTopControl);
        addToolControl(scaleControls, _scaleRightControl);
        addToolControl(scaleControls, _scaleBottomControl);
        addToolControl(scaleControls, _scaleLeftControl);
        addToolControl(scaleControls, _scaleTopLeftControl);
        addToolControl(scaleControls, _scaleTopRightControl);
        addToolControl(scaleControls, _scaleBottomRightControl);
        addToolControl(scaleControls, _scaleBottomLeftControl);
        addToolControl(skewControls, _skewTopControl);
        addToolControl(skewControls, _skewRightControl);
        addToolControl(skewControls, _skewBottomControl);
        addToolControl(skewControls, _skewLeftControl);
        addToolControl(lines, new TransformToolOutline("outline"), false);
        // adding cursors
        addToolControl(cursors, _moveCursor, false);
        addToolControl(cursors, _registrationCursor, false);
        addToolControl(cursors, _rotationCursor, false);
        addToolControl(cursors, _scaleCursor, false);
        addToolControl(cursors, _skewCursor, false);
        updateControlsEnabled();
    }

    function addToolControl(container : Sprite, control : TransformToolControl, interactive : Bool = true) : Void {
        control.transformTool = this;
        if(interactive)  {
            control.addEventListener(MouseEvent.MOUSE_DOWN, startInteractionHandler);
        }
        container.addChild(control);
        control.dispatchEvent(new Event(CONTROL_INIT));
    }

    /**

     * Allows you to add a custom control to the tool

     * @see removeControl

     * @see addCursor

     * @see removeCursor

     */    public function addControl(control : TransformToolControl) : Void {
        addToolControl(customControls, control);
    }

    /**

     * Allows you to remove a custom control to the tool

     * @see addControl

     * @see addCursor

     * @see removeCursor

     */    public function removeControl(control : TransformToolControl) : TransformToolControl {
        if(customControls.contains(control))  {
            customControls.removeChild(control);
            return control;
        }
        return null;
    }

    /**

     * Allows you to add a custom cursor to the tool

     * @see removeCursor

     * @see addControl

     * @see removeControl

     */    public function addCursor(cursor : TransformToolCursor) : Void {
        addToolControl(customCursors, cursor);
    }

    /**

     * Allows you to remove a custom cursor to the tool

     * @see addCursor

     * @see addControl

     * @see removeControl

     */    public function removeCursor(cursor : TransformToolCursor) : TransformToolCursor {
        if(customCursors.contains(cursor))  {
            customCursors.removeChild(cursor);
            return cursor;
        }
        return null;
    }

    /**

     * Allows you to change the appearance of default controls

     * @see addControl

     * @see removeControl

     */    public function setSkin(controlName : String, skin : DisplayObject) : Void {
        var control : TransformToolInternalControl = getControlByName(controlName);
        if(control != null)  {
            control.skin = skin;
        }
    }

    /**

     * Allows you to get the skin of an existing control.

     * If one was not set, null is returned

     * @see addControl

     * @see removeControl

     */    public function getSkin(controlName : String) : DisplayObject {
        var control : TransformToolInternalControl = getControlByName(controlName);
        return control.skin;
    }

    function getControlByName(controlName : String) : TransformToolInternalControl {
        var control : TransformToolInternalControl;
        var containers : Array<Dynamic> = [skewControls, registrationControls, cursors, rotateControls, scaleControls];
        var i : Int = containers.length;
        while(i-->0 && control == null) {
            control = try cast(containers[i].getChildByName(controlName), TransformToolInternalControl) catch(e:Dynamic) null;
        }

        return control;
    }

    // Interaction Handlers
        function startInteractionHandler(event : MouseEvent) : Void {
        _currentControl = try cast(event.currentTarget, TransformToolControl) catch(e:Dynamic) null;
        if(_currentControl != null)  {
            setupInteraction();
        }
    }

    function setupInteraction() : Void {
        updateMatrix();
        apply();
        dispatchEvent(new Event(CONTROL_DOWN));
        // mouse offset to allow interaction from desired point
        mouseOffset = ((_currentControl!=null && _currentControl.referencePoint!=null)) ? _currentControl.referencePoint.subtract(new Point(mouseX, mouseY)) : new Point(0, 0);
        updateMouse();
        // set variables for interaction reference
        interactionStart = mouseLoc.clone();
        innerInteractionStart = innerMouseLoc.clone();
        interactionStartMatrix = _toolMatrix.clone();
        interactionStartAngle = distortAngle();
        if(stage!=null)  {
            // setup stage events to manage control interaction
            stage.addEventListener(MouseEvent.MOUSE_MOVE, interactionHandler);
            stage.addEventListener(MouseEvent.MOUSE_UP, endInteractionHandler, false);
            stage.addEventListener(MouseEvent.MOUSE_UP, endInteractionHandler, true);
        }
    }

    function interactionHandler(event : MouseEvent) : Void {
        // define mouse position for interaction
        updateMouse();
        // use original toolMatrix for reference of interaction
        _toolMatrix = interactionStartMatrix.clone();
        // dispatch events that let controls do their thing
        dispatchEvent(new Event(CONTROL_MOVE));
        dispatchEvent(new Event(CONTROL_TRANSFORM_TOOL));
        if(_livePreview)  {
            // update target if applicable
            apply();
        }
        // smooth sailing
        event.updateAfterEvent();
    }

    function endInteractionHandler(event : MouseEvent) : Void {
        if(event.eventPhase == EventPhase.BUBBLING_PHASE || !(Std.is(event.currentTarget, Stage)))  {
            // ignore unrelated events received by stage
            return;
        }
        if(!_livePreview)  {
            // update target if applicable
            apply();
        }
        // get stage reference from event in case
        // stage is no longer accessible from this instance
        var stageRef : Stage = try cast(event.currentTarget, Stage) catch(e:Dynamic) null;
        stageRef.removeEventListener(MouseEvent.MOUSE_MOVE, interactionHandler);
        stageRef.removeEventListener(MouseEvent.MOUSE_UP, endInteractionHandler, false);
        stageRef.removeEventListener(MouseEvent.MOUSE_UP, endInteractionHandler, true);
        dispatchEvent(new Event(CONTROL_UP));
        _currentControl = null;
    }

    // Interaction Transformations
        /**

     * Control Interaction.  Moves the tool

     */    public function moveInteraction() : Void {
        var moveLoc : Point = mouseLoc.subtract(interactionStart);
        _toolMatrix.tx += moveLoc.x;
        _toolMatrix.ty += moveLoc.y;
        updateRegistration();
        completeInteraction();
    }

    /**

     * Control Interaction.  Moves the registration point

     */    public function registrationInteraction() : Void {
        // move registration point
        _registration.x = mouseLoc.x;
        _registration.y = mouseLoc.y;
        innerRegistration = toolInvertedMatrix.transformPoint(_registration);
        if(_rememberRegistration)  {
            // log new registration point for the next
            // time this target is selected
            Reflect.setField(registrationLog, Std.string(_target), innerRegistration);
        }
        completeInteraction();
    }

    /**

     * Control Interaction.  Rotates the tool

     */    public function rotationInteraction() : Void {
        // rotate in global transform
        var globalMatrix : Matrix = transform.concatenatedMatrix;
        var globalInvertedMatrix : Matrix = globalMatrix.clone();
        globalInvertedMatrix.invert();
        _toolMatrix.concat(globalMatrix);
        // get change in rotation
        var angle : Float = distortAngle() - interactionStartAngle;
        if(_constrainRotation)  {
            // constrain rotation based on constrainRotationAngle
            if(angle > Math.PI)  {
                angle -= Math.PI * 2;
            }

            else if(angle < -Math.PI)  {
                angle += Math.PI * 2;
            }
;
            angle = Math.round(angle / _constrainRotationAngle) * _constrainRotationAngle;
        }
        // apply rotation to toolMatrix
        _toolMatrix.rotate(angle);
        _toolMatrix.concat(globalInvertedMatrix);
        completeInteraction(true);
    }

    /**

     * Control Interaction.  Scales the tool along the X axis

     */    public function scaleXInteraction() : Void {
        // get distortion offset vertical movement
        var distortH : Point = distortOffset(new Point(innerMouseLoc.x, innerInteractionStart.y), innerInteractionStart.x - innerRegistration.x);
        // update the matrix for vertical scale
        _toolMatrix.a += distortH.x;
        _toolMatrix.b += distortH.y;
        completeInteraction(true);
    }

    /**

     * Control Interaction.  Scales the tool along the Y axis

     */    public function scaleYInteraction() : Void {
        // get distortion offset vertical movement
        var distortV : Point = distortOffset(new Point(innerInteractionStart.x, innerMouseLoc.y), innerInteractionStart.y - innerRegistration.y);
        // update the matrix for vertical scale
        _toolMatrix.c += distortV.x;
        _toolMatrix.d += distortV.y;
        completeInteraction(true);
    }

    /**

     * Control Interaction.  Scales the tool along both the X and Y axes

     */    public function scaleBothInteraction() : Void {
        // mouse reference, may change from innerMouseLoc if constraining
        var innerMouseRef : Point = innerMouseLoc.clone();
        if(_constrainScale)  {
            // how much the mouse has moved from starting the interaction
            var moved : Point = innerMouseLoc.subtract(innerInteractionStart);
            // the relationship of the start location to the registration point
            var regOffset : Point = innerInteractionStart.subtract(innerRegistration);
            // find the ratios between movement and the registration offset
            var ratioH = (regOffset.x>0) ? moved.x / regOffset.x : 0;
            var ratioV = (regOffset.y>0) ? moved.y / regOffset.y : 0;
            // have the larger of the movement distances brought down
            // based on the lowest ratio to fit the registration offset
            if(ratioH > ratioV)  {
                innerMouseRef.x = innerInteractionStart.x + regOffset.x * ratioV;
            }

            else  {
                innerMouseRef.y = innerInteractionStart.y + regOffset.y * ratioH;
            }
;
        }
        // get distortion offsets for both vertical and horizontal movements
        var distortH : Point = distortOffset(new Point(innerMouseRef.x, innerInteractionStart.y), innerInteractionStart.x - innerRegistration.x);
        var distortV : Point = distortOffset(new Point(innerInteractionStart.x, innerMouseRef.y), innerInteractionStart.y - innerRegistration.y);
        // update the matrix for both scales
        _toolMatrix.a += distortH.x;
        _toolMatrix.b += distortH.y;
        _toolMatrix.c += distortV.x;
        _toolMatrix.d += distortV.y;
        completeInteraction(true);
    }

    /**

     * Control Interaction.  Skews the tool along the X axis

     */    public function skewXInteraction() : Void {
        var distortH : Point = distortOffset(new Point(innerMouseLoc.x, innerInteractionStart.y), innerInteractionStart.y - innerRegistration.y);
        _toolMatrix.c += distortH.x;
        _toolMatrix.d += distortH.y;
        completeInteraction(true);
    }

    /**

     * Control Interaction.  Skews the tool along the Y axis

     */    public function skewYInteraction() : Void {
        var distortV : Point = distortOffset(new Point(innerInteractionStart.x, innerMouseLoc.y), innerInteractionStart.x - innerRegistration.x);
        _toolMatrix.a += distortV.x;
        _toolMatrix.b += distortV.y;
        completeInteraction(true);
    }

    function distortOffset(offset : Point, regDiff : Float) : Point {
        // get changes in matrix combinations based on targetBounds
        var ratioH : Float = (regDiff>0) ? targetBounds.width / regDiff : 0;
        var ratioV : Float = (regDiff>0) ? targetBounds.height / regDiff : 0;
        offset = interactionStartMatrix.transformPoint(offset).subtract(interactionStart);
        offset.x *= (targetBounds.width>0) ? ratioH / targetBounds.width : 0;
        offset.y *= (targetBounds.height>0) ? ratioV / targetBounds.height : 0;
        return offset;
    }

    function completeInteraction(offsetReg : Bool = false) : Void {
        enforceLimits();
        if(offsetReg)  {
            // offset of registration to have transformations based around
            // custom registration point
            var offset : Point = _registration.subtract(_toolMatrix.transformPoint(innerRegistration));
            _toolMatrix.tx += offset.x;
            _toolMatrix.ty += offset.y;
        }
        updateBounds();
    }

    // Information
        function distortAngle() : Float {
        // use global mouse and registration
        var globalMatrix : Matrix = transform.concatenatedMatrix;
        var gMouseLoc : Point = globalMatrix.transformPoint(mouseLoc);
        var gRegistration : Point = globalMatrix.transformPoint(_registration);
        // distance and angle of mouse from registration
        var offset : Point = gMouseLoc.subtract(gRegistration);
        return Math.atan2(offset.y, offset.x);
    }

    // Updates
        function updateMouse() : Void {
        mouseLoc = new Point(mouseX, mouseY).add(mouseOffset);
        innerMouseLoc = toolInvertedMatrix.transformPoint(mouseLoc);
    }

    function updateMatrix(useMatrix : Matrix = null, counterTransform : Bool = true) : Void {
        if(_target != null)  {
            _toolMatrix = (useMatrix!=null) ? useMatrix.clone() : _target.transform.concatenatedMatrix.clone();
            if(counterTransform)  {
                // counter transform of the parents of the tool
                var current : Matrix = transform.concatenatedMatrix;
                current.invert();
                _toolMatrix.concat(current);
            }
            enforceLimits();
            toolInvertedMatrix = _toolMatrix.clone();
            toolInvertedMatrix.invert();
            updateBounds();
        }
    }

    function updateBounds() : Void {
        if(_target != null)  {
            // update tool bounds based on target bounds
            targetBounds = _target.getBounds(_target);
            _boundsTopLeft = _toolMatrix.transformPoint(new Point(targetBounds.left, targetBounds.top));
            _boundsTopRight = _toolMatrix.transformPoint(new Point(targetBounds.right, targetBounds.top));
            _boundsBottomRight = _toolMatrix.transformPoint(new Point(targetBounds.right, targetBounds.bottom));
            _boundsBottomLeft = _toolMatrix.transformPoint(new Point(targetBounds.left, targetBounds.bottom));
            _boundsTop = Point.interpolate(_boundsTopLeft, _boundsTopRight, .5);
            _boundsRight = Point.interpolate(_boundsTopRight, _boundsBottomRight, .5);
            _boundsBottom = Point.interpolate(_boundsBottomRight, _boundsBottomLeft, .5);
            _boundsLeft = Point.interpolate(_boundsBottomLeft, _boundsTopLeft, .5);
            _boundsCenter = Point.interpolate(_boundsTopLeft, _boundsBottomRight, .5);
        }
    }

    function updateControlsVisible() : Void {
        // show toolSprites only if there is a valid target
        var isChild : Bool = contains(toolSprites);
        if(_target != null)  {
            if(!isChild)  {
                addChild(toolSprites);
            }
        }

        else if(isChild)  {
            removeChild(toolSprites);
        }
    }

    function updateControlsEnabled() : Void {
        // highest arrangement
        updateControlContainer(customCursors, _customCursorsEnabled);
        updateControlContainer(cursors, _cursorsEnabled);
        updateControlContainer(customControls, _customControlsEnabled);
        updateControlContainer(registrationControls, _registrationEnabled);
        updateControlContainer(scaleControls, _scaleEnabled);
        updateControlContainer(skewControls, _skewEnabled);
        updateControlContainer(moveControls, _moveEnabled);
        updateControlContainer(rotateControls, _rotationEnabled);
        updateControlContainer(lines, _outlineEnabled);
    }

    function updateControlContainer(container : Sprite, enabled : Bool) : Void {
        var isChild : Bool = toolSprites.contains(container);
        if(enabled)  {
            // add child or sent to bottom if enabled
            if(isChild)  {
                toolSprites.setChildIndex(container, 0);
            }

            else  {
                toolSprites.addChildAt(container, 0);
            }
;
        }

        else if(isChild)  {
            // removed if disabled
            toolSprites.removeChild(container);
        }
    }

    function updateRegistration() : Void {
        _registration = _toolMatrix.transformPoint(innerRegistration);
    }

    function enforceLimits() : Void {
        var currScale : Float;
        var angle : Float;
        var enforced : Bool = false;
        // use global matrix
        var _globalMatrix : Matrix = _toolMatrix.clone();
        _globalMatrix.concat(transform.concatenatedMatrix);
        // check current scale in X
        currScale = Math.sqrt(_globalMatrix.a * _globalMatrix.a + _globalMatrix.b * _globalMatrix.b);
        if(currScale > _maxScaleX)  {
            // set scaleX to no greater than _maxScaleX
            angle = Math.atan2(_globalMatrix.b, _globalMatrix.a);
            _globalMatrix.a = Math.cos(angle) * _maxScaleX;
            _globalMatrix.b = Math.sin(angle) * _maxScaleX;
            enforced = true;
        }
        // check current scale in Y
        currScale = Math.sqrt(_globalMatrix.c * _globalMatrix.c + _globalMatrix.d * _globalMatrix.d);
        if(currScale > _maxScaleY)  {
            // set scaleY to no greater than _maxScaleY
            angle = Math.atan2(_globalMatrix.c, _globalMatrix.d);
            _globalMatrix.d = Math.cos(angle) * _maxScaleY;
            _globalMatrix.c = Math.sin(angle) * _maxScaleY;
            enforced = true;
        }
        if(currScale < 0.1)  {
            var limit : Float = 0.1;
            // set scaleY to no greater than _maxScaleY
            angle = Math.atan2(_globalMatrix.b, _globalMatrix.a);
            _globalMatrix.a = Math.cos(angle) * limit;
            _globalMatrix.b = Math.sin(angle) * limit;
            _globalMatrix.d = Math.cos(angle) * limit;
            _globalMatrix.c = Math.sin(angle) * limit;
            enforced = true;
        }
        // if scale was enforced, apply to _toolMatrix
        if(enforced)  {
            _toolMatrix = _globalMatrix;
            var current : Matrix = transform.concatenatedMatrix;
            current.invert();
            _toolMatrix.concat(current);
        }
;
    }

    // Render
        function setNewRegistation() : Void {
        if(_rememberRegistration && Lambda.has(registrationLog, _target))  {
            // retrieved saved reg point in log
            var savedReg : Point = Reflect.field(registrationLog, Std.string(_target));
            innerRegistration = Reflect.field(registrationLog, Std.string(_target));
        }

        else  {
            // use internal own point
            innerRegistration = new Point(0, 0);
        }

        updateRegistration();
    }

    function raiseTarget() : Void {
        // set target to last object in display list
        var index : Int = _target.parent.numChildren - 1;
        _target.parent.setChildIndex(_target, index);
        // if this tool is in the same display list
        // raise it to the top above target
        if(_target.parent == parent)  {
            parent.setChildIndex(this, index);
        }
;
    }

    /**

     * Draws the transform tool over its target instance

     */    public function draw() : Void {
        // update the matrix and draw controls
        updateMatrix();
        dispatchEvent(new Event(TRANSFORM_TOOL));
    }

    /**

     * Applies the current tool transformation to its target instance

     */    public function apply() : Void {
        if(_target != null)  {
            // get matrix to apply to target
            var applyMatrix : Matrix = _toolMatrix.clone();
            applyMatrix.concat(transform.concatenatedMatrix);
            // if target has a parent, counter parent transformations
            if(_target.parent!=null)  {
                var invertMatrix : Matrix = target.parent.transform.concatenatedMatrix;
                invertMatrix.invert();
                applyMatrix.concat(invertMatrix);
            }
;
            // set target's matrix
            _target.transform.matrix = applyMatrix;
            dispatchEvent(new Event(TRANSFORM_TARGET));
        }
    }

}

// Controls
class TransformToolInternalControl extends TransformToolControl {
    public var skin(getSkin, setSkin) : DisplayObject;

    public var interactionMethod : Void->Void;
    public var referenceName : String;
    public var _skin : DisplayObject;
    public function setSkin(skin : DisplayObject) : DisplayObject {
        if(_skin != null && contains(_skin))  {
            removeChild(_skin);
        }
        _skin = skin;
        if(_skin != null)  {
            addChild(_skin);
        }
        draw();
        return skin;
    }

    public function getSkin() : DisplayObject {
        return _skin;
    }

    override public function getReferencePoint() : Point {
        if(Lambda.has(_transformTool, referenceName))  {
            return _transformTool[referenceName];
        }
        return null;
    }

    /*

     * Constructor

     */    public function new(name : String, interactionMethod : Void->Void = null, referenceName : String = null) {
        this.name = name;
        this.interactionMethod = interactionMethod;
        this.referenceName = referenceName;
        addEventListener(TransformTool.CONTROL_INIT, init);
        super();
    }

    function init(event : Event) : Void {
        _transformTool.addEventListener(TransformTool.NEW_TARGET, draw);
        _transformTool.addEventListener(TransformTool.TRANSFORM_TOOL, draw);
        _transformTool.addEventListener(TransformTool.CONTROL_TRANSFORM_TOOL, position);
        _transformTool.addEventListener(TransformTool.CONTROL_PREFERENCE, draw);
        _transformTool.addEventListener(TransformTool.CONTROL_MOVE, controlMove);
        draw();
    }

    public function draw(event : Event = null) : Void {
        if(_transformTool.maintainControlForm)  {
            counterTransform();
        }
        position();
    }

    public function position(event : Event = null) : Void {
        var reference : Point = referencePoint;
        if(reference != null)  {
            x = reference.x;
            y = reference.y;
        }
    }

    function controlMove(event : Event) : Void {
        if(interactionMethod != null && _transformTool.currentControl == this)  {
            interactionMethod();
        }
    }

}

class TransformToolMoveShape extends TransformToolInternalControl {

    var lastTarget : DisplayObject;
    public function new(name : String, interactionMethod : Void->Void) {
        super(name, interactionMethod);
    }

    override public function draw(event : Event = null) : Void {
        var currTarget : DisplayObject;
        var moveUnderObjects : Bool = _transformTool.moveUnderObjects;
        // use hitArea if moving under objects
        // then movement would have the same depth as the tool
        if(moveUnderObjects)  {
            hitArea = try cast(_transformTool.target, Sprite) catch(e:Dynamic) null;
            currTarget = null;
            relatedObject = this;
        }

        else  {
            // when not moving under objects
            // use the tool target to handle movement allowing
            // objects above it to be selectable
            hitArea = null;
            currTarget = _transformTool.target;
            relatedObject = try cast(_transformTool.target, InteractiveObject) catch(e:Dynamic) null;
        }
;
        if(lastTarget != currTarget)  {
            // set up/remove listeners for target being clicked
            if(lastTarget != null)  {
                lastTarget.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown, false);
            }
;
            if(currTarget != null)  {
                currTarget.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown, false, 0, true);
            }
            // register/unregister cursor with the object
            var cursor : TransformToolCursor = _transformTool.moveCursor;
            cursor.removeReference(lastTarget);
            cursor.addReference(currTarget);
            lastTarget = currTarget;
        }
    }

    function mouseDown(event : MouseEvent) : Void {
        dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
    }

}

class TransformToolRegistrationControl extends TransformToolInternalControl {

    public function new(name : String, interactionMethod : Void->Void, referenceName : String) {
        super(name, interactionMethod, referenceName);
    }

    override public function draw(event : Event = null) : Void {
        graphics.clear();
        if(_skin == null)  {
            graphics.lineStyle(1, 0);
            graphics.beginFill(0xFFFFFF);
            graphics.drawCircle(0, 0, _transformTool.controlSize / 2);
            graphics.endFill();
        }
        super.draw();
    }

}

class TransformToolScaleControl extends TransformToolInternalControl {

    public function new(name : String, interactionMethod : Void->Void, referenceName : String) {
        super(name, interactionMethod, referenceName);
    }

    override public function draw(event : Event = null) : Void {
        graphics.clear();
        if(_skin == null)  {
            graphics.lineStyle(2, 0xFFFFFF);
            graphics.beginFill(0);
            var size = _transformTool.controlSize;
            var size2 : Float = size / 2;
            graphics.drawRect(-size2, -size2, size, size);
            graphics.endFill();
        }
        super.draw();
    }

}

class TransformToolRotateControl extends TransformToolInternalControl {

    var locationName : String;
    public function new(name : String, interactionMethod : Void->Void, locationName : String) {
        super(name, interactionMethod);
        this.locationName = locationName;
    }

    override public function draw(event : Event = null) : Void {
        graphics.clear();
        if(_skin == null)  {
            graphics.beginFill(0xFF, 0);
            graphics.drawCircle(0, 0, _transformTool.controlSize * 2);
            graphics.endFill();
        }
        super.draw();
    }

    override public function position(event : Event = null) : Void {
        if(Lambda.has(_transformTool, locationName))  {
            var location : Point = _transformTool[locationName];
            x = location.x;
            y = location.y;
        }
    }

}

class TransformToolSkewBar extends TransformToolInternalControl {

    var locationStart : String;
    var locationEnd : String;
    public function new(name : String, interactionMethod : Void->Void, referenceName : String, locationStart : String, locationEnd : String) {
        super(name, interactionMethod, referenceName);
        this.locationStart = locationStart;
        this.locationEnd = locationEnd;
    }

    override public function draw(event : Event = null) : Void {
        graphics.clear();
        if(_skin != null)  {
            super.draw(event);
            return;
        }
        // derive point locations for bar
        var locStart : Point = _transformTool[locationStart];
        var locEnd : Point = _transformTool[locationEnd];
        // counter transform
        var toolTrans : Matrix;
        var toolTransInverted : Matrix;
        var maintainControlForm : Bool = _transformTool.maintainControlForm;
        if(maintainControlForm)  {
            toolTrans = transform.concatenatedMatrix;
            toolTransInverted = toolTrans.clone();
            toolTransInverted.invert();
            locStart = toolTrans.transformPoint(locStart);
            locEnd = toolTrans.transformPoint(locEnd);
        }
        var size : Float = _transformTool.controlSize / 2;
        var diff : Point = locEnd.subtract(locStart);
        var angle : Float = Math.atan2(diff.y, diff.x) - Math.PI / 2;
        var offset : Point = Point.polar(size, angle);
        var corner1 : Point = locStart.add(offset);
        var corner2 : Point = locEnd.add(offset);
        var corner3 : Point = locEnd.subtract(offset);
        var corner4 : Point = locStart.subtract(offset);
        if(maintainControlForm)  {
            corner1 = toolTransInverted.transformPoint(corner1);
            corner2 = toolTransInverted.transformPoint(corner2);
            corner3 = toolTransInverted.transformPoint(corner3);
            corner4 = toolTransInverted.transformPoint(corner4);
        }
        // draw bar
        graphics.beginFill(0xFF0000, 0);
        graphics.moveTo(corner1.x, corner1.y);
        graphics.lineTo(corner2.x, corner2.y);
        graphics.lineTo(corner3.x, corner3.y);
        graphics.lineTo(corner4.x, corner4.y);
        graphics.lineTo(corner1.x, corner1.y);
        graphics.endFill();
    }

    override public function position(event : Event = null) : Void {
        if(_skin != null)  {
            var locStart : Point = _transformTool[locationStart];
            var locEnd : Point = _transformTool[locationEnd];
            var location : Point = Point.interpolate(locStart, locEnd, .5);
            x = location.x;
            y = location.y;
        }

        else  {
            x = 0;
            y = 0;
            draw(event);
        }

    }

}

class TransformToolOutline extends TransformToolInternalControl {

    public function new(name : String) {
        super(name);
    }

    override public function draw(event : Event = null) : Void {
        var topLeft : Point = _transformTool.boundsTopLeft;
        var topRight : Point = _transformTool.boundsTopRight;
        var bottomRight : Point = _transformTool.boundsBottomRight;
        var bottomLeft : Point = _transformTool.boundsBottomLeft;
        graphics.clear();
        graphics.lineStyle(0, 0);
        graphics.moveTo(topLeft.x, topLeft.y);
        graphics.lineTo(topRight.x, topRight.y);
        graphics.lineTo(bottomRight.x, bottomRight.y);
        graphics.lineTo(bottomLeft.x, bottomLeft.y);
        graphics.lineTo(topLeft.x, topLeft.y);
    }

    override public function position(event : Event = null) : Void {
        draw(event);
    }

}

// Cursors
class TransformToolInternalCursor extends TransformToolCursor {

    public var offset : Point;
    public var icon : Shape;
    public function new() {
        offset = new Point();
        icon = new Shape();
        addChild(icon);
        offset = _mouseOffset;
        addEventListener(TransformTool.CONTROL_INIT, init);
        super();
    }

    override function init(event : Event) : Void {
        _transformTool.addEventListener(TransformTool.NEW_TARGET, maintainTransform);
        _transformTool.addEventListener(TransformTool.CONTROL_PREFERENCE, maintainTransform);
        draw();
    }

    function maintainTransform(event : Event) : Void {
        offset = _mouseOffset;
        if(_transformTool.maintainControlForm)  {
            transform.matrix = new Matrix();
            var concatMatrix : Matrix = transform.concatenatedMatrix;
            concatMatrix.invert();
            transform.matrix = concatMatrix;
            offset = concatMatrix.deltaTransformPoint(offset);
        }
        updateVisible(event);
    }

    function drawArc(originX : Float, originY : Float, radius : Float, angle1 : Float, angle2 : Float, useMove : Bool = true) : Void {
        var diff : Float = angle2 - angle1;
        var divs : Float = 1 + Math.floor(Math.abs(diff) / (Math.PI / 4));
        var span : Float = diff / (2 * divs);
        var cosSpan : Float = Math.cos(span);
        var radiusc : Float = (cosSpan>0) ? radius / cosSpan : 0;
        var i : Int;
        if(useMove)  {
            icon.graphics.moveTo(originX + Math.cos(angle1) * radius, originY - Math.sin(angle1) * radius);
        }

        else  {
            icon.graphics.lineTo(originX + Math.cos(angle1) * radius, originY - Math.sin(angle1) * radius);
        }

        i = 0;
        while(i < divs) {
            angle2 = angle1 + span;
            angle1 = angle2 + span;
            icon.graphics.curveTo(originX + Math.cos(angle2) * radiusc, originY - Math.sin(angle2) * radiusc, originX + Math.cos(angle1) * radius, originY - Math.sin(angle1) * radius);
            i++;
        }
    }

    function getGlobalAngle(vector : Point) : Float {
        var globalMatrix : Matrix = _transformTool.globalMatrix;
        vector = globalMatrix.deltaTransformPoint(vector);
        return Math.atan2(vector.y, vector.x) * (180 / Math.PI);
    }

    override public function position(event : Event = null) : Void {
        if(parent!=null)  {
            x = parent.mouseX + offset.x;
            y = parent.mouseY + offset.y;
        }
    }

    public function draw() : Void {
        icon.graphics.beginFill(0);
        icon.graphics.lineStyle(1, 0xFFFFFF);
    }

}

class TransformToolRegistrationCursor extends TransformToolInternalCursor {

    public function new() {
        super();
    }

    override public function draw() : Void {
        super.draw();
        icon.graphics.drawCircle(0, 0, 2);
        icon.graphics.drawCircle(0, 0, 4);
        icon.graphics.endFill();
    }

}

class TransformToolMoveCursor extends TransformToolInternalCursor {

    public function new() {
        super();
    }

    override public function draw() : Void {
        super.draw();
        // up arrow
        icon.graphics.moveTo(1, 1);
        icon.graphics.lineTo(1, -2);
        icon.graphics.lineTo(-1, -2);
        icon.graphics.lineTo(2, -6);
        icon.graphics.lineTo(5, -2);
        icon.graphics.lineTo(3, -2);
        icon.graphics.lineTo(3, 1);
        // right arrow
        icon.graphics.lineTo(6, 1);
        icon.graphics.lineTo(6, -1);
        icon.graphics.lineTo(10, 2);
        icon.graphics.lineTo(6, 5);
        icon.graphics.lineTo(6, 3);
        icon.graphics.lineTo(3, 3);
        // down arrow
        icon.graphics.lineTo(3, 5);
        icon.graphics.lineTo(3, 6);
        icon.graphics.lineTo(5, 6);
        icon.graphics.lineTo(2, 10);
        icon.graphics.lineTo(-1, 6);
        icon.graphics.lineTo(1, 6);
        icon.graphics.lineTo(1, 5);
        // left arrow
        icon.graphics.lineTo(1, 3);
        icon.graphics.lineTo(-2, 3);
        icon.graphics.lineTo(-2, 5);
        icon.graphics.lineTo(-6, 2);
        icon.graphics.lineTo(-2, -1);
        icon.graphics.lineTo(-2, 1);
        icon.graphics.lineTo(1, 1);
        icon.graphics.endFill();
    }

}

class TransformToolScaleCursor extends TransformToolInternalCursor {

    public function new() {
        super();
    }

    override public function draw() : Void {
        super.draw();
        // right arrow
        icon.graphics.moveTo(4.5, -0.5);
        icon.graphics.lineTo(4.5, -2.5);
        icon.graphics.lineTo(8.5, 0.5);
        icon.graphics.lineTo(4.5, 3.5);
        icon.graphics.lineTo(4.5, 1.5);
        icon.graphics.lineTo(-0.5, 1.5);
        // left arrow
        icon.graphics.lineTo(-3.5, 1.5);
        icon.graphics.lineTo(-3.5, 3.5);
        icon.graphics.lineTo(-7.5, 0.5);
        icon.graphics.lineTo(-3.5, -2.5);
        icon.graphics.lineTo(-3.5, -0.5);
        icon.graphics.lineTo(4.5, -0.5);
        icon.graphics.endFill();
    }

    override public function updateVisible(event : Event = null) : Void {
        super.updateVisible(event);
        if(event != null)  {
            var reference : TransformToolScaleControl = try cast(event.target, TransformToolScaleControl) catch(e:Dynamic) null;
            if(reference != null)  {
                switch(reference) {
                case _transformTool.scaleTopLeftControl, _transformTool.scaleBottomRightControl:
                    icon.rotation = (getGlobalAngle(new Point(0, 100)) + getGlobalAngle(new Point(100, 0))) / 2;
                case _transformTool.scaleTopRightControl, _transformTool.scaleBottomLeftControl:
                    icon.rotation = (getGlobalAngle(new Point(0, -100)) + getGlobalAngle(new Point(100, 0))) / 2;
                case _transformTool.scaleTopControl, _transformTool.scaleBottomControl:
                    icon.rotation = getGlobalAngle(new Point(0, 100));
                default:
                    icon.rotation = getGlobalAngle(new Point(100, 0));
                }
            }
        }
    }

}

class TransformToolRotateCursor extends TransformToolInternalCursor {

    public function new() {
        super();
    }

    override public function draw() : Void {
        super.draw();
        // curve
        var angle1 : Float = Math.PI;
        var angle2 : Float = -Math.PI / 2;
        drawArc(0, 0, 4, angle1, angle2);
        drawArc(0, 0, 6, angle2, angle1, false);
        // arrow
        icon.graphics.lineTo(-8, 0);
        icon.graphics.lineTo(-5, 4);
        icon.graphics.lineTo(-2, 0);
        icon.graphics.lineTo(-4, 0);
        icon.graphics.endFill();
    }

}

class TransformToolSkewCursor extends TransformToolInternalCursor {

    public function new() {
        super();
    }

    override public function draw() : Void {
        super.draw();
        // right arrow
        icon.graphics.moveTo(-6, -1);
        icon.graphics.lineTo(6, -1);
        icon.graphics.lineTo(6, -4);
        icon.graphics.lineTo(10, 1);
        icon.graphics.lineTo(-6, 1);
        icon.graphics.lineTo(-6, -1);
        icon.graphics.endFill();
        super.draw();
        // left arrow
        icon.graphics.moveTo(10, 5);
        icon.graphics.lineTo(-2, 5);
        icon.graphics.lineTo(-2, 8);
        icon.graphics.lineTo(-6, 3);
        icon.graphics.lineTo(10, 3);
        icon.graphics.lineTo(10, 5);
        icon.graphics.endFill();
    }

    override public function updateVisible(event : Event = null) : Void {
        super.updateVisible(event);
        if(event != null)  {
            var reference : TransformToolSkewBar = try cast(event.target, TransformToolSkewBar) catch(e:Dynamic) null;
            if(reference != null)  {
                switch(reference) {
                case _transformTool.skewLeftControl, _transformTool.skewRightControl:
                    icon.rotation = getGlobalAngle(new Point(0, 100));
                default:
                    icon.rotation = getGlobalAngle(new Point(100, 0));
                }
            }
        }
    }

}

