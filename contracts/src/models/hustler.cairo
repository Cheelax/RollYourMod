use starknet::ContractAddress;

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
