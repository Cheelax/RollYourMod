#[derive(Copy, Drop, Serde)]
struct Drugs {
    shrooms: u32,
    cocaine: u32,
    ketamine: u32,
    speed: u32,
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
