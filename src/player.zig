const rl = @import("raylib");

pub const Player = struct {
    position: rl.Vector3,
    velocity: rl.Vector3,
    gravity: rl.Vector3,

    pub fn init(pos: rl.Vector3, vel: rl.Vector3, grav: rl.Vector3) Player {
        return Player{ .position = pos, .velocity = vel, .gravity = grav };
    }

    pub fn update(self: *Player, dt: f32) void {
        self.velocity = self.velocity.add(self.gravity.scale(dt));
        self.position = self.position.add(self.gravity.scale(dt));
    }
};
