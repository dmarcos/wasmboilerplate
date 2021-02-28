#include <windows.h>
#include <stdio.h>
#include "types.h"

#include "win32-main.h"

#include "renderer.h"
#include "renderer.cpp"

global_variable s64 GlobalPerfCountFrequency;
global_variable bool GlobalRunning;
global_variable win32_offscreen_buffer GlobalBackbuffer;

inline LARGE_INTEGER
Win32GetWallClock(void)
{
  LARGE_INTEGER Result;
  QueryPerformanceCounter(&Result);
  return(Result);
}

inline real32
Win32GetSecondsElapsed(LARGE_INTEGER Start, LARGE_INTEGER End)
{
  real32 Result = ((real32)(End.QuadPart - Start.QuadPart) /
                   (real32)GlobalPerfCountFrequency);
  return(Result);
}

internal win32_window_dimension
Win32GetWindowDimension(HWND window)
{
  win32_window_dimension Result;

  RECT ClientRect;
  GetClientRect(window, &ClientRect);
  Result.Width = ClientRect.right - ClientRect.left;
  Result.Height = ClientRect.bottom - ClientRect.top;

  return(Result);
}

internal void
Win32ProcessPendingMessages() {
  MSG Message;
  while (PeekMessage(&Message, 0, 0, 0, PM_REMOVE))
  {
    switch (Message.message)
    {
      case WM_QUIT:
      {
        GlobalRunning = false;
      } break;

      case WM_SYSKEYDOWN:
      case WM_SYSKEYUP:
      case WM_KEYDOWN:
      case WM_KEYUP:
      {

      } break;

      default:
      {
        TranslateMessage(&Message);
        DispatchMessage(&Message);
      } break;
    }
  }
}

internal void
Win32ResizeDIBSection(win32_offscreen_buffer *Buffer, int Width, int Height)
{
  if (Buffer->Memory)
  {
    VirtualFree(Buffer->Memory, 0, MEM_RELEASE);
  }

  Buffer->Width = Width;
  Buffer->Height = Height;
  Buffer->BytesPerPixel = 4;

  // NOTE(casey): When the biHeight fiels is negative, this is the clue
  // to Windows to treat this bitmap as top-down, not bottom-up, meaning
  // the first three byte of the image are the color of the top lef pixel.
  // in the bitmap, not the bottom left!
  Buffer->Info.bmiHeader.biSize = sizeof(Buffer->Info.bmiHeader);
  Buffer->Info.bmiHeader.biWidth = Width;
  Buffer->Info.bmiHeader.biHeight = -Buffer->Height;
  Buffer->Info.bmiHeader.biPlanes = 1;
  Buffer->Info.bmiHeader.biBitCount = 32;
  Buffer->Info.bmiHeader.biCompression = BI_RGB;

  int BitmapMemorySize = (Buffer->Width*Buffer->Height)*Buffer->BytesPerPixel;
  Buffer->Memory = VirtualAlloc(0, BitmapMemorySize, MEM_RESERVE|MEM_COMMIT, PAGE_READWRITE);
  Buffer->Pitch = Width*Buffer->BytesPerPixel;

  // Probably clear this to black.
}

internal void
Win32DisplayBufferInWindow(win32_offscreen_buffer *Buffer, HDC DeviceContext,
                           int WindowWidth, int WindowHeight)
{
  // TODO(casey) Aspect ratio correction
  StretchDIBits(DeviceContext,
                0, 0, WindowWidth, WindowHeight,
                0, 0, Buffer->Width, Buffer->Height,
                Buffer->Memory,
                &Buffer->Info,
                DIB_RGB_COLORS, SRCCOPY);
}

LRESULT CALLBACK
Win32MainWindowCallback(HWND window,
                        UINT message,
                        WPARAM wParam,
                        LPARAM lParam)
{
  LRESULT result = 0;

  switch(message) {
    case WM_CLOSE:
    {
      GlobalRunning = false;
    } break;

    case WM_DESTROY:
    {
      GlobalRunning = false;
    } break;

    case WM_SYSKEYDOWN:
    case WM_SYSKEYUP:
    case WM_KEYDOWN:
    case WM_KEYUP:
    {

    } break;

    case WM_PAINT:
    {
      PAINTSTRUCT paint;
      HDC deviceContext = BeginPaint(window, &paint);
      win32_window_dimension dimension = Win32GetWindowDimension(window);
      Win32DisplayBufferInWindow(&GlobalBackbuffer, deviceContext, dimension.Width, dimension.Height);
      EndPaint(window, &paint);
    } break;
    default:
    {
      result = DefWindowProc(window, message, wParam, lParam);
    } break;
  }

  return (result);
}

