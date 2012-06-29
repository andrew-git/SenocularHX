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

package;

import flash.display.Sprite;
import flash.display.DisplayObject; 
import flash.display.StageScaleMode;
import flash.display.StageAlign;
import flash.events.Event;    
import flash.geom.Rectangle;
import flash.Lib;
import com.senocular.display.Layout;
import com.senocular.display.LayoutManager;


class SpriteLayoutExample extends Sprite 
{        
  private var subject:Layout;
    
    public function new()
    {
    flash.Lib.current.addChild(this);
        super();
        initialize();
    }
    
    public function createBox():Sprite
    {
        var result:Sprite = new Sprite();
        result.graphics.beginFill(0xFF0000);
        result.graphics.drawRect(0, 0, 50, 50);
        result.graphics.endFill();
        return result;
    }
    
    public function initialize():Void
    {
        trace(this+"::"+"initialize");
        
        var box1:Sprite = createBox();
        addChild(box1);
        var box2:Sprite = createBox();
        addChild(box2);
        var box3:Sprite = createBox();
        addChild(box3);
        var box4:Sprite = createBox();
        addChild(box4);
        var box5:Sprite = createBox();
        addChild(box5);
        var box6:Sprite = createBox();
        addChild(box6);        
        
        // don't scale flash player contents and
        // keep the SWF at the top left of the player
        Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
        Lib.current.stage.align = StageAlign.TOP_LEFT;
    Lib.current.stage.addEventListener(Event.RESIZE,stageHandler);
    
        // when using the stage as a layout target
        // the layout will automatically fit to
        // stage.stageWidth and stage.stageHeight and
        // draw its children when the stage resizes
        subject = new Layout(this);
        subject.width = Lib.current.stage.stageWidth;
    subject.height = Lib.current.stage.stageHeight;
    trace(subject.rect);
    subject.addEventListener(Event.CHANGE, updateLayout); 

        // reference to store newly created layouts
        // each layout created will relate to a different
        // object on the screen
        var layout:Layout;

        // using addChild() with the new layouts you 
        // can createa  layout hierarchy relations without
        // relying on a LayoutManager instance. Alternatively
        // you can set the parent property of a layout to
        // identify a parent layout

        // the default change handler is used to fit
        // the box movie clips to the stage's layout
        layout = new Layout(box1, true);
        layout.top = 0;
        layout.left = 0;
        subject.addChild(layout);

        layout = new Layout(box2, true);
        layout.top = 0;
        layout.right = 0;
        subject.addChild(layout);

        layout = new Layout(box3, true);
        layout.bottom = 0;
        layout.right = 0;
        subject.addChild(layout);

        layout = new Layout(box4, true);
        layout.bottom = 0;
        layout.left = 0;
        subject.addChild(layout);

        layout = new Layout(box5, true);
        layout.left = 0;
        layout.verticalCenter = 0;
        layout.percentWidth = 1;
        subject.addChild(layout);

        layout = new Layout(box6, true);
        layout.top = 0;
        layout.horizontalCenter = 0;
        layout.percentHeight = 1;
        subject.addChild(layout);   
    

        // draw the stage layout now
        // to update children layouts
        // when the SWF first loads.
        // other updates will be handled 
        // when the stage resizes
        subject.draw();
    }
       
  private function stageHandler(event:Event):Void
    {                   
    trace(event);
    subject.width = Lib.current.stage.stageWidth;
    subject.height = Lib.current.stage.stageHeight;
    subject.draw(); 
  }
  
    private function updateLayout(event:Event):Void
    {                   
    trace(event+"::"+subject.rect);
    }
    
    
}
