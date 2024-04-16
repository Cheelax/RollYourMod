#[derive(Model, Copy, Drop, Print, Serde, SerdeLen)]
struct CommitHash {
    #[key]
    game_id: u128,
    #[key]
    player_id: u128,
    hash: felt252,
}
