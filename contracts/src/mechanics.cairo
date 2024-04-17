use core::num::traits::zero::Zero;
use ryo_pvp::{
    models::{
        hustler::{Hustler, HustlerState, TwoHustlers, TwoHustlersState, get_stats, Stats},
        game::{Move, TwoMoves}, map::{Vec2}, drugs::DrugsTrait,
    },
};


fn run_round(hustlers: TwoHustlers, states: TwoHustlersState, moves: TwoMoves) -> TwoHustlersState {
    let (a_type, mut a_state) = get_hustler_new_state(hustlers.a, states.a, moves.a);
    let (b_type, mut b_state) = get_hustler_new_state(hustlers.b, states.b, moves.b);
    if a_state.position == b_state.position {
        if a_type != MoveType::Run {
            b_state.position = states.b.position;
        } else if b_type != MoveType::Run {
            a_state.position = states.a.position;
        } else {
            let a_speed = get_speed(hustlers.a, states.a);
            let b_speed = get_speed(hustlers.b, states.b);
            if a_speed <= b_speed {
                a_state.position = states.a.position;
            }
            if b_speed <= a_speed {
                b_state.position = states.b.position;
            }
        }
    }
    let a_attacked = match a_type {
        MoveType::Attack => check_attack(hustlers.a, hustlers.b, moves.a, b_state.position),
        _ => false
    };
    let b_attacked = match b_type {
        MoveType::Attack => check_attack(hustlers.b, hustlers.a, moves.b, a_state.position),
        _ => false
    };
    if a_attacked && b_attacked {
        let a_defence = get_defence(hustlers.a, states.a);
        let b_defence = get_defence(hustlers.b, states.b);
        if a_defence > b_defence {
            b_state.health = 0;
        } else if a_defence < b_defence {
            a_state.health = 0;
        } else {
            if states.a.system.total() > states.b.system.total() {
                b_state.health = 0;
            } else {
                a_state.health = 0;
            }
        }
    } else if a_attacked {
        b_state.health = 0;
    } else if b_attacked {
        a_state.health = 0;
    }

    TwoHustlersState { a: a_state, b: b_state, }
}

fn check_attack(hustler_a: Hustler, hustler_d: Hustler, a_move: Move, d_position: Vec2) -> bool {
    match hustler_a.items.weapon {
        0 | 1 => { a_move.attack == d_position },
        2 => {
            let dpx: i32 = a_move.position.x.try_into().unwrap() - d_position.x.try_into().unwrap();
            let dpy: i32 = a_move.position.y.try_into().unwrap() - d_position.y.try_into().unwrap();

            let apx: i32 = a_move.position.x.try_into().unwrap()
                - a_move.attack.x.try_into().unwrap();
            let apy: i32 = a_move.position.y.try_into().unwrap()
                - a_move.attack.y.try_into().unwrap();
            if apx > 0 {
                dpy == 0 && dpx > 0
            } else if apx < 0 {
                dpy == 0 && dpx < 0
            } else if apy > 0 {
                dpx == 0 && dpy < 0
            } else if apy < 0 {
                dpx == 0 && dpy > 0
            } else {
                false
            }
        },
        _ => panic!("Weapon id not found")
    }
}

fn get_hustler_new_state(
    hustler: Hustler, mut state: HustlerState, move: Move
) -> (MoveType, HustlerState) {
    state.system -= 1_u32.into();
    let move_type = get_move_type(hustler, state, move);
    let valid = match move_type {
        MoveType::Run => check_run_valid(hustler, state, move),
        MoveType::Attack => check_attack_valid(hustler, state, move),
        MoveType::Drugs => check_drugs_valid(hustler, state, move),
        MoveType::None => true,
    };
    if valid {
        match move_type {
            MoveType::Run => { state.position = move.position },
            MoveType::Drugs => { take_drugs(hustler, ref state, move); },
            MoveType::None | MoveType::Attack => {},
        };
    }
    (move_type, state)
}

fn get_speed(hustler: Hustler, state: HustlerState) -> u8 {
    hustler.items.shoes + if state.system.speed > 0 {
        1
    } else {
        0
    }
}

fn get_defence(hustler: Hustler, state: HustlerState) -> u8 {
    hustler.items.clothes + if state.system.ketamine > 0 {
        1
    } else {
        0
    }
}

fn get_move_type(hustler: Hustler, state: HustlerState, move: Move) -> MoveType {
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
    if moves != 1 {
        return MoveType::None;
    }
    if move.position != state.position {
        return MoveType::Run;
    } else if move.drugs.is_non_zero() {
        return MoveType::Drugs;
    } else if move.attack != move.position {
        return MoveType::Attack;
    }
    return MoveType::None;
}

fn take_drugs(hustler: Hustler, ref state: HustlerState, move: Move) {
    state.system += move.drugs;
}

fn check_run_valid(hustler: Hustler, state: HustlerState, move: Move) -> bool {
    if move.position.x < 10 && move.position.y < 10 {
        return false;
    }
    let dx: i32 = state.position.x.try_into().unwrap() - move.position.x.try_into().unwrap();
    let dy: i32 = state.position.y.try_into().unwrap() - move.position.y.try_into().unwrap();
    if !(dx.is_zero() || dy.is_zero() || dx == dy || dx == -dy) {
        return false;
    }
    let speed: i32 = get_speed(hustler, state).into() + 2;
    if (dx < -speed || speed < dx || dy < -speed || speed < dy) {
        return false;
    }
    return true;
}


fn check_attack_valid(hustler: Hustler, state: HustlerState, move: Move) -> bool {
    let dx: i32 = state.position.x.try_into().unwrap() - move.attack.x.try_into().unwrap();
    let dy: i32 = state.position.y.try_into().unwrap() - move.attack.y.try_into().unwrap();

    match hustler.items.weapon {
        0 |
        1 => {
            let range: i32 = hustler.items.weapon.into() + 1;
            dx <= range && -range <= dx && dy <= range && -range <= dy
        },
        2 => { dx == 0 || dy == 0 },
        _ => panic!("Weapon id not found")
    }
}
fn check_drugs_valid(hustler: Hustler, state: HustlerState, move: Move) -> bool {
    true
}


#[derive(Copy, Drop, PartialEq)]
enum MoveType {
    Run,
    Attack,
    Drugs,
    None,
}
