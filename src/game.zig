const rl = @import("raylib");
const std = @import("std");

const player = @import("player.zig");

var camera: rl.Camera3D = .{
    .position = rl.Vector3.init(0, 10.0, 10.0),
    .target = rl.Vector3.init(0, 0, 0),
    .up = rl.Vector3.init(0, 1, 0),
    .projection = .perspective,
    .fovy = 90.0,
};

var plr = player.Player.init(
    .{ .x = 0, .y = 0, .z = 0 },
    .{ .x = 0, .y = 0, .z = 0 },
    .{ .x = 0, .y = -8, .z = 0 },
);

pub fn update(dt: f32) void {
    plr.update(dt);
    camera.update(.first_person);
}

pub fn draw() void {
    rl.beginDrawing();
    defer rl.endDrawing();

    rl.clearBackground(rl.Color.white);

    // 3d area
    {
        camera.begin();
        defer camera.end();

        rl.drawCube(.{ .x = 0, .y = 0, .z = 0 }, 2, 2, 2, rl.Color.red);
        rl.drawGrid(32, 1);
    }

    rl.drawFPS(0, 0);
}
