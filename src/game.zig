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
    const delta = rl.getMouseDelta();
    rl.cameraYaw(&plr.camera, delta.x * -0.25 * dt, false);
    rl.cameraPitch(&plr.camera, delta.y * -0.25 * dt, true, false, false);

    var forward = rl.getCameraForward(&plr.camera);
    var right = rl.getCameraRight(&plr.camera);
    right.y = 0;
    forward.y = 0;
    forward = forward.normalize();
    right = right.normalize();

    var dx: f32 = 0;
    var dz: f32 = 0;

    if (rl.isKeyDown(.w)) {
        dx += 8;
    }
    if (rl.isKeyDown(.a)) {
        dz -= 8;
    }
    if (rl.isKeyDown(.s)) {
        dx -= 8;
    }
    if (rl.isKeyDown(.d)) {
        dz += 8;
    }

    // update player and camera
    plr.velocity.x = forward.x * dx + right.x * dz;
    plr.velocity.z = forward.z * dx + right.z * dz;
    plr.update(dt);
    // fwd.y = 0;
    // std.debug.print("fwd: {}\n", .{fwd});
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
