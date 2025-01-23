const rl = @import("raylib");

const game = @import("game.zig");

pub fn main() anyerror!void {
    const current_monitor = rl.getCurrentMonitor();

    const screen_width = rl.getMonitorWidth(current_monitor);
    const screen_height = rl.getMonitorHeight(current_monitor);

    rl.setConfigFlags(.{ .fullscreen_mode = true, .window_highdpi = true, .window_resizable = true });

    rl.initWindow(screen_width, screen_height, "movement 2");
    defer rl.closeWindow();

    rl.disableCursor();

    rl.setTargetFPS(240);

    // Main game loop
    while (!rl.windowShouldClose()) {
        // update
        game.update(rl.getFrameTime());

        // draw
        game.draw();
    }
}
