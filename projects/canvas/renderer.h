#if !defined(RENDERER_H)

struct game_offscreen_buffer
{
  // NOTE: Pixels are alwasy 32-bits wide, Memory Order BB GG RR XX
  void* Memory;
  int Width;
  int Height;
  int Pitch;
};

internal void Render(game_offscreen_buffer *Buffer);

#define RENDERER_H
#endif