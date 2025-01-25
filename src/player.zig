const rl = @import("raylib");
const std = @import("std");

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

    pub fn update(self: *Player, user_command: rl.Vector2, dt: f32) void {
        self.velocity = self.velocity.add(self.gravity.scale(dt));

        var forward = rl.getCameraForward(&self.camera);
        var right = rl.getCameraRight(&self.camera);

        forward.y = 0;
        right.y = 0;
        forward = forward.normalize();
        right = right.normalize();

        var wish_vel = rl.Vector3{
            .x = forward.x * user_command.x + right.x * user_command.y,
            .y = 0,
            .z = forward.z * user_command.x + right.z * user_command.y,
        };
        const wish_dir = wish_vel.normalize();
        const wish_speed = @min(wish_vel.length(), consts.max_speed);

        if (onGround(self)) {
            if (rl.isKeyDown(.space) or rl.getMouseWheelMove() != 0) {
                self.velocity.y = 6;
            } else {
                self.velocity.y = 0;

                self.groundFriction(dt);
                self.groundAccelerate(
                    wish_dir,
                    wish_speed,
                    dt,
                );
            }
        } else {
            self.airAccelerate(
                wish_dir,
                wish_speed,
                dt,
            );
        }

        const velocity_scaled = self.velocity.scale(dt);

        self.camera.position = self.camera.position.add(velocity_scaled);
        self.camera.target = self.camera.target.add(velocity_scaled);
    }

    fn airAccelerate(self: *Player, wish_direction: rl.Vector3, wish_speed: f32, dt: f32) void {
        const cap_speed = @min(consts.air_speed_cap, wish_speed);

        const current_speed = self.velocity.dotProduct(wish_direction);
        const add_speed = cap_speed - current_speed;
        if (add_speed <= 0) {
            return;
        }

        const accel_speed = @min(consts.air_accelerate * wish_speed * dt, add_speed);
        self.velocity.x += wish_direction.x * accel_speed;
        self.velocity.y += wish_direction.y * accel_speed;
        self.velocity.z += wish_direction.z * accel_speed;
    }

    fn groundAccelerate(self: *Player, wish_direction: rl.Vector3, wish_speed: f32, dt: f32) void {
        const current_speed = self.velocity.dotProduct(wish_direction);
        const add_speed = wish_speed - current_speed;
        if (add_speed <= 0) {
            return;
        }

        const accel_speed = @min(consts.accelerate * wish_speed * dt, add_speed);

        self.velocity.x += wish_direction.x * accel_speed;
        self.velocity.y += wish_direction.y * accel_speed;
        self.velocity.z += wish_direction.z * accel_speed;
    }

    fn groundFriction(self: *Player, dt: f32) void {
        const speed: f32 = @sqrt(self.velocity.x * self.velocity.x + self.velocity.z * self.velocity.z);
        if (speed == 0) {
            return;
        }

        const control: f32 = @max(consts.stop_speed, speed);
        var new_speed: f32 = speed - (dt * control * consts.friction);

        if (new_speed < 0) {
            new_speed = 0;
        }
        new_speed /= speed;

        self.velocity.x *= new_speed;
        self.velocity.y *= new_speed;
        self.velocity.z *= new_speed;
    }

    pub fn rotateCamera(self: *Player, mouse_delta: rl.Vector2) void {
        rl.cameraYaw(&self.camera, mouse_delta.x * -(0.0009765625), false);
        rl.cameraPitch(&self.camera, mouse_delta.y * -(0.0009765625), true, false, false);
    }
};
