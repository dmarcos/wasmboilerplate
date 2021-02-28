#define WIDTH 800
#define HEIGHT 600
#include <emscripten/emscripten.h>
#include <stdint.h>
#include <cstdio>

#include "types.h"
#include "renderer.h"
#include "renderer.cpp"

uint32_t data[WIDTH * HEIGHT];
uint32_t red = (255 << 24) | 255;

extern "C" {

  uint32_t* EMSCRIPTEN_KEEPALIVE render() {

    game_offscreen_buffer buffer = {};
    buffer.Memory = data;
    buffer.Width = WIDTH;
    buffer.Height = HEIGHT;
    buffer.Pitch = WIDTH*4;
    printf("Render\n");
    Render(&buffer);
    return data;
    // for (int y = 0; y < HEIGHT; y++) {
    //  int yw = y * WIDTH;
    //  for (int x = 0; x < WIDTH; x++) { data[yw + x] = red; }
    // }
    // return data;
  }

}

