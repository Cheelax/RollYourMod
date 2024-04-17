use ryo_pvp::models::{utils::{TwoZero, AB}};
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
    player_a: ContractAddress,
    player_b: ContractAddress,
}

impl TwoCommitsZeroImpl of TwoZero<TwoCommits> {
    fn is_non_zero(self: TwoCommits) -> bool {
        self.a.is_non_zero() && self.b.is_non_zero()
    }
    fn is_zero(self: TwoCommits) -> bool {
        self.a.is_zero() && self.b.is_zero()
    }
}


#[generate_trait]
impl TwoCommitsImpl of TwoCommitsTrait {
    fn create(a: CommitHash, b: CommitHash)
    fn is_non_zero(self: TwoCommits) -> bool {
        self.a.is_non_zero() && self.b.is_non_zero()
    }
    fn get_hash(self: TwoCommits, hustler: AB) -> felt252 {
        match hustler {
            AB::A => self.a,
            AB::B => self.b,
        }
    }
    fn get_hustler_hash(self: TwoCommits, hustler_id: u128) -> felt252 {}
}
