/* -*- C++ -*-
 * 
 *  FontInfo.h - Font information storage class of PONScripter
 *
 *  Copyright (c) 2001-2005 Ogapee (original ONScripter, of which this is a fork).
 *
 *  ogapee@aqua.dti2.ne.jp
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

#ifndef __FONT_INFO_H__
#define __FONT_INFO_H__

#include <SDL.h>
#include "ttf.h"

extern int screen_ratio1, screen_ratio2;

typedef unsigned char uchar3[3];

class FontInfo{
	int em_width_, line_space_; // Width and height of a character
	int indent;
	int pos_x, pos_y; // Current position
	int font_size, font_size_mod;
public:
	static int default_encoding;

	TTF_Font* font();
	uchar3 color;
	uchar3 on_color, off_color, nofile_color;
	int top_x, top_y; // Top left origin
	int area_x, area_y; // Size of the text windows
	int pitch_x, pitch_y; // additional spacing
	int wait_time;
	bool is_bold;
	bool is_shadow;
	bool is_transparent;
	bool is_newline_accepted;
	uchar3  window_color;

	int size() { return font_size_mod ? font_size_mod : font_size; }
	int base_size() { return font_size; }
	int mod_size() { return font_size_mod; }
	void set_size(int val) { font_size = val; }
	void set_mod_size(int val) { font_size_mod = val; }

	int style;

	int em_width();
	int line_space();

	void SetIndent(const unsigned short indent_char) { indent = GlyphAdvance(indent_char, 0); }
	void ClearIndent() { indent = 0; }

	FontInfo();
	void reset();

	int GetXOffset() const { return pos_x; }
	int GetYOffset() const { return pos_y; }	
	int GetX() const { return pos_x + top_x; }
	int GetY() const { return pos_y + top_y; };
	
	void SetXY( int x=-1, int y=-1 );
	void clear();
	void newLine();
	void setLineArea(int num);

	int GlyphAdvance(unsigned short unicode, unsigned short next);
	int StringAdvance(const char* string);

	bool isNoRoomFor(int margin=0);
	bool isLineEmpty();
	bool processCode(const char* text);
	void advanceBy(int offset);

	SDL_Rect getFullArea(int ratio1, int ratio2);

	SDL_Rect calcUpdatedArea(int start_xy[2], int ratio1, int ratio2 );
	void addShadeArea(SDL_Rect &rect, int shade_distance[2] );

	int doSize() { 
		const int sz = size();
		TTF_SetSize(font(), sz);
		return sz;
	}
};

#endif // __FONT_INFO_H__
