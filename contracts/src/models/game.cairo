use starknet::{ContractAddress};
use ryo_pvp::models::{drugs::Drugs, utils::HashTrait};

#[derive(Model, Copy, Drop, Serde)]
struct TwoPlayerGame {
    #[key]
    game_id: u128,
    player_a: ContractAddress,
    player_b: ContractAddress,
    hustler_a: u128,
    hustler_b: u128,
}


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

impl MoveHashImpl of HashTrait<Move> {
    fn get_hash(self: Move, salt: felt252) -> felt252 {
        '12'
    }
}

