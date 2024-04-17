use starknet::ContractAddress;
use ryo_pvp::models::{
    utils::{TwoZero, AB, TwoTrait}, game::{Drugs}, map::{get_start_position, Vec2},
    commits::HashTrait, items::Items,
};

#[derive(Model, Copy, Drop, Serde)]
struct Hustler {
    #[key]
    game_id: u128,
    #[key]
    hustler_id: u128,
    items: Items,
    drugs: felt252,
    revealed: bool,
}

#[derive(Model, Copy, Drop, Serde)]
struct HustlerState {
    #[key]
    game_id: u128,
    #[key]
    hustler_id: u128,
    position: Vec2,
    health: u8,
    system: Drugs,
    consumed: Drugs,
}

#[generate_trait]
impl HustlerStateImpl of HashStateTrait {
    fn create(game_id: u128, hustler_id: u128, player: AB) -> HustlerState {
        HustlerState {
            game_id,
            hustler_id,
            position: get_start_position(player),
            health: 255,
            system: Zeroable::<Drugs>::zero(),
            consumed: Zeroable::<Drugs>::zero(),
        }
    }
}

impl HustlerHashImpl of HashTrait<Hustler> {
    fn get_hash(self: Hustler, salt: felt252) -> felt252 {
        '12'
    }
}

struct TwoHustlers {
    a: Hustler,
    b: Hustler,
}

impl TwoHustlerImpl of TwoTrait<TwoHustlers, Hustler> {
    fn create(a: Hustler, b: Hustler) -> TwoHustlers {
        TwoHustlers { a, b }
    }
    fn has_init(self: TwoHustlers, hustler_id: u128) -> bool {
        self.get::<Hustler>(hustler_id).revealed
    }
    fn both_init(self: TwoHustlers) -> bool {
        self.a.revealed && self.b.revealed
    }
    fn get<Hustler>(self: TwoHustlers, hustler_id: u128) -> Hustler {
        if hustler_id == self.a.hustler_id {
            return self.a;
        }
        if hustler_id == self.b.hustler_id {
            return self.b;
        }
        panic!("Hustler not in game")
    }
    fn set(ref self: TwoHustlers, obj: Hustler) {
        if obj.hustler_id == self.a.hustler_id {
            self.a = obj;
        }
        if obj.hustler_id == self.b.hustler_id {
            self.b = obj;
        }
        panic!("Move not in game")
    }
}


struct TwoHustlersState {
    a: Hustler,
    b: Hustler,
}
