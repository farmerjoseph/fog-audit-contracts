# FoG Audit Contracts
This repo contains the most crucial smart contracts that require auditing ASAP. 
- FarmsOfGalileo.sol is an ERC721A contract that will be deployed to Ethereum. 
- FarmingGalilean.sol is an ERC721Enumerable contract that will be deployed to Polygon. It will interact with other contracts, however those are out of scope for an audit (for now). 
- GameContract.sol is an abstract contract used in many game contracts, and it is included here as it is crucial to understanding some of the logic of FarmingGalilean.sol

The following contract is NOT in scope for an audit, but it is provided for convenience:
- ERC721AUpgradeable.sol

It is important to note that these two contracts will be mapped and bridge-able by Polygon's PoS bridge. See their documentation for more info: https://docs.polygon.technology/docs/develop/ethereum-polygon/pos/getting-started. WE ARE NOT building our own custom bridge.

Additionally, some of these files may be importing non-existent files - these contracts were pulled from our main repository where all other files live. This repo is just to give an idea of what we'd like to be in scope for an audit.

Unit tests for these contracts exist, but are not included here. There is also a lack of documentation, but we'd be happy to provide whatever is necessary.