int CALLBACK
  WinMain(
    HINSTANCE instance,
    HINSTANCE prevInstance,
    LPSTR     commandLine,
    int       showCode
  ) {

  WNDCLASS windowClass = {};

  windowClass.style = CS_OWNDC|CS_HREDRAW;
  windowClass.lpfnWndProc = Win32MainWindowCallback;
  windowClass.hInstance = instance;
  windowClass.lpszClassName = "WASMWindowClass";

  LARGE_INTEGER PerfCountFrequencyResult;
  QueryPerformanceFrequency(&PerfCountFrequencyResult);
  GlobalPerfCountFrequency = PerfCountFrequencyResult.QuadPart;

  UINT DesiredSchedulerMS = 1;
  bool32 SleepIsGranular = (timeBeginPeriod(DesiredSchedulerMS) == TIMERR_NOERROR);

  uint32 WindowHeight = 600;
  uint32 WindowWidth = 800;
  Win32ResizeDIBSection(&GlobalBackbuffer, WindowWidth, WindowHeight);

  if (RegisterClass(&windowClass)) {
    RECT rect;
    rect.left = 0;
    rect.top = 0;
    rect.right = WindowWidth;
    rect.bottom = WindowHeight;
    AdjustWindowRectEx(&rect, WS_CAPTION|WS_SYSMENU|WS_MINIMIZEBOX, FALSE, 0);

    HWND window =
      CreateWindowEx(
        0,
        windowClass.lpszClassName,
        "Canvas Sample",
        WS_OVERLAPPEDWINDOW | WS_VISIBLE,
        CW_USEDEFAULT,
        CW_USEDEFAULT,
        rect.right - rect.left, // Width
        rect.bottom - rect.top, // Height
        0,
        0,
        instance,
        0);
      if(window)
      {
        int MonitorRefreshHz = 60;
        HDC DeviceContext = GetDC(window);
        int Win32RefreshRate = GetDeviceCaps(DeviceContext, VREFRESH);
        if (Win32RefreshRate > 1)
        {
          MonitorRefreshHz = Win32RefreshRate;
        }
        real32 GameUpdateHz = (MonitorRefreshHz / 2.0f);
        real32 TargetSecondsPerFrame = 1.0f / (real32) GameUpdateHz;
        LARGE_INTEGER LastCounter = Win32GetWallClock();

        GlobalRunning = true;
        while (GlobalRunning)
        {
          HDC deviceContext = GetDC(window);

          Win32ProcessPendingMessages();

          win32_window_dimension WindowDimensions = Win32GetWindowDimension(window);

          // ------------------------ //
          // ------------------------ //
          //   YOUR RENDER FUNCTION   //
          // ------------------------ //
          // ------------------------ //
          game_offscreen_buffer buffer = {};
          buffer.Memory = GlobalBackbuffer.Memory;
          buffer.Width = GlobalBackbuffer.Width;
          buffer.Height = GlobalBackbuffer.Height;
          buffer.Pitch = GlobalBackbuffer.Pitch;
          Render(&buffer);

          win32_window_dimension Dimension = Win32GetWindowDimension(window);
          Win32DisplayBufferInWindow(&GlobalBackbuffer, DeviceContext, Dimension.Width, Dimension.Height);

          ReleaseDC(window, deviceContext);

          LARGE_INTEGER WorkCounter = Win32GetWallClock();
          real32 WorkSecondsElapsed = Win32GetSecondsElapsed(LastCounter, WorkCounter);

          // Fixed frame rate
          real32 SecondsElapsedForFrame = WorkSecondsElapsed;
          if (SecondsElapsedForFrame < TargetSecondsPerFrame) {
            if (SleepIsGranular) {
               DWORD SleepMS = (DWORD)(1000.0f * (TargetSecondsPerFrame - SecondsElapsedForFrame));
              if (SleepMS > 0)
              {
                Sleep(SleepMS);
              }
            }

            real32 TestSecondsElapsedForFrame = Win32GetSecondsElapsed(LastCounter, Win32GetWallClock());

            while (SecondsElapsedForFrame < TargetSecondsPerFrame)
            {
              SecondsElapsedForFrame = Win32GetSecondsElapsed(LastCounter, Win32GetWallClock());
            }
          }
          else
          {
            // MISSED FRAME!
          }
        }
      } else {
        // logging
      }
  } else {
    // logging
  }
  return(0);
}