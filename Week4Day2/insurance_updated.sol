//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Tech Insurance tor
 * @dev 
 * Step1: Complete the functions in the insurance smart contract
 * Step2:Add any required methods that are needed to check if the function are called correctly, 
 * and also add a modifier function that allows only the owner can run the changePrice function.
 * Step3: Add any error handling that may occur in any function
 * Step4: Add a modifer function to check the time if the client insurance is valid.
 * Step5 (opcional): Add a refund function that refunds money back to the client after one week. Guaranteed Money Back Plan.  
 * Step6: implement ERC 721 Token to this contract and change what it needs to be changed. 
 * 
 */
// import "./timestamp.sol" ;
import "../github/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
contract TechInsurance is ERC721 {

//contract TechInsurance is, ERC721 {

//event LogRefund(address client, uint time);
    /** 
     * Defined two structs
     * 
     * 
     */
    struct Product {
        uint productId;
        string productName;
        uint price;
        bool offered;
    }
     
    struct Client {
        bool isValid;
        uint time;

    }
    

    mapping(uint => Product) public productIndex;
    mapping(address => mapping(uint => Client)) public client;
    
    uint productCounter;
    
    address payable insOwner;
    
    // constructor is like the class + permission
    
    constructor(address payable _insOwner) public ERC721("Elite", "code"){
      insOwner = _insOwner;
   }
 
    function addProduct(uint _productId, string memory _productName, uint _price ) public {
        require(msg.sender == insOwner);
        productCounter++;
        Product memory newProduct =Product(_productId, _productName, _price, true);
        productIndex[productCounter++] = newProduct;
        _mint(msg.sender, productCounter);
    }
    
    
    function doNotOffer(uint _productIndex) public {
        require(msg.sender == insOwner, "I'm not offer it");
        productIndex[_productIndex].offered = false;

    }
    
    function forOffer(uint _productIndex) public {
        require(msg.sender == insOwner, "I'm offer it");
        productIndex[_productIndex].offered = true;

    }

    function changePrice(uint _productIndex, uint _price) public {
        require(insOwner == msg.sender, "you are not the owner");
        productIndex[_productIndex].price = _price;
        //why changePrice not setPrice
        //why >=1
    }
    
    // handling the error
    /**
    * @dev 
    * Every client buys an insurance, 
    * you need to map the client's address to the id of product to struct client, using (client map)
    */
    
     function buyInsurance(uint _productIndex) public payable {
        require(productIndex[_productIndex].price == msg.value, "Not appropriate" );
        require( productIndex[_productIndex].price == 0, "Not valid index");
        
        Client memory newClient;
        newClient.isValid = true;
        newClient.time = block.number;
        client[msg.sender][_productIndex] = newClient;
        insOwner.transfer(msg.value);
        
    } 
  
  /**  
    function refund(uint _client) public returns(bool) {
    require(client > 0);
    require(client <= time[msg.value]);
    price[msg.sender] -= client;
    LogRefund(msg.sender, client);
    msg.sender.transfer(client);
    return true;
}
*/
    } 
    
