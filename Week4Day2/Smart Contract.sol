pragma solidity >=0.4.16 <0.9.0;
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
 * I used ERC712 insted of ERC721
 */
 import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC712/ERC712.sol";




contract TechInsurance is ERC712 {


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

    function deposit(bytes32 _id) public payable {
        // Events are emitted using `emit`
        emit Deposit(msg.sender, _id, msg.value);
    }
}
    
  //  mapping(uint => Product) public productIndex;
    //mapping(address => mapping(uint => Client)) public client;
    
    uint productCounter;
    
    address payable insOwner;
    // constructor(address payable _insOwner) public{
    //     insOwner = _insOwner;
    // }
 
    function addProduct(uint _productId, string memory _productName, uint _price ) public {
        productCounter++;
        Product memory newProduct =Product(_productId, _productName, _price, true);
        productIndex[productCounter++] = newProduct;
    }
    function doNotOffer(uint _productIndex) public returns(bool) {
        require(msg.sender == insOwner, "I'm not offer it");
        return productIndex[_productIndex].offered == false;

    }
    
    function forOffer(uint _productIndex) public returns(bool) {
        require(msg.sender == insOwner, "I'm offer it");
        return productIndex[_productIndex].offered ==true;

    }
    
    function changeFalse(uint _productIndex) public {
        productIndex[_productIndex].offered = fals;
    }
    
    function changeTrue(uint _productIndex) public {
        

    }
    // handling the error
    function setPrice (uint _price) public {
        uint price = _price;
        require(insOwner == msg.sender, "you are not the owner");
    }
    
    function changePrice(uint _productIndex, uint _price) public {
        require(productIndex[_productIndex].price >= 1, "not valid index" );
        productIndex[_productIndex].price== _price;
    }
    
    function clientSelect(uint _productIndex) public payable returns(bool) {
        require(productIndex[_productIndex].price == msg.value, "Not appropriate" );
        require( productIndex[_productIndex].price == 0, "Not valid index");
        
        Client memory newClient;
        newClient.isValid = true;
        newClient.time = block.number;
        client[msg.sender][_productIndex] = newClient;
        insOwner.transfer(msg.value);
        
    } 
    
    // require:(msg.sender == owner, "you enter the message");    
    // assert(a.length != 4)
    // if(msg.sender != owner){
    //     revert(‘you are not the owner’)
    // } 
    
//}

contract OwnedToken {
    TokenCreator creator;
    address owner;
    bytes32 name;
    
    // creator and the assigned name.
    constructor(bytes32 _name) {
        owner = msg.sender;
        creator = TokenCreator(msg.sender);
        name = _name;
    }
        function changeName(bytes32 newName) public {
        // Only the creator can alter the name.
        if (msg.sender == address(creator))
            name = newName;
    }

    function transfer(address newOwner) public {
        // Only the current owner can transfer the token.
        if (msg.sender != owner) return;
        // the execution also fails here.
        if (creator.isTokenTransferOK(owner, newOwner))
            owner = newOwner;
    }
}

//Receive Ether Function
contract Sink {
    event Received(address, uint);
    receive() external payable {
        emit Received(msg.sender, msg.value);
    }
}



contract TokenCreator {
    function createToken(bytes32 name)
        public
        returns (OwnedToken tokenAddress)
    {
        // Create a new `Token` contract and return its address.
        return new OwnedToken(name);
    }

    function changeName(OwnedToken tokenAddress, bytes32 name) public {
        tokenAddress.changeName(name);
    }

    // Perform checks to determine if transferring a token to the `OwnedToken` contract should proceed
    function isTokenTransferOK(address currentOwner, address newOwner)
        public
        pure
        returns (bool ok){
        // Check an arbitrary condition to see if transfer should proceed
        return keccak256(abi.encodePacked(currentOwner, newOwner))[0] == 0x7f;
    }
}

//Visibility and Getters
contract C {
    function f(uint a) private pure returns (uint b) { return a + 1; }
    function setData(uint a) internal { data = a; }
    uint public data;
    uint public data = 42; // for Getter Functions
// In the following codes: D, can call c.getData() to retrieve the value of data in state storage. Contract E is derived from C which  can call compute.
// start from this point...........
    uint private data;

    function f(uint a) private pure returns(uint b) { return a + 1; }
    function setData(uint a) public { data = a; }
    function getData() public view returns(uint) { return data; }
    function compute(uint a, uint b) internal pure returns (uint) { return a + b; }

     uint public data;// for Getter Functions
    function x() public returns (uint) {
        data = 3; // internal access
        return this.data(); // external access
        
        
    }
}
contract D {
    function readData() public {
        C c = new C();
        uint local = c.f(7); // error: member `f` is not visible
        c.setData(3);
        local = c.getData();
        local = c.compute(3, 5); // error: member `compute` is not visible
    }
}
contract E is C {
    function g() public {
        C c = new C();
        uint val = compute(3, 5); // access to internal member (from derived to parent contract)
    }
}
//end in this point


