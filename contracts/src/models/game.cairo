use starknet::{ContractAddress};
use ryo_pvp::models::{drugs::Drugs, commits::HashTrait, map::Vec2, utils::TwoTrait};

#[derive(Model, Copy, Drop, Serde, SerdeLen)]
struct TwoPlayerGame {
    #[key]
    game_id: u128,
    player_a: ContractAddress,
    player_b: ContractAddress,
    hustler_a: u128,
    hustler_b: u128,
}

#[derive(Model, Copy, Drop, Serde, SerdeLen)]
struct Move {
    #[key]
    game_id: u128,
    #[key]
    hustler_id: u128,
    position: Vec2,
    drugs: Drugs,
    attack: Vec2,
    revealed: bool,
}

impl MoveHashImpl of HashTrait<Move> {
    fn hash(self: Move, salt: felt252) -> felt252 {
        '12'
    }
}

#[derive(Copy, Drop, Serde)]
struct TwoMoves {
    a: Move,
    b: Move,
}

impl TwoMoveImpl of TwoTrait<TwoMoves, Move> {
    fn create(a: Move, b: Move) -> TwoMoves {
        TwoMoves { a, b }
    }
    fn has_init(self: TwoMoves, hustler_id: u128) -> bool {
        let move: Move = self.get(hustler_id);
        move.revealed
    }
    fn both_init(self: TwoMoves) -> bool {
        self.a.revealed && self.b.revealed
    }
    fn get(self: TwoMoves, hustler_id: u128) -> Move {
        if hustler_id == self.a.hustler_id {
            return self.a;
        }
        if hustler_id == self.b.hustler_id {
            return self.b;
        }
        panic!("Move not in game")
    }
    fn set(ref self: TwoMoves, obj: Move) {
        if obj.hustler_id == self.a.hustler_id {
            self.a = obj;
        }
        if obj.hustler_id == self.b.hustler_id {
            self.b = obj;
        }
    }
}

