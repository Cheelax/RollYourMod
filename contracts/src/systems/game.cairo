use ryo_pvp::models::utils::TwoZero;
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use starknet::{ContractAddress, get_caller_address};
use ryo_pvp::{
    models::{
        game::{TwoPlayerGame, Move, TwoMoves},
        hustler::{Hustler, TwoHustlers, HustlerState, TwoHustlersState, HustlerStateTrait},
        utils::{AB, TwoTrait}, commits::{CommitHash, HashTrait, TwoCommits}, map::Vec2, drugs::Drugs
    },
    mechanics::run_round
};

type World = IWorldDispatcher;

#[event]
#[derive(Drop, starknet::Event)]
enum Event {
    PlayersMoved: PlayersMoved,
    HustlerRevealed: HustlerRevealed,
}

#[derive(Drop, Serde, starknet::Event)]
struct PlayersMoved {
    a: Move,
    b: Move,
}

#[derive(Drop, Serde, starknet::Event)]
struct HustlerRevealed {
    hustler: Hustler,
}

#[derive(Copy, Drop, Print)]
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
    fn new(self: IWorldDispatcher, player_a: ContractAddress, player_b: ContractAddress,) -> u128 {
        let game_id: u128 = self.uuid().into();
        let hustler_a: u128 = self.uuid().into();
        let hustler_b: u128 = self.uuid().into();
        let game = TwoPlayerGame { game_id, player_a, player_b, hustler_a, hustler_b };
        set!(
            self,
            (
                game,
                HustlerStateTrait::create(game_id, hustler_a, AB::A),
                HustlerStateTrait::create(game_id, hustler_b, AB::B),
            )
        );
        game_id
    }

    fn create(self: World, game_id: u128) -> Game {
        let model: TwoPlayerGame = get!(self, game_id, TwoPlayerGame);
        Game {
            world: self,
            game_id,
            player_a: model.player_a,
            player_b: model.player_b,
            hustler_a: model.hustler_a,
            hustler_b: model.hustler_b,
        }
    }
    fn get_hustlers(self: Game) -> TwoHustlers {
        TwoTrait::<
            TwoHustlers, Hustler
        >::create(self.get_hustler(self.hustler_a), self.get_hustler(self.hustler_b),)
    }
    fn get_state(self: Game, hustler_id: u128) -> HustlerState {
        get!(self.world, (self.game_id, hustler_id), HustlerState)
    }
    fn get_states(self: Game) -> TwoHustlersState {
        TwoHustlersState { a: self.get_state(self.hustler_a), b: self.get_state(self.hustler_b), }
    }
    fn get_hustler(self: Game, hustler_id: u128) -> Hustler {
        get!(self.world, (self.game_id, hustler_id), Hustler)
    }
    fn get_move(self: Game, hustler_id: u128) -> Move {
        get!(self.world, (self.game_id, hustler_id), Move)
    }
    fn get_moves(self: Game) -> TwoMoves {
        TwoTrait::create(self.get_move(self.hustler_a), self.get_move(self.hustler_b))
    }
    fn get_player_hustler(self: Game, hustler_id: u128) -> Hustler {
        let caller = get_caller_address();
        let hustler = self.get_hustler(hustler_id);
        let player = self.get_player(hustler_id);
        assert(caller == player, 'Not player');
        hustler
    }
    fn get_other_hustler_id(self: Game, hustler_id: u128) -> u128 {
        if hustler_id == self.hustler_a {
            return self.hustler_b;
        }
        if hustler_id == self.hustler_b {
            return self.hustler_a;
        }
        // panic!("Hustler not in game")
        return self.hustler_a;
    }
    fn get_player(self: Game, hustler_id: u128) -> ContractAddress {
        if hustler_id == self.hustler_a {
            return self.player_a;
        }
        if hustler_id == self.hustler_b {
            return self.player_b;
        }
        // panic!("Hustler not in game")
        return self.player_b;
    }
    fn get_commit_hash(self: Game, hustler_id: u128) -> CommitHash {
        get!(self.world, (self.game_id, hustler_id), CommitHash)
    }
    fn get_commits(self: Game) -> TwoCommits {
        let commits: TwoCommits = TwoTrait::create(
            get!(self.world, (self.game_id, self.hustler_a), CommitHash),
            get!(self.world, (self.game_id, self.hustler_b), CommitHash)
        );
        assert(commits.both_init(), 'Commit missing');
        commits
    }
    fn commit_hash(self: Game, hustler_id: u128, hash: felt252) {
        let mut commit: CommitHash = self.get_commit_hash(hustler_id);
        let player = self.get_player(hustler_id);
        assert(commit.hash.is_non_zero(), 'Already committed');
        assert(player == get_caller_address(), 'Not owner');
        commit.hash = hash;
        set!(self.world, (commit,));
    }
    fn commit_hustler(self: Game, hustler_id: u128, hash: felt252) {
        let hustler: Hustler = self.get_hustler(hustler_id);
        assert(!hustler.revealed, 'Hustler already revealed');
        self.commit_hash(hustler_id, hash);
    }
    fn reveal_hustler(self: Game, hustler: Hustler, salt: felt252) {
        let commits = self.get_commits();
        let commit = commits.get(hustler.hustler_id);
        let hustlers = self.get_hustlers();
        // commits.is_non_zero()
        assert(hustlers.has_init(hustler.hustler_id), 'All ready revealed');
        assert(hustler.hash(salt) == commit.hash, 'Hash dose not match');
        set!(self.world, (hustler,));
        emit!(self.world, HustlerRevealed { hustler });

        if hustlers.has_init(self.get_other_hustler_id(hustler.hustler_id)) {
            self.reset_hashes();
        }
    }
    fn commit_move(self: Game, hustler_id: u128, hash: felt252) {
        let hustlers = self.get_hustlers();
        assert(hustlers.both_init(), 'Hustlers not revealed');
        self.commit_hash(hustler_id, hash);
    }
    fn reveal_move(self: Game, move: Move, salt: felt252) {
        let commits = self.get_commits();
        let commit = commits.get(move.hustler_id);

        let mut moves = self.get_moves();

        assert(!(moves.has_init(move.hustler_id)), 'All ready revealed');
        assert(move.hash(salt) == commit.hash, 'Hash dose not match');

        let mut other_move = self.get_move(self.get_other_hustler_id(move.hustler_id));
        if other_move.revealed {
            moves.set(move);
            self.reset_hashes();
            let states = run_round(self.get_hustlers(), self.get_states(), moves);
            other_move.revealed = false;
            set!(self.world, (other_move, states.a, states.b));
            emit!(self.world, PlayersMoved { a: moves.a, b: moves.b });
            self.reset_hashes();
        } else {
            set!(self.world, (move,));
        }
    }

    fn reset_hashes(self: Game) {
        set!(
            self.world,
            (
                CommitHash { game_id: self.game_id, hustler_id: self.hustler_a, hash: 0, },
                CommitHash { game_id: self.game_id, hustler_id: self.hustler_b, hash: 0, }
            )
        );
    }
}

