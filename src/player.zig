const rl = @import("raylib");

const consts = @import("constants.zig");

pub const Player = struct {
    velocity: rl.Vector3,
    gravity: rl.Vector3,
    camera: rl.Camera3D,
    hitbox: rl.Vector3 = rl.Vector3{ .x = 1, .y = 2, .z = 1 },

    pub fn init(vel: rl.Vector3, grav: rl.Vector3, cam: rl.Camera3D) Player {
        return Player{
            .velocity = vel,
            .gravity = grav,
            .camera = cam,
        };
    }

    pub fn onGround(self: *Player) bool {
        return self.camera.position.y - self.hitbox.y <= 0;
    }

    pub fn update(self: *Player, dt: f32) void {
        self.velocity = self.velocity.add(self.gravity.scale(dt));
        if (onGround(self)) {
            self.velocity.y = 0;
        } else {}

        const velocity_scaled = self.velocity.scale(dt);

        self.camera.position = self.camera.position.add(velocity_scaled);
        self.camera.target = self.camera.target.add(velocity_scaled);
    }
};
