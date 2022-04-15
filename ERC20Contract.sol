 pragma solidity ^0.6.6;
 
// Interface of the ERC20 standard as defined in the EIP.
interface ERC20Interface {
    // Returns the amount of tokens in existence.
   function totalSupply() external view returns (uint256);
    // Returns the amount of tokens owned by `account`
   function balanceOf(address account) external view returns (uint256);
    // Moves `amount` tokens from the caller's account to `recipient`. 
    // Returns a boolean value indicating whether the operation succeeded.
   function transfer(address recipient, uint256 amount) external returns (bool);
    // Returns the remaining number of tokens that `spender` will be allowed to spend
    // on behalf of `owner` through {transferFrom}. This is zero by default.  
   function allowance(address owner, address spender) external view returns (uint256);
    // Emits an {Approval} event.
    // Returns a boolean value indicating whether the operation succeeded.
   function approve(address spender, uint256 amount) external returns (bool);
    // Emits a {Transfer} event.
    // Moves `amount` tokens from `sender` to `recipient` using the allowance mechanism.
    // Returns a boolean value indicating whether the operation succeeded.
   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    // Emitted when `value` tokens are moved from one account (`from`) to another (`to`).
  event Transfer(address indexed from, address indexed to, uint256 value);
    // Emitted when the allowance of a `spender` for an `owner` is set by a call to {approve}. 
    // `value` is the new allowance.
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

// refers to https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol
library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;
        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }

}

contract X7208Token is ERC20Interface {
    using SafeMath for uint256;
    
    string public symbol;
    string public name;
    uint8 public decimals;
    uint public _totalSupply;
    address public tokenOwner;
    
    mapping(address => uint) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    
    constructor() public {
        tokenOwner = msg.sender; // Token owner to be the Ethereum account(connected to MetaMask)
        symbol="X7208"; // UNIQUE token Symbol
        name="ECR20-Token-X7208"; // UNIQUE token Name
        decimals=18; // 18 decimal places per token.
        _totalSupply = 1000000 * 10**uint(decimals); // Total supply of 1 million tokens.
        _balances[tokenOwner] = _totalSupply;
        emit Transfer(address(0), tokenOwner, _totalSupply);
    }
    
    function totalSupply() public view override returns (uint256) {
        return _totalSupply - _balances[address(0)];
    }
    
    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }
    
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }
    
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        address sender = msg.sender;
        
        _balances[sender] = _balances[sender].sub(amount, "transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
        return true;
    }
    
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        address sender = msg.sender;
        
        _allowances[sender][spender] = amount;
        emit Approval(sender, spender, amount);
        return true;
    }
    
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        
        _balances[sender] = _balances[sender].sub(amount, "transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
        
        _allowances[sender][recipient] = amount;
        emit Approval(sender, recipient, amount);
        return true;
    }
}