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
    
import flash.display.ActionScriptVersion;
import flash.geom.*;
import flash.utils.ByteArray<Dynamic>;
import flash.utils.Endian;

/**
 * Reads the bytes of a SWF(as a ByteArray)to acquire
 * information from the SWF file header.  Some of
 * this information is inaccessible to ActionScript
 * otherwise.
 * 
 * @author Trevor McCauley - www.senocular.com
 */
class SWFReader
{

	// properties starting with those
	// found first in the byte stream

	/**
	 * Indicates whether or not the SWF
	 * is compressed.
	 */
	public var compressed:Bool;

	/**
	 * The major version of the SWF.
	 */
	public var version:Int;

	/**
	 * The file size of the SWF.
	 */
	public var fileSize:Int;

	// compression starts here if SWF compressed:

	/**
	 * The dimensions of the SWF in the form of
	 * a Rectangle instance.
	 */
	public var dimensions(getDimensions, setDimensions):Rectangle;
 	private function getDimensions():Rectangle
	{
		return _dimensions;
	}
	private var _dimensions:Rectangle=new Rectangle();

	// dimensions gets accessor since we don't
	// want people nulling the rect;it should
	// always have a value, even if 0-ed

	/**
	 * Width of the stage as defined by the SWF.
	 * Same as dimensions.width.
	 */
	public var width(getWidth, setWidth):Int;
 	private function getWidth():Int
	{
		return Int(_dimensions.width);
	}

	/**
	 * Height of the stage as defined by the SWF.
	 * Same as dimensions.height.
	 */
	public var height(getHeight, setHeight):Int;
 	private function getHeight():Int
	{
		return Int(_dimensions.height);
	}

	/**
	 * When true, the bytes supplied in calls made to the tagCallback
	 * function includes the RECORDHEADER of that tag which includes
	 * the tag and the size of the tag. By default(false)this
	 * information is not included.
	 */
	public var tagCallbackBytesIncludesHeader(getTagCallbackBytesIncludesHeader, setTagCallbackBytesIncludesHeader):Bool;
 	private function getTagCallbackBytesIncludesHeader():Bool
	{
		return _tagCallbackBytesIncludesHeader;
	}

	private function setTagCallbackBytesIncludesHeader(value:Bool):Void
	{
		_tagCallbackBytesIncludesHeader=value;
	}
	private var _tagCallbackBytesIncludesHeader:Bool=false;

	/**
	 * The frame rate of the SWF in frames
	 * per second.
	 */
	public var frameRate:Int;

	/**
	 * The total number of frames of the SWF.
	 */
	public var totalFrames:Int;

	/**
	 * ActionScript version.
	 */
	public var asVersion:Int;

	/**
	 * Determines local playback security;when
	 * true, indicates that when this file is
	 * run locally, it can only access the network.
	 * When false, only local files can be accessed.
	 * This does not apply when the SWF is being
	 * run in a local-trusted sandbox.
	 */
	public var usesNetwork:Bool;

	/**
	 * The background color of the SWF.
	 */
	public var backgroundColor:Int;

	/**
	 * Determines if the SWF is protected from
	 * being imported Into an authoring tool.
	 */
	public var protectedFromImport:Bool;

	/**
	 * Determines if remote debugging is enabled.
	 */
	public var debuggerEnabled:Bool;

	/**
	 * The XMP metadata defined in the SWF.
	 */
	public var metadata:XML;

	/**
	 * Maximun allowed levels of recursion.
	 */
	public var recursionLimit:Int;

	/**
	 * Time in seconds a script will run in a
	 * single frame before a timeout error
	 * occurs.
	 */
	public var scriptTimeoutLimit:Int;

	/**
	 * The level of hardware acceleration specified
	 * for the SWF. 0 is none, 1 is direct, and 2
	 * is GPU(Flash Player 10+).
	 */
	public var hardwareAcceleration:Int;

	/**
	 * A callback function that will be called when
	 * a tag is read during the parse process. The
	 * callback function should contain the parameters
	 *(tag:Int, bytes:ByteArray).
	 */
	public var tagCallback:Function;

	/**
	 * Indicates that the SWF bytes last provided
	 * were successfully parsed. If the SWF bytes
	 * were not successfully parsed, no SWF data
	 * will be available.
	 */
	public var parsed:Bool;

