use openzeppelin::account::utils::secp256k1::{
    DebugSecp256k1Point, Secp256k1PointPartialEq, Secp256k1PointStorePacking as StorePacking
};
use starknet::SyscallResultTrait;
use starknet::secp256_trait::{Secp256Trait, Secp256PointTrait};
use starknet::secp256k1::Secp256k1Point;

use super::ethereum::common::get_points;

#[test]
fn test_pack_big_secp256k1_points() {
    let (big_point_1, big_point_2) = get_points();
    let curve_size = Secp256Trait::<Secp256k1Point>::get_curve_size();

    // Check point 1

    let (xlow, xhigh_and_parity) = StorePacking::pack(big_point_1);
    let xhigh_and_parity: u256 = xhigh_and_parity.into();

    let x = u256 {
        low: xlow.try_into().unwrap(), high: (xhigh_and_parity / 2).try_into().unwrap()
    };
    let parity = xhigh_and_parity % 2 == 1;

    assert_eq!(x, curve_size);
    assert_eq!(parity, true, "Parity should be odd");

    // Check point 2

    let (xlow, xhigh_and_parity) = StorePacking::pack(big_point_2);
    let xhigh_and_parity: u256 = xhigh_and_parity.into();

    let x = u256 {
        low: xlow.try_into().unwrap(), high: (xhigh_and_parity / 2).try_into().unwrap()
    };
    let parity = xhigh_and_parity % 2 == 1;

    assert_eq!(x, curve_size);
    assert_eq!(parity, false, "Parity should be even");
}

#[test]
fn test_unpack_big_secp256k1_points() {
    let (big_point_1, big_point_2) = get_points();

    // Check point 1

    let (expected_x, expected_y) = big_point_1.get_coordinates().unwrap_syscall();

    let (xlow, xhigh_and_parity) = StorePacking::pack(big_point_1);
    let (x, y) = StorePacking::unpack((xlow, xhigh_and_parity)).get_coordinates().unwrap_syscall();

    assert_eq!(x, expected_x);
    assert_eq!(y, expected_y);

    // Check point 2

    let (expected_x, _) = big_point_2.get_coordinates().unwrap_syscall();

    let (xlow, xhigh_and_parity) = StorePacking::pack(big_point_2);
    let (x, _) = StorePacking::unpack((xlow, xhigh_and_parity)).get_coordinates().unwrap_syscall();

    assert_eq!(x, expected_x);
    assert_eq!(y, expected_y);
}

#[test]
fn test_partial_eq() {
    let (big_point_1, big_point_2) = get_points();

    assert_eq!(big_point_1, big_point_1);
    assert_eq!(big_point_2, big_point_2);
    assert!(big_point_1 != big_point_2);
    assert!(big_point_2 != big_point_1);
}
