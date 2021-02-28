internal void
Render(game_offscreen_buffer *Buffer) {
  int BlueOffset = 2;
  int GreenOffset = 5;
  uint8 *Row = (uint8 *) Buffer->Memory;
  for(int Y = 0;
      Y < Buffer->Height;
      ++Y)
  {
    uint32 *Pixel = (uint32 *)Row;
    for(int X = 0;
        X < Buffer->Width;
        ++X)
    {
      // Intel is little endian.
      // Register: xx RR GG BB
      // Memory: BB GG RR xx
      uint8 Blue = (uint8)(X + BlueOffset);
      uint8 Green = (uint8)(Y + GreenOffset);
      *Pixel++ = ((255 << 24) | (Green << 8) | Blue);
    }
    Row += Buffer->Pitch;
  }
}