	/**
	 * The Flash Player error message that resulted
	 * from the error that caused a parse to fail.
	 */
	public var errorText:String="";

	// keeping track of data
	private var bytes:ByteArray<Dynamic>;
	private var currentByte:Int;// used in bit reading
	private var bitPosition:Int;// used in bit reading
	private var currentTag:Int;

	// tag flags
	private var bgColorFound:Bool;

	// constants
	private static inline var GET_DATA_SIZE:Int=5;
	private static inline var TWIPS_TO_PIXELS:Float=0.05;// 20 twips in a pixel
	private static inline var TAG_HEADER_ID_BITS:Int=6;
	private static inline var TAG_HEADER_MAX_SHORT:Int=0x3F;

	private static inline var SWF_C:Int=0x43;// header characters
	private static inline var SWF_F:Int=0x46;
	private static inline var SWF_W:Int=0x57;
	private static inline var SWF_S:Int=0x53;

	private static inline var TAG_ID_EOF:Int=0;// recognized SWF tags
	private static inline var TAG_ID_BG_COLOR:Int=9;
	private static inline var TAG_ID_PROTECTED:Int=24;
	private static inline var TAG_ID_DEBUGGER1:Int=58;
	private static inline var TAG_ID_DEBUGGER2:Int=64;
	private static inline var TAG_ID_SCRIPT_LIMITS:Int=65;
	private static inline var TAG_ID_FILE_ATTS:Int=69;
	private static inline var TAG_ID_META:Int=77;

	private static inline var TAG_ID_SHAPE_1:Int=2;
	private static inline var TAG_ID_SHAPE_2:Int=22;
	private static inline var TAG_ID_SHAPE_3:Int=32;
	private static inline var TAG_ID_SHAPE_4:Int=83;

	/**
	 * SWFHeader constructor.
	 * @param	swfBytes Bytes of the SWF in a ByteArray.
	 * You can get the bytes of a SWF by loading it Into
	 * a URLLoader or using Loader.bytes once a SWF has
	 * been loaded Into that Loader.
	 */
	public function new(swfBytes:ByteArray<Dynamic>=null)
	{
		parse(swfBytes);
	}

	/**
	 * Provides a string presentation of the SWFHeader
	 * object which outlines the different values
	 * obtained from a parsed SWF
	 * @return The String form of the instance
	 */
	public function toString():String
	{
		if(parsed)
		{
			var compression:String=(compressed)? "compressed":"uncompressed";
			var frames:String=totalFrames>1 ? "frames":"frame";
			return "[SWF" + version + " AS" + asVersion + ".0:" + totalFrames + " " + frames + " @ " + frameRate + " fps "
				+ _dimensions.width + "x" + _dimensions.height + " " + compression + "]";
		}

		// default toString if SWF not parsed
		return Dynamic.prototype.toString.call(this)as String;
	}

