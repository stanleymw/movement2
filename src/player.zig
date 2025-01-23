const rl = @import("raylib");

pub const Player = struct {
    velocity: rl.Vector3,
    gravity: rl.Vector3,
    camera: rl.Camera3D,

    pub fn init(vel: rl.Vector3, grav: rl.Vector3, cam: rl.Camera3D) Player {
        return Player{
            .velocity = vel,
            .gravity = grav,
            .camera = cam,
        };
    }

    pub fn update(self: *Player, dt: f32) void {
        self.velocity = self.velocity.add(self.gravity.scale(dt));

        const velocity_scaled = self.velocity.scale(dt);

        self.camera.position = self.camera.position.add(velocity_scaled);
        self.camera.target = self.camera.target.add(velocity_scaled);
    }
};
