use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use starknet::{ContractAddress, get_caller_address};
use ryo_pvp::{models::{game::{TwoPlayerGame}, hustler::Hustler}};

type World = IWorldDispatcher;

struct Game {
    world: World,
    game_id: u128,
    player_a: ContractAddress,
    player_b: ContractAddress,
    hustler_a: u128, 
    hustler_b: u128,
}


#[generate_trait]
impl GameImpl of GameTrait {
    fn new(
        world: World,
        player_a: ContractAddress,
        player_b: ContractAddress,
    ) -> u128 {
        let game_id = uuid(world);
        let hustler_a = uuid(world);
        let hustler_b = uuid(world);
        let game = TwoPlayerGame { game_id, player_a, player_b, hustler_a, hustler_b };
        
        set!(world, (game));
        game_id
    }

    fn create(world: World, game_id: u128) -> Game {
        let model: TwoPlayerGame = get!(world, game_id, TwoPlayerGame);
        Game {
            world,
            game_id,
            player_a: model.player_a,
            player_b: model.player_b,
            hustler_a: model.hustler_a,
            hustler_b: model.hustler_b,
        }
    }
    fn get_hustlers(self: Game) -> (Hustler, Hustler){
        (get!(world, (self.game_id, self.hustler_a), Hustler), get!(world, (self.game_id, self.hustler_b), Hustler))
    }