use core::traits::Into;
use starknet::ContractAddress;
use ryo_pvp::models::{
    utils::{AB, TwoTrait}, game::{Drugs}, map::{get_start_position, Vec2}, commits::HashTrait,
    hustler_items::HustlerItems,
};
use core::pedersen::pedersen;

#[derive(Model, Copy, Drop, Serde)]
struct Hustler {
    #[key]
    game_id: u128,
    #[key]
    hustler_id: u128,
    items: HustlerItems,
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
impl HustlerStateImpl of HustlerStateTrait {
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
    fn hash(self: Hustler, salt: felt252) -> felt252 {
        let base_pedersen = pedersen(self.items.weapon.into(), self.items.clothes.into());
        let shoe_pedersen = pedersen(base_pedersen, self.items.shoes.into());
        let bag_pedersen = pedersen(shoe_pedersen, self.items.bag.into());
        let final_pedersen = pedersen(bag_pedersen, self.drugs.into());
        pedersen(salt.into(), final_pedersen.into());
    }
}

#[derive(Copy, Drop)]
struct TwoHustlers {
    a: Hustler,
    b: Hustler,
}

impl TwoHustlerImpl of TwoTrait<TwoHustlers, Hustler> {
    fn create(a: Hustler, b: Hustler) -> TwoHustlers {
        TwoHustlers { a, b }
    }
    fn has_init(self: TwoHustlers, hustler_id: u128) -> bool {
        let hustler: Hustler = self.get(hustler_id);
        hustler.revealed
    }
    fn both_init(self: TwoHustlers) -> bool {
        self.a.revealed && self.b.revealed
    }
    fn get(self: TwoHustlers, hustler_id: u128) -> Hustler {
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
    }
}

#[derive(Copy, Drop, Serde)]
struct TwoHustlersState {
    a: HustlerState,
    b: HustlerState,
}

