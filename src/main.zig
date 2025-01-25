const rl = @import("raylib");

const game = @import("game.zig");

pub fn main() anyerror!void {
    const screen_width = 1920;
    const screen_height = 1080;

    rl.setConfigFlags(.{
        .fullscreen_mode = true,
        .window_highdpi = true,
        .msaa_4x_hint = true,
        // .window_resizable = true,
    });

    rl.initWindow(screen_width, screen_height, "movement 2");
    defer rl.closeWindow();

    rl.disableCursor();

    rl.setTargetFPS(256);

    // Main game loop
    while (!rl.windowShouldClose()) {
        // update
        game.update(rl.getFrameTime());

        // draw
        game.draw();
    }
}
