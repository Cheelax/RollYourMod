use ryo_pvp::models::{utils::{TwoTrait}};
use starknet::ContractAddress;

#[derive(Model, Copy, Drop, Print, Serde, SerdeLen)]
struct CommitHash {
    #[key]
    game_id: u128,
    #[key]
    hustler_id: u128,
    hash: felt252,
}

trait HashTrait<T> {
    fn hash(self: T, salt: felt252) -> felt252;
}

#[derive(Copy, Drop, Print)]
struct TwoCommits {
    game_id: u128,
    a: felt252,
    b: felt252,
    hustler_a: u128,
    hustler_b: u128,
}


impl TwoCommitsImpl of TwoTrait<TwoCommits, CommitHash> {
    fn create(a: CommitHash, b: CommitHash) -> TwoCommits {
        TwoCommits {
            game_id: a.game_id,
            a: a.hash,
            b: b.hash,
            hustler_a: a.hustler_id,
            hustler_b: b.hustler_id,
        }
    }
    fn has_init(self: TwoCommits, hustler_id: u128) -> bool {
        let commit: CommitHash = self.get(hustler_id);
        commit.hash.is_non_zero()
    }
    fn both_init(self: TwoCommits) -> bool {
        self.a.is_non_zero() && self.b.is_non_zero()
    }
    fn get(self: TwoCommits, hustler_id: u128) -> CommitHash {
        if hustler_id == self.hustler_a {
            return CommitHash { game_id: self.game_id, hustler_id: self.hustler_a, hash: self.a };
        }
        if hustler_id == self.hustler_b {
            return CommitHash { game_id: self.game_id, hustler_id: self.hustler_b, hash: self.b };
        }
        panic!("Hustler not in game")
    }
    fn set(ref self: TwoCommits, obj: CommitHash) {
        if obj.hustler_id == self.hustler_a {
            self.a = obj.hash;
        }
        if obj.hustler_id == self.hustler_b {
            self.b = obj.hash;
        }
    }
}

