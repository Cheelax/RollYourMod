use core::traits::Into;
use starknet::{ContractAddress};
use ryo_pvp::models::{drugs::Drugs, commits::HashTrait, map::Vec2, utils::TwoTrait};
use core::pedersen::pedersen;

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
        let base_pedersen = pedersen(self.position.x.into(), self.position.y.into());
        let shrooms_pedersen = pedersen(base_pedersen, self.drugs.shrooms.into());
        let cocaine_pedersen = pedersen(shrooms_pedersen, self.drugs.cocaine.into());
        let ketamine_pedersen = pedersen(cocaine_pedersen, self.drugs.ketamine.into());
        let speed_pedersen = pedersen(ketamine_pedersen, self.drugs.speed.into());
        let attack_x_pedersen = pedersen(speed_pedersen, self.attack.x.into());
        let attack_y_pedersen = pedersen(attack_x_pedersen, self.attack.y.into());
        pedersen(salt.into(), attack_y_pedersen.into())
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

