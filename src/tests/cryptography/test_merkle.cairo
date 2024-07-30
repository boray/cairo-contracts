use core::array::ArrayTrait;
use core::array::SpanTrait;
use core::traits::IndexView;
use openzeppelin::tests::mocks::merkle_mocks::MerkleMock;
use openzeppelin::utils::cryptography::merkle::IMerkle;
use openzeppelin::utils::cryptography::merkle::MerkleComponent::InternalTrait;
use openzeppelin::utils::cryptography::merkle::MerkleComponent;

type ComponentState = MerkleComponent::ComponentState<MerkleMock::ContractState>;

fn COMPONENT_STATE() -> ComponentState {
    MerkleComponent::component_state_for_testing()
}

#[test]
fn test_verify() {
    let state = COMPONENT_STATE();
    let root: felt252 =
        1850176035909317702641801443656518155730822398598310061385106724886955157129;
    let leaf: felt252 =
        1145740579986834829318467109289126196422112283458566209179034823478827791393;
    let proof = array![
        3128043887554350334570628527917084743624356612532641151385005685036883923477,
        3199137689127638735821567539304588578621748835328519522657200918745156543758
    ];
    let verified = state.verify(proof.span(), root, leaf);
    assert!(verified);
}

#[test]
fn test_process_proof() {
    let state = COMPONENT_STATE();
    let root: felt252 =
        1850176035909317702641801443656518155730822398598310061385106724886955157129;
    let leaf: felt252 =
        1145740579986834829318467109289126196422112283458566209179034823478827791393;
    let proof = array![
        3128043887554350334570628527917084743624356612532641151385005685036883923477,
        3199137689127638735821567539304588578621748835328519522657200918745156543758
    ];
    let calculated_root = state.process_proof(proof.span(), leaf);
    assert!(root == calculated_root);
}

#[test]
fn test_hash_pair() {
    let state = COMPONENT_STATE();
    let a: felt252 = 1145740579986834829318467109289126196422112283458566209179034823478827791393;
    let b: felt252 = 3128043887554350334570628527917084743624356612532641151385005685036883923477;
    let hash = state.hash_pair(a, b);
    assert!(hash == 1900225184366056792646768334967933363693497539683138226478475382613028893534);
}
// a 1145740579986834829318467109289126196422112283458566209179034823478827791393
// b 3128043887554350334570628527917084743624356612532641151385005685036883923477
// c 1045740579986834829318467109289126196422112283458566209179034823478827791393
// d 1628043887554350334570628527917084743624356612532641151385005685036883923477

// ab 1900225184366056792646768334967933363693497539683138226478475382613028893534
// cd 3199137689127638735821567539304588578621748835328519522657200918745156543758

// abcd 1850176035909317702641801443656518155730822398598310061385106724886955157129

// a:leaf, proof[b,cd], root

