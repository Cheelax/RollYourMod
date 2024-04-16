use ryo_pvp::models::{hustler::Drugs};

#[derive(Model, Copy, Drop, Serde)]
struct Move {
    #[key]
    game_id: u128,
    #[key]
    hustler_id: u128,
    position: Vec2,
    drugs: Drugs,
    attack: bool,
    revealed: bool,
}


#[derive(Model, Copy, Drop, Serde)]
struct DrugConsumption {
    #[key]
    game_id: u128,
    #[key]
    hustler_id: u128,
    drugs: Drugs,
}

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