	/**
	 * Parses the bytes of a SWF file to extract
	 * properties from its header.
	 * @param	swfBytes Bytes of a SWF to parse.
	 */
	public function parse(swfBytes:ByteArray):Void
	{
		parseDefaults();

		// null bytes, exit
		if(swfBytes==null)
		{
			parseError("Error:Cannot parse a null value.");
			return;
		}


		// assume at start parse completed successfully
		// on failure, this will be set to false
		parsed=true;

		// --------------------------------------
		// HEADER
		// --------------------------------------

		try
		{

			// try to parse the bytes.  Failures
			// results in cleared values for the data
			bytes=swfBytes;
			bytes.endian=Endian.LITTLE_ENDIAN;
			bytes.position=0;

			// get header characters
			var swfFC:Int=bytes.readUnsignedByte();// F, or C if compressed
			var swfW:Int=bytes.readUnsignedByte();// W
			var swfS:Int=bytes.readUnsignedByte();// S

			// validate header characters
			if((swfFC !=SWF_F && swfFC !=SWF_C)
				|| swfW !=SWF_W || swfS !=SWF_S)
			{
				parseError("Error:Invalid SWF header.");
				return;
			}

			compressed=Boolean(swfFC==SWF_C);//==SWF_F if not compressed

			version=bytes.readUnsignedByte();

			fileSize=bytes.readUnsignedInt();// mostly redundant since we should have full bytes

			// if compressed, need to uncompress
			// the data after the first 8 bytes
			//(first 8 already read above)
			if(compressed)
			{

				// use a temporary byte array to
				// represent the compressed portion
				// of the SWF file
				var temp:ByteArray<Dynamic>=new ByteArray();
				bytes.readBytes(temp);
				bytes=temp;
				bytes.endian=Endian.LITTLE_ENDIAN;
				bytes.position=0;
				temp=null;// temp no longer needed

				bytes.uncompress();

					// Note:at this point, the original
					// uncompressed 8 bytes are no longer
					// part of the current bytes byte array
			}

			_dimensions=readRect();
			bytes.position++;// one up after rect

			frameRate=bytes.readUnsignedByte();

			totalFrames=bytes.readUnsignedShort();

		}
		catch(error:Dynamic)
		{

			// header parse error
			parseError(error.message);
			return;
		}

		// --------------------------------------
		// TAGS
		// --------------------------------------

		// read all the tags in the file
		// up until the END tag
		try
		{
			while(readTag())
			{
				// noop	
			}
		}
		catch(error:Dynamic)
		{

			// error in tag parsing. EOF would throw
			// an error, but the END tag should be
			// reached before that occurs
			parseError(error.message);
			return;
		}

		// parse completed successfully!
		// null bytes since no longer needed
		bytes=null;
	}

	/**
	 * Defines default values for all the class
	 * properties.  This is used to have accurate
	 * values for properties which may not be
	 * present in the SWF file such as asVersion
	 * which is only required to be specified in
	 * SWF8 and above(in FileAttributes tag).
	 */
	private function parseDefaults():Void
	{
		compressed=false;
		version=1;// SWF1
		fileSize=0;
		_dimensions=new Rectangle();
		frameRate=12;// default from Flash authoring(flex==24)
		totalFrames=1;
		metadata=null;
		asVersion=ActionScriptVersion.ACTIONSCRIPT2;// 2 if not explicit
		usesNetwork=false;
		backgroundColor=0xFFFFFF;// white background
		protectedFromImport=false;
		debuggerEnabled=true;
		scriptTimeoutLimit=256;
		recursionLimit=15;
		hardwareAcceleration=0;

		errorText="";// clear existing error text

		// tag helper flags
		bgColorFound=false;
	}

	/**
	 * Clears variable data and logs an error
	 * message.
	 */
	private function parseError(message:String="Unkown error."):Void
	{
		compressed=false;
		version=0;
		fileSize=0;
		_dimensions=new Rectangle();
		frameRate=0;
		totalFrames=0;
		metadata=null;
		asVersion=0;
		usesNetwork=false;
		backgroundColor=0;
		protectedFromImport=false;
		debuggerEnabled=false;
		scriptTimeoutLimit=0;
		recursionLimit=0;
		hardwareAcceleration=0;

		parsed=false;
		bytes=null;
		errorText=message;
	}

	/**
	 * Utility to convert a unit value Into a string
	 * in hex style padding value with "0" characters.
	 * @return The string representation of the hex value.
	 */
	private function paddedHex(value:Int, numChars:Int=6):String
	{
		var str:String=value.toString(16);
		while(str.length<numChars)
			str="0" + str;
		return "0x" + str;
	}

	/**
	 * Reads a string in the byte stream by
	 * reading all bytes until a null byte(0)
	 * is reached.
	 * @return The string having been read.
	 */
	private function readString():String
	{

		// find ending null character that
		// terminates the string
		var i:Int=bytes.position;
		try
		{
			while(bytes[i] !=0)
				i++;
		}
		catch(error:Dynamic)
		{
			return "";
		}

		// null byte should have been found
		// return the read string
		return bytes.readUTFBytes(i - bytes.position);
	}

	/**
	 * Reads RECT data from the current
	 * location in the current bytes object
	 * @return A rectangle object whose values
	 * match those of the RECT read.
	 */
	private function readRect():Rectangle
	{
		nextBitByte();
		var rect:Rectangle=new Rectangle();
		var dataSize:Int=readBits(GET_DATA_SIZE);
		rect.left=readBits(dataSize, true)* TWIPS_TO_PIXELS;
		rect.right=readBits(dataSize, true)* TWIPS_TO_PIXELS;
		rect.top=readBits(dataSize, true)* TWIPS_TO_PIXELS;
		rect.bottom=readBits(dataSize, true)* TWIPS_TO_PIXELS;
		return rect;
	}

