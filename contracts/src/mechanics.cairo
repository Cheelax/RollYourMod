use ryo_pvp::{
    models::{
        hustler::{Hustler, HustlerState, TwoHustlers, TwoHustlersState}, game::{Move, TwoMoves}
    },
};

fn run_round(
    hustlers: TwoHustlers, states: TwoHustlersState, moves: TwoMoves
) -> TwoHustlersState {}

fn check_move_valid(hustler: Hustler, state: HustlerState, move: Move) {
    let mut moves = 0;
    if move.position != state.position {
        moves += 1;
    }
    if move.drugs.is_non_zero() {
        moves += 1;
    }
    if move.attack != move.position {
        moves += 1;
    }
    assert(moves == 1, 'Only one move per go');
    if move.position != state.position {
        assert_run_valid(hustler, state, move);
    } else if move.drugs.is_non_zero() {
        assert_attack_valid(hustler, state, move);
    } else if move.attack != move.position {
        assert_drugs_valid(hustler, state, move);
    }
}


fn update_state() {
    if move.position != state.position {
        assert_run_valid(hustler, state, move);
    } else if move.drugs.is_non_zero() {
        assert_attack_valid(hustler, state, move);
    } else if move.attack != move.position {
        assert_drugs_valid(hustler, state, move);
    }
}
fn take_drugs(hustler: Hustler, ref state: HustlerState, move: Move) {}

fn assert_run_valid(hustler: Hustler, state: HustlerState, move: Move) {}
fn assert_attack_valid(hustler: Hustler, state: HustlerState, move: Move) {}
fn assert_drugs_valid(hustler: Hustler, state: HustlerState, move: Move) {}
