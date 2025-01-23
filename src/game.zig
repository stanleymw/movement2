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

const CAMERA_SPEED = 8;

pub fn cameraMove(cam: *rl.Camera, delta: rl.Vector3) void {
    camera.position = cam.position.add(delta);
    camera.target = cam.target.add(delta);
}

pub fn update(dt: f32) void {
    plr.update(dt);
    // camera.update(.first_person);
    const delta = rl.getMouseDelta();

    // const vel = plr.velocity.scale(dt);

    var dx: f32 = 0;
    var dz: f32 = 0;

    if (rl.isKeyDown(.w)) {
        dz -= dt;
    }
    if (rl.isKeyDown(.a)) {
        dx -= dt;
    }
    if (rl.isKeyDown(.s)) {
        dz += dt;
    }
    if (rl.isKeyDown(.d)) {
        dx += dt;
    }

    cameraMove(&camera, rl.Vector3{ .x = dx, .y = 0, .z = dz });

    rl.cameraYaw(&camera, -0.2 * delta.x * dt, false);
    rl.cameraPitch(&camera, -0.2 * delta.y * dt, true, false, false);
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
