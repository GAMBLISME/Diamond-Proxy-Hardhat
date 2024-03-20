pragma solidity ^0.8.0;

import "./FacetA.sol";


library LibB {

    struct DiamondStorage {
        bytes32 dataB;
    }

    function diamondStorage() internal pure returns (DiamondStorage storage ds) {
        bytes32 storagePosition = keccak256("diamond.storage.LibB");
        assembly {
            ds.slot := storagePosition
        }
    }
}

contract FacetB {
    function setDataA(bytes32 _dataA) external {
        LibA.DiamondStorage storage ds = LibA.diamondStorage();
        ds.dataA = _dataA;
    }

    function getDataA() external view returns (bytes32) {
        return LibA.diamondStorage().dataA;
    }

    function setDataB(bytes32 _dataB) external {
        LibB.DiamondStorage storage ds = LibB.diamondStorage();
        ds.dataB = _dataB;
    }

    function getDataB() external view returns (bytes32) {
        return LibB.diamondStorage().dataB;
    }

}
