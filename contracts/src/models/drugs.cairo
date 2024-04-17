#[derive(Copy, Drop, Serde, Introspect)]
struct Drugs {
    shrooms: u32,
    cocaine: u32,
    ketamine: u32,
    speed: u32,
}


impl DrugsZero of Zeroable<Drugs> {
    fn zero() -> Drugs {
        Drugs { shrooms: 0, cocaine: 0, ketamine: 0, speed: 0, }
    }
    fn is_zero(self: Drugs) -> bool {
        self.shrooms.is_zero()
            && self.cocaine.is_zero()
            && self.ketamine.is_zero()
            && self.speed.is_zero()
    }
    fn is_non_zero(self: Drugs) -> bool {
        self.shrooms.is_non_zero()
            && self.cocaine.is_non_zero()
            && self.ketamine.is_non_zero()
            && self.speed.is_non_zero()
    }
}

impl DrugsSubEq of SubEq<Drugs> {
    fn sub_eq(ref self: Drugs, other: Drugs) {
        self.shrooms -= other.shrooms;
        self.cocaine -= other.cocaine;
        self.ketamine -= other.ketamine;
        self.speed -= other.speed;
    }
}


impl DrugsAddEq of AddEq<Drugs> {
    fn add_eq(ref self: Drugs, other: Drugs) {
        self.shrooms += other.shrooms;
        self.cocaine += other.cocaine;
        self.ketamine += other.ketamine;
        self.speed += other.speed;
    }
}

impl DrugsAdd of Add<Drugs> {
    fn add(lhs: Drugs, rhs: Drugs) -> Drugs {
        Drugs {
            shrooms: lhs.shrooms + rhs.shrooms,
            cocaine: lhs.cocaine + rhs.cocaine,
            ketamine: lhs.ketamine + rhs.ketamine,
            speed: lhs.speed + rhs.speed,
        }
    }
}

impl DrugsSub of Sub<Drugs> {
    fn sub(lhs: Drugs, rhs: Drugs) -> Drugs {
        Drugs {
            shrooms: lhs.shrooms - rhs.shrooms,
            cocaine: lhs.cocaine - rhs.cocaine,
            ketamine: lhs.ketamine - rhs.ketamine,
            speed: lhs.speed - rhs.speed,
        }
    }
}


impl DrugsPartialOrd of PartialOrd<Drugs> {
    #[inline(always)]
    fn le(lhs: Drugs, rhs: Drugs) -> bool {
        lhs.shrooms <= rhs.shrooms
            && lhs.cocaine <= rhs.cocaine
            && lhs.ketamine <= rhs.ketamine
            && lhs.speed <= rhs.speed
    }
    #[inline(always)]
    fn ge(lhs: Drugs, rhs: Drugs) -> bool {
        lhs.shrooms >= rhs.shrooms
            && lhs.cocaine >= rhs.cocaine
            && lhs.ketamine >= rhs.ketamine
            && lhs.speed >= rhs.speed
    }
    #[inline(always)]
    fn lt(lhs: Drugs, rhs: Drugs) -> bool {
        lhs.shrooms < rhs.shrooms
            && lhs.cocaine < rhs.cocaine
            && lhs.ketamine < rhs.ketamine
            && lhs.speed < rhs.speed
    }
    #[inline(always)]
    fn gt(lhs: Drugs, rhs: Drugs) -> bool {
        lhs.shrooms > rhs.shrooms
            && lhs.cocaine > rhs.cocaine
            && lhs.ketamine > rhs.ketamine
            && lhs.speed > rhs.speed
    }
}
