const rl = @import("raylib");
const std = @import("std");

const player = @import("player.zig");
const consts = @import("constants.zig");

const CAMERA_SPEED = 8;

var plr = player.Player.init(
    .{ .x = 0, .y = 0, .z = 0 },
    .{ .x = 0, .y = consts.gravity, .z = 0 },
    .{
        .position = rl.Vector3.init(0, 16.0, 16.0),
        .target = rl.Vector3.init(0, 0, 0),
        .up = rl.Vector3.init(0, 1, 0),
        .projection = .perspective,
        .fovy = 90.0,
    },
);

pub fn update(dt: f32) void {
    plr.rotateCamera(rl.getMouseDelta());

    var mov: rl.Vector2 = rl.Vector2.init(0, 0);

    if (rl.isKeyDown(.w)) {
        mov.x += consts.max_speed;
    }
    if (rl.isKeyDown(.a)) {
        mov.y -= consts.max_speed;
    }
    if (rl.isKeyDown(.s)) {
        mov.x -= consts.max_speed;
    }
    if (rl.isKeyDown(.d)) {
        mov.y += consts.max_speed;
    }

    // update player and camera
    plr.update(mov, dt);
    // fwd.y = 0;
    std.debug.print("velocity: {}\n", .{plr.velocity.length()});
}

pub fn draw() void {
    rl.beginDrawing();
    defer rl.endDrawing();

    rl.clearBackground(rl.Color.white);

    // 3d area
    {
        plr.camera.begin();
        defer plr.camera.end();

        rl.drawCube(.{ .x = 0, .y = 0, .z = 0 }, 2, 2, 2, rl.Color.red);
        rl.drawGrid(32, 1);
    }

    rl.drawFPS(0, 0);
}