	private function readMatrix():Matrix
	{
		nextBitByte();
		var dataSize:Int;
		var matrix:Matrix=new Matrix();

		if(readBits(1))
		{ // has scale
			dataSize=readBits(GET_DATA_SIZE);
			matrix.a=readBits(dataSize, true);
			matrix.d=readBits(dataSize, true);
		}

		if(readBits(1))
		{ // has rotation
			dataSize=readBits(GET_DATA_SIZE);
			matrix.b=readBits(dataSize, true);
			matrix.c=readBits(dataSize, true);
		}

		// translation
		dataSize=readBits(GET_DATA_SIZE);
		matrix.tx=readBits(dataSize, true)* TWIPS_TO_PIXELS;
		matrix.ty=readBits(dataSize, true)* TWIPS_TO_PIXELS;

		return matrix;
	}

	/**
	 * Reads a series of bits from the current byte
	 * defined by currentByte based on the but at
	 * position bitPosition.  If more bits are required
	 * than are available in the current byte, the next
	 * byte in the bytes array is read and the bits are
	 * taken from there to complete the request.
	 * @param	numBits The number of bits to read.
	 * @return The bits read as a Int.
	 */
	private function readBits(numBits:Int, signed:Bool=false):Float
	{
		var value:Float=0;// Int or Int
		var remaining:Int=8 - bitPosition;
		var mask:Int;

		// can get all bits from current byte
		if(numBits<=remaining)
		{
			mask=(1<<numBits)- 1;
			value=(currentByte>>(remaining - numBits))& mask;
			if(numBits==remaining)
				nextBitByte();
			else
				bitPosition +=numBits;

				// have to get bits from 2(or more)
				// bytes the current and the next(recursive)
		}
		else
		{
			mask=(1<<remaining)- 1;
			var firstValue:Int=currentByte & mask;
			var over:Int=numBits - remaining;
			nextBitByte();
			value=(firstValue<<over)| readBits(over);
		}

		// convert to signed Int if signed bitflag exists
		if(signed && value>>(numBits - 1)==1)
		{
			remaining=32 - numBits;// 32-bit Int
			mask=(1<<remaining)- 1;
			return Std.int(mask<<numBits | value);
		}

		// unsigned Int
		return Int(value);
	}

	/**
	 * Reads the next byte in the stream assigning
	 * it to currentByte and resets the value of
	 * bitPosition to 0.
	 */
	private function nextBitByte():Void
	{
		currentByte=bytes.readByte();
		bitPosition=0;
	}

	/**
	 * Parses the tag at the current byte location.
	 * @return false if the tag read is the END tag;
	 * true if more tags should be present in the file.
	 */
	private function readTag():Bool
	{

		var currentTagPosition:Int=bytes.position;

		// read tag header
		var tagHeader:Int=bytes.readUnsignedShort();
		currentTag=tagHeader>>TAG_HEADER_ID_BITS;
		var tagLength:Int=tagHeader & TAG_HEADER_MAX_SHORT;

		// if a long tag, the tag length will be
		// set to its maximum. If so, set
		// the tag length to the long length
		if(tagLength==TAG_HEADER_MAX_SHORT)
		{
			tagLength=bytes.readUnsignedInt();
		}

		// when the tag is read, the position
		// of the byte stream must be set to the
		// end of this tag for the start of the next
		// tag.  This assures the correct position
		// no matter what happens in readTagData()
		var nextTagPosition:Int=bytes.position + tagLength;

		// read the data in the tag(if supported)
		var moreTags:Bool=readTagData(tagLength, currentTagPosition, nextTagPosition);
		if(!moreTags)
			return false;// end tag

		// next tag
		bytes.position=nextTagPosition;
		return true;
	}

