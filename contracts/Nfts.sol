// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Nfts is ERC721Enumerable,Ownable {
    string public baseURI;//main path for nft's
    mapping(uint256 => string) private _hashIPFS;//different nft's hashes

    constructor (string memory _name, string memory _symbol)
        ERC721(_name,_symbol)
    {
        baseURI ="https://gateway.pinata.cloud/ipfs/";
    }

    function mint(address _to, string[] memory _hashes) public onlyOwner{
        uint256 supply=totalSupply();
        for (uint256 i=0; i<_hashes.length;i++)
        {
            _safeMint(_to,supply+1);
            _hashIPFS[supply+1]=_hashes[i];
        }
    }

    //returns all the NFT's id's owned by an address
    function walletOfOwner(address _owner) public view returns (uint256[] memory){
        uint256 ownerTokenCount=balanceOf(_owner);
        uint256[] memory tokenIds=new uint256[](ownerTokenCount);
        for(uint256 i=0; i<ownerTokenCount; i++){
            tokenIds[i]=tokenOfOwnerByIndex(_owner,i);
        }
        return tokenIds;
    }

    //returns the URL path where the NFT metadata is located
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory){
        require(_exists(tokenId),"ERC721Metadata: URI query for nonexistent token");
        string memory currentBaseURI=_baseURI();
        return (bytes(currentBaseURI).length>0 && bytes(_hashIPFS[tokenId]).length>0)
        ? string(abi.encodePacked(currentBaseURI,_hashIPFS[tokenId]))
        :"";
    }

    function _baseURI() internal view virtual override returns (string memory){
        return baseURI;
    }

    //if we want to change the NFT metadata repository 
    function _setBaseURI(string memory _newBaseURI) public onlyOwner{
        baseURI = _newBaseURI;
    }


}
