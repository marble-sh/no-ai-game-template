// [Your Game] — starter template (raylib).
//
// Build:  make
// Run:    make run
//
// All game code lives in this one file for now.
// See PROJECT.md for the plan and README.md for build details.

#include "raylib.h"

int main(void)
{
    // Window setup.
    const int screenWidth  = 800;
    const int screenHeight = 450;

    InitWindow(screenWidth, screenHeight, "[Your Game]");
    SetTargetFPS(60); // the loop below runs at most 60 times per second

    // Main loop: one pass = one frame. WindowShouldClose() turns true when the
    // user presses ESC or clicks the window close button.
    while (!WindowShouldClose())
    {
        // UPDATE — input handling and world changes go here.
        // DRAW — paint the current state of the world.
        BeginDrawing();
        ClearBackground(RAYWHITE);
        DrawText("Your game goes here.", 10, 10, 20, LIGHTGRAY);
        EndDrawing();
    }

    CloseWindow();
    return 0;
}