contract arrayExample {
    // public state variable
    uint[] public myArray;
    // function that returns entire array
    function getArray() public view returns (uint[] memory) {
        return myArray;
    }
}

//complex
contract Complex {
    struct Data {
        uint a;
        bytes3 b;
        mapping (uint => uint) map;
    }
    mapping (uint => mapping(bool => Data[])) public data;
}

//will generate a function of the following form
function data(uint arg1, bool arg2, uint arg3) public returns (uint a, bytes3 b) {
    a = data[arg1][arg2][arg3].a;
    b = data[arg1][arg2][arg3].b;
}

// overloading Function
contract A {
    function f(B _in) public pure returns (B out) {
        out = _in;
    }

    function f(address _in) public pure returns (address out) {
        out = _in;
    }
}
contract B {
}


//modifier Functions
contract owned {
    constructor() { owner = payable(msg.sender); }
    address payable owner;
    // This contract only defines a modifier but does not use it
    
    // function is executed
    modifier onlyOwner {
        require(
            msg.sender == owner,
            "Only owner can call this function."
        );
        _;
    }
    
}
contract destructible is owned {
    // This contract inherits the `onlyOwner` modifier from `owned` and applies it to the `destroy` function
    function destroy() public onlyOwner {
        selfdestruct(owner);
    }
}

contract Base1 is Destructible {
    function destroy() public virtual override { /* do cleanup 1 */ Destructible.destroy(); }
}

contract Base2 is Destructible {
    function destroy() public virtual override { /* do cleanup 2 */ Destructible.destroy(); }
}

contract Final is Base1, Base2 {
    function destroy() public override(Base1, Base2) { Base2.destroy(); }
}

//Abstract Contracts
abstract contract Feline {
    function utterance() public pure virtual returns (bytes32);
}

contract Cat is Feline {
    function utterance() public pure override returns (bytes32) { return "miaow"; }
}

contract priced {
    // Modifiers can receive arguments:
    modifier costs(uint price) {
        if (msg.value >= price) {
            _;
        }
    }
}
contract Register is priced, destructible {
    mapping (address => bool) registeredAddresses;
    uint price;

    constructor(uint initialPrice) { price = initialPrice; }

    // It is important to also provide the  `payable` keyword here, otherwise the function will automatically reject all Ether sent to it.
    function register() public payable costs(price) {
        registeredAddresses[msg.sender] = true;
    }

    function changePrice(uint _price) public onlyOwner {
        price = _price;
    }
}
contract Mutex {
    bool locked;
    modifier noReentrancy() {
        require(
            !locked,
            "Reentrant call."
        );
        locked = true;
        _;
        locked = false;
    }

// This function is protected by a mutex
    function f() public noReentrancy returns (uint) {
        (bool success,) = msg.sender.call("");
        require(success);
        return 7;
    }
}


////Fallback Function (test functions)
contract Test {
    // This function is called for all messages sent to this contract.
    fallback() external { x = 1; }
    uint x;
}

contract TestPayable {
    // This function is called for all messages sent to this contract, except plain Ether transfers
    fallback() external payable { x = 1; y = msg.value; }

    // This function is called for plain Ether transfers
    receive() external payable { x = 2; y = msg.value; }
    uint x;
    uint y;
}

contract Caller {
    
    // for Getter Functions
    C c = new C();
    function f() public view returns (uint) {
        return c.data();
    }
    
    function callTest(Test test) public returns (bool) {
        (bool success,) = address(test).call(abi.encodeWithSignature("nonExistingFunction()"));
        require(success);
        // results in test.x becoming == 1.

        // address(test) will not allow to call ``send`` directly, since ``test`` has no payable
        address payable testPayable = payable(address(test));

        // If someone sends Ether to that contract, the transfer will fail, i.e. this returns false here.
        return testPayable.send(2 ether);
    }

    function callTestPayable(TestPayable test) public returns (bool) {
        (bool success,) = address(test).call(abi.encodeWithSignature("nonExistingFunction()"));
        require(success);
        // results in test.x becoming == 1 and test.y becoming 0.
        (success,) = address(test).call{value: 1}(abi.encodeWithSignature("nonExistingFunction()"));
        require(success);
        // results in test.x becoming == 1 and test.y becoming 1.

        // If someone sends Ether to that contract, the receive function in TestPayable will be called.
        (success,) = address(test).call{value: 2 ether}("");
        require(success);
        // results in test.x becoming == 2 and test.y becoming 2 ether.

        return true;
    }
}
///////////////////////////////////////////////////////////
///Interfaces
//////////////////////////////////////////////////////////
interface Token {
    enum TokenType { Fungible, NonFungible }
    struct Coin { string obverse; string reverse; }
    function transfer(address recipient, uint amount) external;
}

interface ParentA {
    function test() external returns (uint256);
}

interface ParentB {
    function test() external returns (uint256);
}

interface SubInterface is ParentA, ParentB {
    // Must redefine test in order to assert that the parent
    // meanings are compatible.
    function test() external override(ParentA, ParentB) returns (uint256);
}

