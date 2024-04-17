use ryo_pvp::models::hustler::HustlerTrait;
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use starknet::{ContractAddress, get_caller_address};
use ryo_pvp::{models::{game::{TwoPlayerGame, Move}, hustler::{Hustler, TwoHustlers, HustlerState, HashStateTrait}, utils::{AB}, commits::{CommitHash, HashTrait, CommitHashTrait, TwoCommits, TwoCommitsTrait}}};

type World = IWorldDispatcher;


#[derive(Copy, Drop, Print)]

struct Game {
    world: World,
    game_id: u128,
    player_a: ContractAddress,
    player_b: ContractAddress,
    hustler_a: u128, 
    hustler_b: u128,
}


fn assert_two_hash(commit_a: CommitHash, commit_b:CommitHash){
    assert(commit_a.hash.is_non_zero() && commit_b.hash.is_non_zero(), 'Missing Commit')
};
#[generate_trait]
impl GameImpl of GameTrait {
    fn new(
        self: World,
        player_a: ContractAddress,
        player_b: ContractAddress,
    ) -> u128 {
        let game_id = uuid(self);
        let hustler_a = uuid(self);
        let hustler_b = uuid(self);
        let game = TwoPlayerGame { game_id, player_a, player_b, hustler_a, hustler_b };
        
        set!(self, (
            game, 
            HashStateTrait::create(game_id, hustler_a, AB::A),
            HashStateTrait::create(game_id, hustler_b, AB::B),
        ));
        game_id
    }

    fn create(self: World, game_id: u128) -> Game {
        let model: TwoPlayerGame = get!(world, game_id, TwoPlayerGame);
        Game {
            world: self,
            game_id,
            player_a: model.player_a,
            player_b: model.player_b,
            hustler_a: model.hustler_a,
            hustler_b: model.hustler_b,
        }

    }
    fn get_hustlers(self: Game) -> TwoHustlers{
        (get!(self.world, (self.game_id, self.hustler_a), Hustler), get!(self.world, (self.game_id, self.hustler_b), Hustler))
    }
    fn get_hustler(self: Game, huster_id: u128)-> Hustler{
        get!(self.world, (self.game_id, hustler_id), Huslter)

    }
    fn get_player_hustler(self: Game, hustler_id: u128)-> Hustler{
        let caller = get_caller_address();
        let hustler = self.get_hustler(hustler_id);
        assert(hustler.is_owner(caller), 'Not player');
        hustler
    }
    fn get_other_hustler_id(self:Game, hustler_id: u128)-> u128{
        if hustler_id == self.hustler_a{
            return self.hustler_b;
        }
        if hustler_id == self.hustler_b{
            return self.hustler_a;
        }
        panic!("Hustler not in game")
    }
    fn get_player(self:Game, hustler_id: u128)-> ContractAddress{
        if hustler_id == self.hustler_a{
            return self.player_a;
        }
        if hustler_id == self.hustler_b{
            return self.player_b;
        }
        panic!("Hustler not in game")
    }
    // fn get_player_ab(self: Game, hustler_id: u128)-> AB{
    //     if hustler_id == self.hustler_a{
    //         return AB::A;
    //     }
    //     if hustler_id == self.hustler_b{
    //         return AB::B;
    //     }
    //     panic!("Hustler not in game");
    //     AB::A
    // }
    // fn get_hustler_id(self: Game, player: AB)->u128{
    //     match player{
    //         AB::A => self.hustler_a,
    //         AB::B => self.hustler_b,
    //     }
    // }
    fn get_commit_hash(self: Game, hustler_id: u128)-> CommitHash{
        get!(self.world, (self.game_id, hustler_id), CommitHash)
    } 
    fn get_commits(self: Game) -> TwoCommits{
        let commits = TwoCommits{
            a: get!(self.world, (self.game_id, self.hustler_a)),
            b: get!(self.world, (self.game_id, self.hustler_b)),
        };
        assert(commits.is_non_zero(), 'Commit missing');
        commits
    }
    fn assert_two_hash(self: Game){
        let (commit_a, commit_b) = self.get_commits();
        assert_two_hash(commit_a, commit_b);
    }
    fn commit_hash(self: Game, hustler_id: u128, hash: felt252){
        let mut commit: CommitHash = self.get_commit_hash(hustler_id);
        assert(commit.hash.is_non_zero(), 'Already committed');
        let commit = CommitHash{
            game_id: self.game_id,
            hustler_id,
            hash,
        };
        set!(self.world, (commit,));
    }
    fn commit_hustler(self: Game, hustler_id: u128, hash: felt252) {
        let player = self.get_player(hustler_id);
        assert(player == get_caller_address(), 'Not player');
        let hustler: Hustler = self.get_hustler(hustler_id);
        assert(!hustler.has_init(), 'Hustler already revealed');
        self.commit_hash(hustler_id, hash);
    }
    fn reveal_hustler(self: Game, hustler: Hustler, salt: felt252) {
        let commits = self.get_commits();

        let _hustler = self.get_hustler(hustler.hustler_id);
        assert(_hustler.player_id.is_zero(), 'All ready revealed');
        set!(self.world, (hustler));
        let other_hustler = self.get_hustler(self.get_other_hustler_id(hustler.hustler_id));
        if other_hustler.player_id.is_non_zero(){
            self.reset_hashes();
        }
    }
    fn commit_move(self: Game, hustler_id: u128, hash: felt252) {
        let (mut commit_a, mut commit_b) = self.get_commits();
        assert_two_hash(commit_a, commit_b);
        self.commit_hash(hustler_id, hash);

    }
    fn reveal_move(self: Game, move: Move, salt: felt252) {
        let commits = self.get_commits();
        
        let hash = self.get_commit_hash(move.hustler_id);
        assert(hash.check_hash(move, salt), 'Hash does not match');
        set!(self.world, (move, ));
    }
    fn reset_hashes(self:Game){
        set!(self.world, (
            CommitHash{
                game_id: self.game_id,
                hustler_id: self.hustler_a,
                hash: 0,
            },
            CommitHash{
                game_id: self.game_id,
                hustler_id: self.hustler_b,
                hash: 0,
            }
        ));
    }
}
