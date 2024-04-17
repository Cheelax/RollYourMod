use ryo_pvp::models::{utils::{TwoZero, TwoTrait}};
use starknet::ContractAddress;

#[derive(Model, Copy, Drop, Print, Serde, SerdeLen)]
struct CommitHash {
    #[key]
    game_id: u128,
    #[key]
    hustler_id: u128,
    hash: felt252,
}
#[generate_trait]
impl CommitHashImpl of CommitHashTrait {
    fn check_hash<T, +HashTrait<T>>(self: CommitHash, other: T, salt: felt252) -> bool {
        other.get_hash(salt) == self.hash
    }
}


trait HashTrait<T> {
    fn get_hash(self: T, salt: felt252) -> felt252;
}
#[derive(Copy, Drop, Print)]
struct TwoCommits {
    a: felt252,
    b: felt252,
    hustler_a: u128,
    hustler_b: u128,
}

impl TwoCommitsZeroImpl of TwoZero<TwoCommits> {
    fn is_non_zero(self: TwoCommits) -> bool {
        self.a.is_non_zero() && self.b.is_non_zero()
    }
    fn is_zero(self: TwoCommits) -> bool {
        self.a.is_zero() && self.b.is_zero()
    }
}


impl TwoCommitsImpl of TwoTrait<TwoCommits, CommitHash> {
    fn create(a: CommitHash, b: CommitHash) -> TwoCommits {
        TwoCommits { a: a.hash, b: b.hash, hustler_a: a.hustler_id, hustler_b: b.hustler_id, }
    }
    fn has_init(self: TwoCommits, hustler_id: u128) -> bool {
        self.get::<felt252>(hustler_id).is_non_zero()
    }
    fn both_init(self: TwoCommits) -> bool {
        self.a.is_non_zero() && self.b.is_non_zero()
    }
    fn get<felt252>(self: TwoCommits, hustler_id: u128) -> felt252 {
        if hustler_id == self.hustler_a {
            return self.a;
        }
        if hustler_id == self.hustler_b {
            return self.b;
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
