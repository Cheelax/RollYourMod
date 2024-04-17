use ryo_pvp::models::utils::AB;

#[derive(Copy, Drop, Serde, Introspect)]
struct Vec2 {
    x: u32,
    y: u32
}

trait Vec2Trait {
    fn is_zero(self: Vec2) -> bool;
    fn is_equal(self: Vec2, b: Vec2) -> bool;
}

impl Vec2Impl of Vec2Trait {
    fn is_zero(self: Vec2) -> bool {
        if self.x - self.y == 0 {
            return true;
        }
        false
    }

    fn is_equal(self: Vec2, b: Vec2) -> bool {
        self.x == b.x && self.y == b.y
    }
}


impl Vec2PartialEqImpl of PartialEq<Vec2> {
    fn eq(lhs: @Vec2, rhs: @Vec2) -> bool {
        lhs.x == rhs.x && lhs.y == rhs.y
    }
    fn ne(lhs: @Vec2, rhs: @Vec2) -> bool {
        !(lhs == rhs)
    }
}


fn get_start_position(player: AB) -> Vec2 {
    match player {
        AB::A => Vec2 { x: 0, y: 0 },
        AB::B => Vec2 { x: 10, y: 10 },
    }
}

