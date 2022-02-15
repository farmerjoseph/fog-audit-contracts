# FoG Audit Contracts
This repo contains the most crucial smart contracts that require auditing ASAP. 
- FarmsOfGalileo.sol is an ERC721A contract that will be deployed to Ethereum. 
- FarmingGalilean.sol is an ERC721Enumerable contract that will be deployed to Polygon. It will interact with other contracts, however those are out of scope for an audit (for now). 

It is important to note that these two contracts will be mapped and bridge-able by Polygon's PoS bridge. See their documentation for more info: https://docs.polygon.technology/docs/develop/ethereum-polygon/pos/getting-started. WE ARE NOT building our own custom bridge.
