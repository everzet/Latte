/*
 Copyright (c) 2006-2007 by Logan Rockmore Design, http://www.loganrockmore.com/
 
 Permission is hereby granted, free of charge, to any person obtaining a
 copy of this software and associated documentation files (the "Software"),
 to deal in the Software without restriction, including without limitation
 the rights to use, copy, modify, merge, publish, distribute, sublicense,
 and/or sell copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
 THE COPYRIGHT HOLDER BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
 OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

#import "LRFilterBar.h"
#import "LRFilterButtonTigerCell.h"
#import "CTGradient.h"

@implementation LRFilterButtonTigerCell

- (void)dealloc
{
	[_lr_gradient release];
	[_lr_styles release];
	[super dealloc];
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	if ( _bcFlags2.mouseInside || NSOnState == [self state] ) {
		
		[super drawInteriorWithFrame:cellFrame inView:controlView];
		
	} else {
		NSAttributedString *title;

		if ( nil == _lr_gradient )
		{	// Create the gradient when needed.
			NSColor *topColor = [(LRFilterBar *)[[self controlView] superview] topColor];
			NSColor *bottomColor = [(LRFilterBar *)[[self controlView] superview] bottomColor];

			_lr_gradient = [[CTGradient gradientWithBeginningColor:bottomColor endingColor:topColor] retain];
		}
		[_lr_gradient fillRect:cellFrame angle:90.0];

		if( nil == _lr_styles )
		{	// Create the styles dictionary when needed.
			_lr_styles = [[NSMutableDictionary dictionaryWithObject:[self font] forKey:NSFontAttributeName] retain];
		}

		// Draw in off-white just below where we really want it.
		[_lr_styles setObject:[NSColor colorWithCalibratedWhite:0.9 alpha:1.0] forKey:NSForegroundColorAttributeName];
		title = [[NSAttributedString alloc] initWithString:[self title] attributes:_lr_styles];
		
		[super drawTitle:title withFrame:NSMakeRect(cellFrame.origin.x + 8.0,cellFrame.origin.y,cellFrame.size.width,cellFrame.size.height) inView:controlView];
		[title release];

		// Draw in dark gray exactly where we want it.
		[ _lr_styles setObject:[NSColor colorWithCalibratedWhite:0.25 alpha:1.0 ] forKey:NSForegroundColorAttributeName ];
		title = [[NSAttributedString alloc] initWithString:[self title] attributes:_lr_styles ];
		
		[super drawTitle:title withFrame:NSMakeRect(cellFrame.origin.x+8.0,cellFrame.origin.y-1.0,cellFrame.size.width,cellFrame.size.height) inView:controlView];
		[title release];
	}
}

@end

