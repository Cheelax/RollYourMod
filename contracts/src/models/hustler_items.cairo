#[derive(Copy, Drop, Serde, Introspect)]
struct HustlerItems {
    weapon: u8,
    clothes: u8,
    shoes: u8,
    bag: u8,
}
