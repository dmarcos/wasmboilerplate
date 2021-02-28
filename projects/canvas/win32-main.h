#if !defined(WIN32_HANDMADE_H)

struct win32_offscreen_buffer {
  BITMAPINFO Info;
  void* Memory;
  int Width;
  int Height;
  int Pitch;
  int BytesPerPixel;
};

struct win32_window_dimension {
  int Width;
  int Height;
};

#define WIN32_HANDMADE_H
#endif