	/**
	 * Called from readTag, this parses the value of individual
	 * tag based on the tag id read in the tag header.
	 * @param	tag A tag object containing a tag's id and length.
	 * @param	start The start position of the full tag.
	 * @param	end The end position of the full tag.
	 * @return false if the tag read is the END tag;
	 * true if more tags should be present in the file.
	 */
	private function readTagData(tagLength:Int, start:Int, end:Int):Bool
	{

		// if defined, call the tag callback with
		// the tag id and a copy of the bytes
		// specific to the tag
		if(tagCallback !=null)
		{
			var tagBytes:ByteArray<Dynamic>=new ByteArray();
			if(_tagCallbackBytesIncludesHeader)
			{
				tagBytes.writeBytes(bytes, start, end - start);
			}
			else
			{
				if(tagLength)
				{
					tagBytes.writeBytes(bytes, bytes.position, tagLength);
				}
			}
			tagBytes.position=0;
			tagCallback(currentTag, tagBytes);
		}

		// handle each tag individually based on
		// it's tag id
		switch(currentTag)
		{


			// FileAttributes tag was only required for
			// SWF 8 and later. Calling defaults()
			// assures default values for the properties
			// determined here if the tag is not present
			case TAG_ID_FILE_ATTS:

				nextBitByte();// read file attributes in bits
				readBits(1);// reserved

				hardwareAcceleration=readBits(2);

				readBits(1);// hasMetaData;auto-determined by tag

				asVersion=(readBits(1)&& version>=9)
					? ActionScriptVersion.ACTIONSCRIPT3
					:ActionScriptVersion.ACTIONSCRIPT2;

				readBits(2);// reserved(2)

				usesNetwork=Boolean(readBits(1)==1);
				// bunch of others reserved after this
				break;


			// Metadata in a SWF is in the format of
			// XMP XML. Though the FileAttributes will
			// determine if it is present, it's easier to
			// just check for the metadata tag id
			case TAG_ID_META:

				try
				{
					metadata=new XML(readString());
				}
				catch(error:Dynamic)
				{
					// error reading string or parsing as XML
				}
				break;


			// Many background colors could potentially exist
			// for a single SWF, but we're assuming there's
			// only one. If there are more, the first will be used
			case TAG_ID_BG_COLOR:

				// check the bg color found flag
				// if true, we want to ignore all other colors
				// since they would be added after this one
				if(!bgColorFound)
				{
					bgColorFound=true;

					backgroundColor=readRGB();
				}
				break;


			// Only determines if the SWF is protected from
			// import;a password, if provided, will not
			// be retrieved from the SWF
			case TAG_ID_PROTECTED:

				protectedFromImport=Boolean(bytes.readUnsignedByte()!=0);
				// password if needed
				break;


			// the debugger 1 tag is for SWF5 only
			// the debugger 2 tag is for SWF6+
			case TAG_ID_DEBUGGER1:

				if(version==5)
					debuggerEnabled=true;
				// password if needed
				break;
			case TAG_ID_DEBUGGER2:

				if(version>5)
					debuggerEnabled=true;
				// password if needed
				break;

			// for both timeout and recursion but I don't
			// think any tool lets you set recursion
			case TAG_ID_SCRIPT_LIMITS:
				recursionLimit=bytes.readUnsignedShort();
				scriptTimeoutLimit=bytes.readUnsignedShort();
				break;

			case TAG_ID_EOF:
				return false;// end of file
				break;

			default:
				// unrecognized tag by this parser;do nothing
				// if you want to support other tags
				// make sure they're caught above in
				// this switch statement.
				break;
		}

		// not last tag, continue reading
		return true;
	}

	private function readRGB():Int
	{
		return(bytes.readUnsignedByte()<<16)// R
			|(bytes.readUnsignedByte()<<8)// G
			| bytes.readUnsignedByte();//	   B
	}

	private function readARGB():Int
	{
		return(bytes.readUnsignedByte()<<24)// A
			|(bytes.readUnsignedByte()<<16)// R
			|(bytes.readUnsignedByte()<<8)// G
			| bytes.readUnsignedByte();//	   B
	}

	private function readRGBA():Int
	{
		var rByte:Int=bytes.readUnsignedByte();// R
		var gByte:Int=bytes.readUnsignedByte();// G
		var bByte:Int=bytes.readUnsignedByte();// B
		var aByte:Int=bytes.readUnsignedByte();// A
		return(aByte<<24)// A
			|(rByte<<16)// R
			|(gByte<<8)// G
			| bByte;//	   B
	}
}