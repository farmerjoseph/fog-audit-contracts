//SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "./ERC721AUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/cryptography/MerkleProofUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";

error UserNotOnWhitelist();
error SenderNotAnEOA();
error WhitelistMintingPeriodEnded();
error MaxTokensReachedForAddress();
error InvalidPaymentAmount();
error NoTokensLeft();
error NonExistentToken();

contract FarmsOfGalileo is
    Initializable,
    ERC721AUpgradeable,
    PausableUpgradeable,
    OwnableUpgradeable,
    ReentrancyGuardUpgradeable,
    AccessControlUpgradeable
{
    event GalileanMinted(uint256 indexed tokenId);

    bytes32 public constant PREDICATE_ROLE = keccak256("PREDICATE_ROLE");
    uint8 constant MAX_NUMBER_OF_MINTS_PER_ADDRESS = 2;

    uint256 public wlPrice;
    uint256 public publicPrice;
    bool public publicSaleStarted;
    uint256 public wlEndTime;

    bytes32 merkleRoot;

    uint256 public maxTokens;
    mapping(uint256 => string) private tokenURIs;
    string private _baseTokenURI;

    modifier onlyEOA() {
        if (tx.origin != _msgSender()) revert SenderNotAnEOA();
        _;
    }

    function initialize() public initializer {
        __ERC721A_init("Farms of Galileo", "FoG");
        __Ownable_init();
        __Pausable_init();
        __AccessControl_init();

        _pause();
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());

        // TODO: change to 0xE6F45376f64e1F568BD1404C155e5fFD2F80F7AD for mainnet
        _setupRole(PREDICATE_ROLE, 0x74D83801586E9D3C4dc45FfCD30B54eA9C88cf9b);

        // TODO: Change this back to original price when ready
        wlPrice = .01 ether;
        publicPrice = .15 ether;
        maxTokens = 9889;
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721AUpgradeable, AccessControlUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function mint(uint8 amount, bytes32[] calldata merkleProof)
        external
        payable
        whenNotPaused
        onlyEOA
        nonReentrant
    {
        if (block.timestamp > wlEndTime) revert WhitelistMintingPeriodEnded();
        bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
        if (!MerkleProofUpgradeable.verify(merkleProof, merkleRoot, leaf))
            revert UserNotOnWhitelist();
        if (
            _numberMinted(_msgSender()) + amount >
            MAX_NUMBER_OF_MINTS_PER_ADDRESS
        ) revert MaxTokensReachedForAddress();
        if (msg.value != amount * (publicSaleStarted ? publicPrice : wlPrice))
            revert InvalidPaymentAmount();
        if (totalSupply() + amount > maxTokens) revert NoTokensLeft();

        _safeMint(_msgSender(), amount);
    }

    function setTokenMetadata(uint256 tokenId, bytes calldata data) external {
        require(
            hasRole(PREDICATE_ROLE, _msgSender()),
            "Insufficient permissions"
        );
        string memory uri = abi.decode(data, (string));
        setTokenURI(tokenId, uri);
    }

    function setTokenURI(uint256 tokenId, string memory _tokenURI) internal {
        tokenURIs[tokenId] = _tokenURI;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        require(_exists(tokenId), "URI query for nonexistent token");

        if (bytes(tokenURIs[tokenId]).length == 0) {
            return super.tokenURI(tokenId);
        } else {
            return tokenURIs[tokenId];
        }
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function setBaseURI(string calldata baseURI) external onlyOwner {
        _baseTokenURI = baseURI;
    }

    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
        merkleRoot = _merkleRoot;
    }

    function setWLEndTime(uint256 _wlEndTime) external onlyOwner {
        wlEndTime = _wlEndTime;
    }

    function setPublicSaleStarted(bool _publicSaleStarted) external onlyOwner {
        publicSaleStarted = _publicSaleStarted;
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function pause() external onlyOwner {
        _pause();
    }
}
