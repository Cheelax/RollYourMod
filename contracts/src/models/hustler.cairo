use starknet::ContractAddress;
use ryo_pvp::models::{
    utils::{TwoZero, AB}, game::{Drugs}, map::{get_start_position, Vec2}, commits::HashTrait
};

#[derive(Model, Copy, Drop, Serde)]
struct Hustler {
    #[key]
    game_id: u128,
    #[key]
    hustler_id: u128,
    player_id: ContractAddress,
    weapon: u8,
    clothes: u8,
    speed: u8,
    bag: u8,
    drugs: felt252,
}

#[derive(Model, Copy, Drop, Serde)]
struct HustlerState {
    #[key]
    game_id: u128,
    #[key]
    hustler_id: u128,
    position: Vec2,
    health: u8,
    drugs: Drugs,
}

#[generate_trait]
impl HustlerStateImpl of HashStateTrait {
    fn create(game_id: u128, hustler_id: u128, player: AB) -> HustlerState {
        HustlerState {
            game_id,
            hustler_id,
            position: get_start_position(player),
            health: 255,
            drugs: Zeroable::<Drugs>::zero(),
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


#[generate_trait]
impl HustlerImpl of HustlerTrait {
    fn has_init(self: Hustler) -> bool {
        self.player_id.is_zero()
    }
    fn is_owner(self: Hustler, owner: ContractAddress) -> bool {
        self.player_id == owner
    }
}

impl TwoHustlersZeroImpl of TwoZero<TwoHustlers> {
    fn is_zero(self: TwoHustlers) -> bool {
        self.a.player_id.is_zero() && self.b.player_id.is_zero()
    }
    fn is_non_zero(self: TwoHustlers) -> bool {
        self.a.player_id.is_non_zero() && self.b.player_id.is_non_zero()
    }
}
