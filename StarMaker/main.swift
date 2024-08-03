/*******************************************************************************
 * The MIT License (MIT)
 *
 * Copyright (c) 2023, Jean-David Gadina - www.xs-labs.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the Software), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 ******************************************************************************/

import Cocoa

var size  = NSSize( width: 9600, height: 4000 )
var stars = [
    ( size: 2, count: 5000, opacity: 0.4 ),
    ( size: 3, count: 2000, opacity: 0.5 ),
    ( size: 4, count: 1000, opacity: 0.6 ),
    ( size: 5, count:  500, opacity: 0.7 ),
    ( size: 6, count:  100, opacity: 0.8 ),
    ( size: 7, count:   50, opacity: 0.9 ),
    ( size: 8, count:   25, opacity: 1.0 ),
]

let width = 6880.0
let ratio = size.width / width

size.width  = size.width  / ratio
size.height = size.height / ratio

let image = NSImage( size: size )

image.lockFocus()

// NSColor.black.setFill()
// NSRect( x: 0, y: 0, width: size.width, height: size.height ).fill()

stars.forEach
{
    info in

    print( "Generating \( Int( Double( info.count ) / ratio ) ) stars of \( Double( info.size ) * ratio ) pixels" )

    ( 0 ..< Int( Double( info.count ) / ratio ) ).forEach
    {
        _ in

        let x = Double( Int.random( in: 0 ..< Int( size.width ) ) )
        let y = Double( Int.random( in: 0 ..< Int( size.height ) ) )
        let p = NSBezierPath()
        let d = ( Double( info.size ) / 2 ) * ratio

        p.move( to: NSPoint( x: x, y: y + d ) )

        p.curve( to: NSPoint( x: x + d, y: y  ),    controlPoint: NSPoint( x: x, y: y ) )
        p.curve( to: NSPoint( x: x,     y: y - d ), controlPoint: NSPoint( x: x, y: y ) )
        p.curve( to: NSPoint( x: x - d, y: y ),     controlPoint: NSPoint( x: x, y: y ) )
        p.curve( to: NSPoint( x: x,     y: y + d ), controlPoint: NSPoint( x: x, y: y ) )

        p.close()

        let r = Double.random( in: 0.8 ... 1 )
        let b = Double.random( in: 0.8 ... 1 )
        let g = min( r, b )
        let c = NSColor( red: r, green: g, blue: b, alpha: info.opacity )

        c.withAlphaComponent( info.opacity ).setFill()
        p.fill()
    }
}

image.unlockFocus()

guard let desktop = NSSearchPathForDirectoriesInDomains( .desktopDirectory, .userDomainMask, true ).first
else
{
    fatalError( "Cannot get the Desktop directory" )
}

let name = "Stars-\( Int( size.width ) )x\( Int( size.height ) )-\( UUID().uuidString )"

try? image.tiffRepresentation?.write( to: URL( filePath: desktop ).appendingPathComponent( name ).appendingPathExtension( "tif" ) )
