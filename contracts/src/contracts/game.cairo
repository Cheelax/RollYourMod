use starknet::{ContractAddress};
use ryo_pvp::{models::{hustler::{Hustler, Drugs}, game::{Move}}};

#[starknet::interface]
trait IGameActions<TContractState> {
    fn new(self: @TContractState, player_a: ContractAddress, player_b: ContractAddress,) -> u128;
    fn commit_hustler(self: @TContractState, game_id: u128, hustler_id: u128, hash: felt252);
    fn reveal_hustler(self: @TContractState, game_id: u128, hustler: Hustler, salt: felt252);
    fn commit_move(self: @TContractState, game_id: u128, hustler_id: u128, hash: felt252);
    fn reveal_move(self: @TContractState, game_id: u128, move: Move, salt: felt252);
    fn reveal_drugs(
        self: @TContractState, game_id: u128, hustler_id: u128, drugs: Drugs, salt: felt252
    );
}

#[dojo::contract]
mod game_actions {
    use super::IGameActions;
    use starknet::{ContractAddress};

    use ryo_pvp::{
        models::{hustler::{Hustler, Drugs}, game::{Move}}, systems::game::{GameTrait, World}
    };
    #[abi(embed_v0)]
    impl GameActionsImpl of IGameActions<ContractState> {
        fn new(
            self: @ContractState, player_a: ContractAddress, player_b: ContractAddress,
        ) -> u128 {
            let world: World = self.world_dispatcher.read();
            world.new(player_a, player_b)
        }
        fn commit_hustler(self: @ContractState, game_id: u128, hustler_id: u128, hash: felt252) {
            let world: World = self.world_dispatcher.read();
            let game = world.create(game_id);
            GameTrait::commit_hustler(game, hustler_id, hash);
        }
        fn reveal_hustler(self: @ContractState, game_id: u128, hustler: Hustler, salt: felt252) {
            let world: World = self.world_dispatcher.read();
            let game = world.create(game_id);
            GameTrait::reveal_hustler(game, hustler, salt);
        }
        fn commit_move(self: @ContractState, game_id: u128, hustler_id: u128, hash: felt252) {
            let world: World = self.world_dispatcher.read();
            let game = world.create(game_id);
            GameTrait::commit_move(game, hustler_id, hash);
        }
        fn reveal_move(self: @ContractState, game_id: u128, move: Move, salt: felt252) {
            let world: World = self.world_dispatcher.read();
            let game = world.create(game_id);
            GameTrait::reveal_move(game, move, salt);
        }
        fn reveal_drugs(
            self: @ContractState, game_id: u128, hustler_id: u128, drugs: Drugs, salt: felt252
        ) {
            let world: World = self.world_dispatcher.read();
            let game = world.create(game_id);
        }
    }
}

