trait TwoZero<T> {
    fn is_zero(self: T) -> bool;
    fn is_non_zero(self: T) -> bool;
}

#[derive(Copy, Drop, Print, Serde, PartialEq)]
enum AB {
    A,
    B,
}


impl BitNotAB of BitNot<AB> {
    fn bitnot(a: AB) -> AB {
        match a {
            AB::A => AB::B,
            AB::B => AB::A,
        }
    }
}
impl NotAB of Not<AB> {
    fn not(a: AB) -> AB {
        match a {
            AB::A => AB::B,
            AB::B => AB::A,
        }
    }
}
